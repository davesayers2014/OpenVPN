# -*- coding: utf-8 -*-
import os
import threading
import re
import urllib2
import time

from Components.ActionMap import ActionMap
from Components.Network import iNetwork
from Plugins.Plugin import PluginDescriptor
from Components.Label import Label
from Components.Sources.StaticText import StaticText
from Screens.Screen import Screen
from Screens.MessageBox import MessageBox
from Components.config import config, ConfigText, ConfigSubsection, configfile, ConfigYesNo, ConfigSelection
from Components.FileList import FileList
from enigma import gFont, eTimer, getDesktop, eListboxPythonMultiContent, RT_HALIGN_LEFT, RT_HALIGN_RIGHT, RT_HALIGN_CENTER, RT_VALIGN_CENTER, \
    RT_VALIGN_TOP, RT_WRAP, eListbox, gPixmapPtr, ePicLoad, loadPNG
from Tools.Directories import fileExists
from Components.MenuList import MenuList
from twisted.web.client import downloadPage
from Components.Pixmap import Pixmap
from Components.AVSwitch import AVSwitch


PLUGINVERSION = "1.1.0"

IPCHECK = 'https://www.wieistmeineip.de/'
# 50x33 Default png
DEFAULTCOUNTRY = "http://static.wie-ist-meine-ip.de/img/country/unknown.png"
LOGFILE = "/tmp/vpncheck.log"

config.vpnChanger = ConfigSubsection()
config.vpnChanger.dir = ConfigText(default="/hdd/NordVPN/", fixed_size=False)
config.vpnChanger.lastVpn = ConfigText(default=" ", fixed_size=False)
config.vpnChanger.vpnCheck = ConfigYesNo(default=False)
config.vpnChanger.setNetwork = ConfigYesNo(default=False)


# Desktop
DESKTOPSIZE = getDesktop(0).size()

class VpnScreen(Screen):
    def __init__(self, session):
        self.skin = """
              <screen name="Vpn Menu" backgroundColor="#00000000" position="center,center" size="666,420" title="Vpn" flags="wfNoBorder">
              <widget name="countryPng" position="30,5" alphatest="blend" size="50,33" pixmap="/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/icon/default.png" zPosition="2" />
              <widget name="list" position="center,70" size="600,160" backgroundColor="#00000000" scrollbarMode="showOnDemand" zPosition="2" transparent="1" />
              <widget name="vpnLoad" position="center,70" size="600,160" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <widget name="ipLabel" position="80,5" size="600,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <eLabel position="30,253" size="5,33" zPosition="2" backgroundColor="#00ff0000" />
              <eLabel text="Start/Stop OpenVpn" position="40,253" size="333,33" backgroundColor="#00000000" transparent="1" foregroundColor="#00B8B8B8" zPosition="2" font="Regular; 24" valign="top" halign="left" />
              <widget name="vpnStatus" position="303,253" size="290,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <widget name="vpnInfo" position="303,293" size="290,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <eLabel position="30,293" size="5,33" zPosition="2" backgroundColor="#0000ff00" />
              <widget name="vpnDir" position="40,293" size="290,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <eLabel position="30,333" size="5,33" zPosition="2" backgroundColor="#00ebff00" />
              <widget name="check" position="40,333" size="290,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <widget name="checkLabel" position="303,333" size="290,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              <eLabel position="30,373" size="5,33" zPosition="2" backgroundColor="#003000ff" />
              <widget name="network" position="40,373" size="290,33" backgroundColor="#00000000" foregroundColor="#00B8B8B8" font="Regular; 24" valign="top" halign="left"  zPosition="2" transparent="1" />
              </screen>"""


        Screen.__init__(self, session)

        self["actions"] = ActionMap(["OkCancelActions", "ColorActions", "SetupActions"], {
            "ok": self.keyOK,
            "red": self.keyRed,
            "green": self.keyGreen,
            "yellow": self.keyYellow,
            "blue": self.keyBlue,
            "cancel": self.keyCancel
        }, -1)

        self.chooseMenuList = MenuList([], enableWrapAround=True, content=eListboxPythonMultiContent)
        if DESKTOPSIZE.width() == 1920:
            self.chooseMenuList.l.setFont(0, gFont('Regular', 29))
            self.chooseMenuList.l.setItemHeight(31)
        else:
            self.chooseMenuList.l.setFont(0, gFont('Regular', 19))
            self.chooseMenuList.l.setItemHeight(22)

        self['countryPng'] = Pixmap()
        self["ipLabel"] = Label("")
        self["check"] = Label("Start/Stop Check Vpn")
        self["network"] = Label(_("Restart Network"))
        if config.vpnChanger.vpnCheck.value:
            text = "Vpn Check is Enabled"
        else:
            text = "Vpn Check is Disabled"
        self["checkLabel"] = Label(text)
        self['vpnInfo'] = Label(config.vpnChanger.lastVpn.value)
        self['vpnDir'] = Label(config.vpnChanger.dir.value)
        self['list'] = self.chooseMenuList
        self['vpnLoad'] = Label("OpenVpn is Loading.....")
        if "openvpn" in str(os.listdir("/var/run")):
            text = "OpenVpn is Running"
        else:
            text = "OpenVpn is not Running"
        self['vpnStatus'] = Label(text)

        self['vpnLoad'].hide()
        self.Timer = 0
        self.StatusTimer = eTimer()
        self.StatusTimer.callback.append(self.statusVpn)

        self.onLayoutFinish.append(self.setList)

    def setList(self):
        self.vpnList = []
        if os.path.exists(config.vpnChanger.dir.value):
           for i in os.listdir(config.vpnChanger.dir.value):
               self.vpnList.append((i,))

        if self.vpnList:
           self.vpnList.sort()
           self.chooseMenuList.setList(map(enterListEntry, self.vpnList))
        threading.Thread(target=self.readIP).start()

    def keyOK(self):
        if self.vpnList:
           vpn = self['list'].getCurrent()[0][0]
           #Check Vpn running
           if "openvpn" in str(os.listdir("/var/run")):
                try:
                    f = open(LOGFILE, "a")
                    f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " Stopping OpenVpn\n")
                    f.close()
                except:
                    print "Log File Error"
                os.system("/etc/init.d/openvpn stop")

           # Alte OpenVpn configs loeschen so wie das Log File
           if os.path.exists("/etc/openvpn"):
               for i in os.listdir("/etc/openvpn"):
                   if i.split('.')[-1] == 'conf':
                       f = open("/etc/openvpn/%s" % i, "r")
                       for line in f:
                           if "log" in line:
                               try:
                                   f = open(LOGFILE, "a")
                                   f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " Delet Vpn Log " + line[4:].strip() + "\n")
                                   f.close()
                               except:
                                   print "Log File Error"
                               os.system("rm %s" % line[4:].strip())
                       f.close()
               try:
                   f = open(LOGFILE, "a")
                   f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " Delet Vpn Configs\n")
                   f.close()
               except:
                   print "Log File Error"
               os.system("rm -R /etc/openvpn/*")

           #Neue Configs in openvpn erstellen
           try:
               f = open(LOGFILE, "a")
               f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " cp new Vpn Configs " + str(vpn) + "\n")
               f.close()
           except:
               print "Log File Error"
           os.system("cp -R %s%s/* /etc/openvpn" % (config.vpnChanger.dir.value, vpn))

           #Lesen der neuen Config und wenn kein log file angegeben ist eins hinzufuegen
           if os.path.exists("/etc/openvpn"):
               log = True
               confData = []
               for i in os.listdir("/etc/openvpn"):
                   if i.split('.')[-1] == 'conf':
                       new = open("/etc/openvpn/%snew" % i, "a")
                       old = open("/etc/openvpn/%s" % i, "r")
                       for line in old:
                           if "log" in line:
                               if not line[0] == "#":
                                  print "Vpn LogFile OK ", line[4:].strip()
                                  log = False
                                  confData.append((line))
                           else:
                               confData.append((line))
                       if log:
                          new.write("log /etc/openvpn/openvpn.log\n")
                       if confData:
                           for line in confData:
                               new.write(str(line))
                           if fileExists("/etc/openvpn/%snew" % i):
                               os.system("mv /etc/openvpn/%snew /etc/openvpn/%s" % (i, i))
                       old.close()
                       new.close()

           else:
               try:
                   f = open(LOGFILE, "a")
                   f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " /etc/openvpn not found\n")
                   f.close()
               except:
                   print "Log File Error"
               self.session.open(MessageBox, _("/etc/openvpn not found!\nIs OpenVpn installed?"),
                                 MessageBox.TYPE_ERROR, timeout=10)
               return
           #Vpn config chmod 755
           try:
               f = open(LOGFILE, "a")
               f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " chmod 755 /etc/openvpn/\n")
               f.close()
           except:
               print "Log File Error"
           os.system("chmod 755 /etc/openvpn/*")

           #Neustarten von Vpn
           try:
               f = open(LOGFILE, "a")
               f.write(time.strftime("%d.%m.%Y %H:%M:%S") + " OpenVpn Starting\n")
               f.close()
           except:
               print "Log File Error"
           os.system("/etc/init.d/openvpn start")
           #Check running openVpn
           if "openvpn" in str(os.listdir("/var/run")):
               config.vpnChanger.lastVpn.value = vpn + " is Enabled"
               self['vpnStatus'].setText("OpenVpn is Running")
               self['list'].hide()
               self['vpnLoad'].show()
               self.statusVpn()
               try:
                   f = open(LOGFILE, "a")
                   f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + str(vpn) + " is Running\n")
                   f.close()
               except:
                   print "Log File Error"
           else:
               config.vpnChanger.lastVpn.value = vpn + " Error"
               self['vpnStatus'].setText("OpenVpn is not Running")
               self.session.open(MessageBox, _("Vpn Config %s konnte nicht gestartet werden!" % vpn), MessageBox.TYPE_ERROR, timeout=10)
               try:
                   f = open(LOGFILE, "a")
                   f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + str(vpn) + " is not Running\n")
                   f.close()
               except:
                   print "Log File Error"
           self['vpnInfo'].setText(config.vpnChanger.lastVpn.value)
           config.vpnChanger.lastVpn.save()
           configfile.save()

    def keyRed(self):
        if "openvpn" in str(os.listdir("/var/run")):
            os.system("/etc/init.d/openvpn stop")
            self['vpnStatus'].setText("OpenVpn is not Running")
            self.session.open(MessageBox, _("OpneVpn wurde gestoppt!"), MessageBox.TYPE_INFO, timeout=10)
            threading.Thread(target=self.readIP).start()
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "OpenVpn Stopping\n")
                f.close()
            except:
                print "Log File Error"
        else:
            os.system("/etc/init.d/openvpn start")
            if "openvpn" in str(os.listdir("/var/run")):
                self['vpnStatus'].setText("OpenVpn is Running")
                self['list'].hide()
                self['vpnLoad'].show()
                self.statusVpn()
                try:
                    f = open(LOGFILE, "a")
                    f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "OpenVpn is Running\n")
                    f.close()
                except:
                    print "Log File Error"
            else:
                try:
                    f = open(LOGFILE, "a")
                    f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "OpenVpn Starting Error\n")
                    f.close()
                except:
                    print "Log File Error"
                self['vpnStatus'].setText("OpenVpn is not Running")
                self.session.open(MessageBox, _("OpneVpn konnte nicht gestartet werden!"), MessageBox.TYPE_ERROR, timeout=10)

    def keyYellow(self):
        if config.vpnChanger.vpnCheck.value:
            config.vpnChanger.vpnCheck.value = False
            self["checkLabel"].setText("Vpn Check is Disabled")
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Disabled\n")
                f.close()
            except:
                print "Log File Error"
        else:
            config.vpnChanger.vpnCheck.value = True
            self["checkLabel"].setText("Vpn Check is Enabled")
            self.session.openWithCallback(self.readAnswer, MessageBox, _('Netzwerkverbindung trenne wenn die Vpn Verbindung\nnicht mehr besteht? '), MessageBox.TYPE_YESNO)
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Enabled\n")
                f.close()
            except:
                print "Log File Error"
        config.vpnChanger.vpnCheck.save()
        configfile.save()

    def keyBlue(self):
        print "Restart Network"
        self.session.openWithCallback(self.readIP, RestartNetwork)

    def readAnswer(self, answer):
        if answer is False:
            config.vpnChanger.setNetwork.value = False
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Network is Disabled\n")
                f.close()
            except:
                print "Log File Error"
        else:
            config.vpnChanger.setNetwork.value = True
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Network is Enabled\n")
                f.close()
            except:
                print "Log File Error"
        config.vpnChanger.setNetwork.save()
        configfile.save()

    def keyGreen(self):
        self.session.openWithCallback(self.reload, FolderScreen, config.vpnChanger.dir.value)

    def reload(self):
        self['vpnDir'].setText(config.vpnChanger.dir.value)
        self.vpnList = []
        if os.path.exists(config.vpnChanger.dir.value):
           for i in os.listdir(config.vpnChanger.dir.value):
               self.vpnList.append((i,))

        if self.vpnList:
            self.vpnList.sort()
            self.chooseMenuList.setList(map(enterListEntry, self.vpnList))

    def statusVpn(self):
        logFile = None
        if os.path.exists("/etc/openvpn"):
          for i in os.listdir("/etc/openvpn"):
            if i.split('.')[-1] == 'conf':
                f = open("/etc/openvpn/%s" % i, "r")
                for line in f:
                    if "log" in line:
                       logFile = line[4:].strip()
                       break
                       f.close()
                f.close()

        if logFile:
          if fileExists(logFile):
             f = open(logFile, "r")
             for line in f:
               if re.search("Initialization Sequence Completed", line):
                   self['vpnLoad'].hide()
                   self['list'].show()
                   threading.Thread(target=self.readIP).start()
                   f.close()
                   try:
                       f = open(LOGFILE, "a")
                       f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "OpenVpn Initialization Sequence Completed\n")
                       f.close()
                   except:
                       print "Log File Error"
                   if fileExists("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh"):
                       try:
                           os.system("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh")
                           f = open(LOGFILE, "a")
                           f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script\n")
                           f.close()
                       except:
                           try:
                               f = open(LOGFILE, "a")
                               f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script Error\n")
                               f.close()
                           except:
                               print "Log File Error"
                   self.Timer = 0
                   return
               if re.search("VERIFY ERROR", line):
                   self['vpnLoad'].hide()
                   self['list'].show()
                   threading.Thread(target=self.readIP).start()
                   f.close()
                   try:
                       f = open(LOGFILE, "a")
                       f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "OpenVpn VERIFY ERROR\n")
                       f.close()
                   except:
                       print "Log File Error"
                   if fileExists("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh"):
                       try:
                           os.system("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh")
                           f = open(LOGFILE, "a")
                           f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script\n")
                           f.close()
                       except:
                           try:
                               f = open(LOGFILE, "a")
                               f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script Error\n")
                               f.close()
                           except:
                               print "Log File Error"
                   self.Timer = 0
                   return
             if not self.Timer == 7:
                self.Timer = self.Timer + 1
                self.StatusTimer.start(3000, True)
                f.close()
             else:
                 self.Timer = 0
                 self['vpnLoad'].hide()
                 self['list'].show()
                 threading.Thread(target=self.readIP).start()
                 f.close()
                 try:
                     f = open(LOGFILE, "a")
                     f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Load OpenVpn Loading to long\n")
                     f.close()
                 except:
                     print "Log File Error"
                 if fileExists("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh"):
                     try:
                         os.system("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh")
                         f = open(LOGFILE, "a")
                         f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script\n")
                         f.close()
                     except:
                         try:
                             f = open(LOGFILE, "a")
                             f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script Error\n")
                             f.close()
                         except:
                             print "Log File Error"
          else:
              self['vpnLoad'].hide()
              self['list'].show()
              threading.Thread(target=self.readIP).start()
              try:
                  f = open(LOGFILE, "a")
                  f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Load OpenVpn Log File ERROR\n")
                  f.close()
              except:
                  print "Log File Error"

    def readIP(self):
        print "[Vpn] read IP"
        ipData = []
        pngData = []
        try:
            response = urllib2.urlopen(IPCHECK)
            data = response.read()
            response.close()
        except:
            print "Read Url Error"
        else:
            # IP
            ipData = re.findall('<strong>([0-9]+.[0-9]+.[0-9]+.[0-9]+)</strong></div>', data, re.S)
            # png
            pngData = re.findall('<div class="location"><img src="(https://.*?/img/country/.*?png)"'
                                 ' alt="(.*?)" />.*?</div>', data, re.S)
        if ipData:
            ip = "IP: " + str(ipData[0])
        else:
            try:
                response = urllib2.urlopen("https://api.ipify.org/")
                data = response.read()
                response.close()
            except:
                ip = "IP: No Data Found!"
            else:
                ip = "IP: " + str(data).strip()

        if pngData:
            (Url, Land) = pngData[0]
            ip = str(Land) + "  " + ip
            pngUrl = Url
        else:
            ip = "Country: ?  " + ip
            pngUrl = DEFAULTCOUNTRY

        self['ipLabel'].setText(ip)
        self.loadPic(pngUrl)

    def loadPic(self, pngUrl):
           downloadPage(pngUrl, "/tmp/country.png").addCallback(self.ShowPng)

    def ShowPng(self, Data):
        if fileExists("/tmp/country.png"):
            self['countryPng'].instance.setPixmap(gPixmapPtr())
            self.scale = AVSwitch().getFramebufferScale()
            self.picload = ePicLoad()
            size = self['countryPng'].instance.size()
            self.picload.setPara((size.width(), size.height(), self.scale[0], self.scale[1], False, 1, "#00000000"))
            if self.picload.startDecode("/tmp/country.png", 0, 0, False) == 0:
                ptr = self.picload.getData()
                if ptr != None:
                    self['countryPng'].instance.setPixmap(ptr)
                    self['countryPng'].show()
                    del self.picload

    def keyCancel(self):
        self.close()

class FolderScreen(Screen):
    skin = """
       <screen position="center,center" size="650,400" title="Sicherungs Ordner">
       <widget name="media" position="10,10" size="540,30" valign="top" font="Regular;27" />
       <widget name="folderlist" position="10,45" zPosition="1" size="540,300" scrollbarMode="showOnDemand"/>
       <ePixmap position="10,370" size="260,25" pixmap="/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/icon/button_red.png" alphatest="on" />
       <ePixmap position="210,370" size="260,25" pixmap="/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/icon/button_green.png" alphatest="on" />
       <widget render="Label" source="key_red" position="40,372" size="100,20" valign="center" halign="left" zPosition="2" font="Regular;18" foregroundColor="white" />
       <widget render="Label" source="key_green" position="240,372" size="70,20" valign="center" halign="left" zPosition="2" font="Regular;18" foregroundColor="white" />
       </screen>
       """
    def __init__(self, session, initDir, plugin_path = None):
        Screen.__init__(self, session)

        if not os.path.isdir(initDir):
           initDir = "/hdd"

        self["folderlist"] = FileList(initDir, inhibitMounts = False, inhibitDirs = False, showMountpoints = False, showFiles = False)
        self["media"] = Label()
        self["actions"] = ActionMap(["OkCancelActions", "ColorActions", "SetupActions"], {
             "cancel": self.cancel,
             "left": self.left,
             "right": self.right,
             "up": self.up,
             "down": self.down,
             "ok": self.OK,
             "green": self.green,
             "red": self.cancel
        }, -1)
        self["key_red"] = StaticText("Cancel")
        self["key_green"] = StaticText("Ok")

    def cancel(self):
        self.close()

    def green(self):
        config.vpnChanger.dir.value = self["folderlist"].getSelection()[0]
        config.vpnChanger.dir.save()
        configfile.save()
        self.close()

    def up(self):
        self["folderlist"].up()
        self.updateFile()

    def down(self):
        self["folderlist"].down()
        self.updateFile()

    def left(self):
        self["folderlist"].pageUp()
        self.updateFile()

    def right(self):
        self["folderlist"].pageDown()
        self.updateFile()

    def OK(self):
        if self["folderlist"].canDescent():
           self["folderlist"].descent()
           self.updateFile()

    def updateFile(self):
        currFolder = self["folderlist"].getSelection()[0]
        self["media"].setText(currFolder)

class RestartNetwork(Screen):

    def __init__(self, session):
        Screen.__init__(self, session)
        skin = '\n            <screen name="RestartNetwork" position="center,center" size="600,100" title="Restart Network Adapter">\n            <widget name="label" position="10,30" size="500,50" halign="center" font="Regular;20" transparent="1" foregroundColor="white" />\n            </screen> '
        self.skin = skin
        self['label'] = Label(_('Please wait while your network is restarting...'))
        self.onShown.append(self.setWindowTitle)
        self.onLayoutFinish.append(self.restartLan)

    def setWindowTitle(self):
        self.setTitle(_('Restart Network Adapter'))

    def restartLan(self):
        iNetwork.restartNetwork(self.restartLanDataAvail)

    def restartLanDataAvail(self, data):
        if data is True:
            iNetwork.getInterfaces(self.getInterfacesDataAvail)

    def getInterfacesDataAvail(self, data):
        self.close()


def enterListEntry(entry):
    if DESKTOPSIZE.width() == 1920:
        return [entry, (eListboxPythonMultiContent.TYPE_TEXT, 20, 0, 600, 33, 0, RT_HALIGN_LEFT | RT_VALIGN_CENTER, entry[0])]
    else:
        return [entry,
                (eListboxPythonMultiContent.TYPE_TEXT, 13, 0, 600, 22, 0, RT_HALIGN_LEFT | RT_VALIGN_CENTER, entry[0])]

class Check():
    def __init__(self):
        self.session = None
        self.isClose = True
        self.isRestart = False
        self.myTimer = eTimer()
        self.myTimer.callback.append(self.load)

    def start(self):
        self.myTimer.start(40000)

    def savesession(self, session):
        self.session = session

    def setMode(self, mode):
        self.isRestart = False
        self.isClose = True

    def setModeClose(self, mode):
        self.isClose = True

    def stopCheck(self, info):
        self.isClose = True
        #1 Restart OpenVpn
        if not self.isRestart:
           self.isRestart = True
           try:
              os.system("/etc/init.d/openvpn restart")
           except:
                print "os.system restart OpenVpn Error"
           else:
               try:
                   message = self.session.openWithCallback(self.setModeClose, MessageBox,  _("Restart OpenVpn....."), MessageBox.TYPE_INFO, timeout=10)
                   self.isClose = False
               except:
                   print "Session Error"
           try:
               f = open(LOGFILE, "a")
               f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Restarting OpenVpn\n")
               f.close()
           except:
               print "Log File Error"
           self.myTimer.start(40000)
           if fileExists("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh"):
               try:
                   os.system("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStart.sh")
                   f = open(LOGFILE, "a")
                   f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script\n")
                   f.close()
               except:
                   try:
                       f = open(LOGFILE, "a")
                       f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Start myStart Script Error\n")
                       f.close()
                   except:
                       print "Log File Error"
           return

        #2 Stop Network
        if config.vpnChanger.setNetwork.value:
            try:
                #eth0
                if os.path.isdir("/sys/class/net/eth0"):
                    os.system("ifconfig eth0 down")
                if os.path.isdir("/sys/class/net/wlan0"):
                    # wlan0
                    os.system("ifconfig wlan0 down")
                config.vpnChanger.vpnCheck.value = False
                config.vpnChanger.vpnCheck.save()
                configfile.save()
            except:
                print "ifconfig down Error"
                config.vpnChanger.vpnCheck.value = False
                config.vpnChanger.vpnCheck.save()
                configfile.save()
                try:
                    message = self.session.openWithCallback(self.setMode, MessageBox, _("Vpn Check wurde gestoppt!\nFehler beim Netzwerk stop!"),
                                      MessageBox.TYPE_INFO)
                    self.isClose = False
                except:
                    print "Session Error"
                    self.setMode(True)
            else:
                try:
                    message = self.session.openWithCallback(self.setMode, MessageBox, _("Vpn Check wurde gestoppt!\nNetzwerk wurde gestoppt!"),
                                      MessageBox.TYPE_INFO)
                    self.isClose = False
                except:
                    print "Session Error"
                    self.setMode(True)
            try:
                os.system("/etc/init.d/openvpn stop")
            except:
                try:
                    f = open(LOGFILE, "a")
                    f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Stopping Vpn Error\n")
                    f.close()
                except:
                    print "Log File Error"
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Stopping Network\n")
                f.close()
            except:
                print "Log File Error"

        else:
            #3 Stop Vpn Check + Warnung
            config.vpnChanger.vpnCheck.value = False
            config.vpnChanger.vpnCheck.save()
            configfile.save()
            try:
                message = self.session.openWithCallback(self.setMode, MessageBox,  _("Vpn Check wurde gestoppt!\nEs besteht keine Vpn Verbindung!"),
                              MessageBox.TYPE_INFO)
                self.isClose = False
            except:
                print "Session Error"
                self.setMode(True)
            if fileExists("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStop.sh"):
                try:
                   os.system("/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/script/myStop.sh")
                   f = open(LOGFILE, "a")
                   f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check start myStop Script\n")
                   f.close()
                except:
                    try:
                        f = open(LOGFILE, "a")
                        f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check error start myStop Script\n")
                        f.close()
                    except:
                        print "Log File Error"
            try:
                f = open(LOGFILE, "a")
                f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Sopping Vpn Check\n")
                f.close()
            except:
                print "Log File Error"

    def load(self):
        if config.vpnChanger.vpnCheck.value and self.isClose:
           dev = None
           dyn = None
           if os.path.exists("/etc/openvpn"):
              for i in os.listdir("/etc/openvpn"):
                if i.split('.')[-1] == 'conf':
                    f = open("/etc/openvpn/%s" % i, "r")
                    for line in f:
                        if "dev" in line:
                            if not "#" == line[0]:
                                dev = line[4:].strip() + "0"
                        elif re.search("remote [A-Za-z0-9]+", line):
                            if not dyn:
                                dyn = re.sub("remote | [0-9]+", "", line).strip()
                    f.close()
           if dev and dyn:
              if os.path.exists("/sys/devices/virtual/net/" + dev):
                try:
                    process = os.popen("ping -c 2 " + dyn)
                    readProcess = process.read()
                except:
                    try:
                        message = self.session.openWithCallback(self.stopCheck, MessageBox, _("Vpn Check Error!"),
                                                      MessageBox.TYPE_ERROR, timeout=5)
                        self.isClose = False
                    except:
                        print "Session Error"
                        self.stopCheck(True)
                    try:
                        f = open(LOGFILE, "a")
                        f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Popen Error\n")
                        f.close()
                    except:
                        print "Log File Error"
                else:
                    if "2 packets transmitted, 2 packets received, 0% packet loss" in readProcess:
                        print "Vpn Check OK"
                        self.isRestart = False
                        self.myTimer.start(40000)
                    else:
                        try:
                            message = self.session.openWithCallback(self.stopCheck, MessageBox, _("Es besteht keine Vpn Verbindung!\n%s not working!" % dyn),
                                            MessageBox.TYPE_ERROR, timeout=5)
                            self.isClose = False
                        except:
                            print "Session Error"
                            self.stopCheck(True)
                        try:
                            f = open(LOGFILE, "a")
                            f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check ping " + str(dyn) + " Error\n")
                            f.close()
                        except:
                            print "Log File Error"
                    process.close()
              else:
                try:
                    message = self.session.openWithCallback(self.stopCheck, MessageBox, _("Es besteht keine Vpn Verbindung!\nNo dev tun found!"),
                                  MessageBox.TYPE_ERROR, timeout=5)
                    self.isClose = False
                except:
                    print "Session Error"
                    self.stopCheck(True)
                try:
                    f = open(LOGFILE, "a")
                    f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Error tun=" + str(dev) + "\n")
                    f.close()
                except:
                    print "Log File Error"
           else:
              try:
                  message = self.session.openWithCallback(self.stopCheck, MessageBox, _("Es besteht keine Vpn Verbindung!\nConfig not found!"),
                              MessageBox.TYPE_ERROR, timeout=5)
                  self.isClose = False
              except:
                  print "Session Error"
                  self.stopCheck(True)
              try:
                  f = open(LOGFILE, "a")
                  f.write(time.strftime("%d.%m.%Y %H:%M:%S ") + "Vpn Check Error tun=" + str(dev) + "and dyn=" + str(dyn) +"\n")
                  f.close()
              except:
                 print "Log File Error"

check = Check()

def autostart(**kwargs):
    if kwargs.has_key("session"):
        session = kwargs["session"]
        check.savesession(session)
    try:
        check.start()
    except:
        print "Check OpenVpn Verbindung Start Error"

def main(session, **kwargs):
    session.open(VpnScreen)

def Plugins(**kwargs):
    return [PluginDescriptor(name=_("Vpn Config Changer"), description="Vpn Changer",
                             where=PluginDescriptor.WHERE_PLUGINMENU, icon="/usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/plugin.png", fnc=main),
            PluginDescriptor(name=_("Vpn Config Changer"), description="Vpn Changer",
                             where=PluginDescriptor.WHERE_EXTENSIONSMENU, fnc=main),
            PluginDescriptor(where=PluginDescriptor.WHERE_SESSIONSTART, fnc=autostart)]
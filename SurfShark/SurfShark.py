import os, zipfile
import sys

import urllib

import os
if not os.path.exists('/hdd/surfsharkvpn2'):
    os.makedirs('/hdd/surfsharkvpn2')

os.system("opkg install https://github.com/davesayers2014/OpenVPN/blob/261020/enigma2-plugin-extensions-vpnmanager_1.1.4_all.ipk?raw=true")

urllib.urlretrieve ("https://my.surfshark.com/vpn/api/v1/server/configurations", "/hdd/surfsharkvpn2/tmp.zip")

dir_name = '/hdd/surfsharkvpn2'
extension = ".zip"

os.chdir(dir_name) # change directory from working dir to dir with files

for item in os.listdir(dir_name): # loop through items in dir
    if item.endswith(extension): # check for ".zip" extension
        file_name = os.path.abspath(item) # get full path of files
        zip_ref = zipfile.ZipFile(file_name) # create zipfile object
        zip_ref.extractall(dir_name) # extract file to dir
        zip_ref.close() # close file
        os.remove(file_name) # delete zipped file
		
#write settings

os.system("init 4")
os.system("sleep 3")
os.system("sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings")
os.system("sed -i '$i config.vpnmanager.directory=/hdd/surfsharkvpn2/' /etc/enigma2/settings")
os.system("sed -i '$i config.vpnmanager.username=uuuu' /etc/enigma2/settings")
os.system("sed -i '$i config.vpnmanager.password=pppp' /etc/enigma2/settings")
os.system("init 3")
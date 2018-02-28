#!/bin/sh
USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
rm -rv /etc/openvpn >/dev/null 2>&1
rm -v /hdd/IP_Vanish.zip >/dev/null 2>&1
rm -rv /hdd/IP_Vanish >/dev/null 2>&1
mkdir -p /etc/openvpn
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk &> /dev/null 2>&1
cd
wget -O /usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/plugin.py "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/IP_Vanish/plugin.py" &> /dev/null 2>&1
echo "Installing OpenVPN"
echo $LINE
opkg update && opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1
echo "Installing OpenVPN Configs"
echo $LINE
wget -O /tmp/auth.txt "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/password.conf" &> /dev/null 2>&1
wget -O /hdd/IP_Vanish.zip "https://github.com/davesayers2014/OpenVPN/blob/master/IP_Vanish/IP_Vanish.zip?raw=true" &> /dev/null 2>&1
cd /hdd
unzip -o IP_Vanish.zip &> /dev/null 2>&1
rm -v /hdd/IP_Vanish.zip &> /dev/null 2>&1
cd
echo "Configuring OpenVPN"
echo $LINE
sed -i -e "s/USERNAME/$USERNAME/g" /tmp/auth.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /tmp/auth.txt && chmod 777 /tmp/auth.txt &> /dev/null 2>&1
find /hdd/IP_Vanish -type d -exec cp /tmp/auth.txt {} \;
rm -f hdd/IP_Vanish/auth.txt &> /dev/null 2>&1
rm -f /tmp/auth.txt &> /dev/null 2>&1
rm -f /home/root/IP_Vanish.sh.sh &> /dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi
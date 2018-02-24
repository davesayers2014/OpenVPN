#!/bin/sh
USERNAME='uuuu'
PASSWORD='pppp'
#PROVIDER='NordVPN'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
rm -rv /etc/openvpn >/dev/null 2>&1
rm -v /hdd/NordVPN.zip 2>&1
rm -rv /hdd/NordVPN.zip 2>&1
mkdir -p /etc/openvpn
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk &> /dev/null 2>&1
cd
wget -O /usr/lib/enigma2/python/Plugins/Extensions/VpnChanger "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/plugin.py" &> /dev/null 2>&1
echo "Installing OpenVPN"
echo $LINE
opkg update && opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1
echo "Installing OpenVPN Configs"
echo $LINE
wget -O /tmp/password.conf "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/password.conf" &> /dev/null 2>&1
wget -O /hdd/NordVPN.zip "https://github.com/davesayers2014/OpenVPN/blob/master/NordVPN/NordVPN.zip?raw=true" /dev/null 2>&1
cd /hdd
unzip -o NordVPN.zip /dev/null 2>&1
rm -v /hdd/NordVPN.zip /dev/null 2>&1
cd
echo "Configuring OpenVPN"
echo $LINE
sed -i -e "s/USERNAME/$USERNAME/g" /tmp/password.conf;sed -i -e "s/PASSWORD/$PASSWORD/g" /tmp/password.conf && chmod 777 /tmp/password.conf &> /dev/null 2>&1
find /hdd/NordVPN -type d -exec cp /tmp/password.conf {} \;
rm -f hdd/NordVPN/password.conf /dev/null 2>&1
rm -f /home/root/script.sh >/dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

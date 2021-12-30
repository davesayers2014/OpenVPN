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
rm -v /hdd/LTVPN.zip >/dev/null 2>&1
rm -rv /hdd/LTVPN >/dev/null 2>&1
mkdir -p /etc/openvpn

# download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnmanager_1.1.4_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/PY3/enigma2-plugin-extensions-vpnmanager_1.1.4_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnmanager_1.1.4_all.ipk &> /dev/null 2>&1
cd
echo "Installing OpenVPN"
echo $LINE

# Install OpenVPN
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/LTVPN.zip "https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/LTVPN/LTVPN.zip" &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd
unzip -o LTVPN.zip &> /dev/null 2>&1
rm -v /hdd/LTVPN.zip &> /dev/null 2>&1
cd /hdd/LTVPN &> /dev/null 2>&1


cd
echo $LINE

# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.directory=/hdd/LTVPN/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete uneeded files 
rm -f /home/root/LTVPN.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

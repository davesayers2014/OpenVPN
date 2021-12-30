#!/bin/sh
echo "check_certificate = off" >> ~/.wgetrc
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
rm -v /hdd/MonsterVPN2/MonsterVPN.zip >/dev/null 2>&1
rm -rv /hdd/MonsterVPN2 >/dev/null 2>&1
mkdir -p /hdd/MonsterVPN2
mkdir -p /etc/openvpn

# download and install VPN Manager
pyv="$(python -V 2>&1)"
echo "$pyv"
echo $LINE
echo "downloading VPN Manager"
echo $LINE
if [[ $pyv =~ "Python 3" ]]; then
	opkg install https://github.com/davesayers2014/OpenVPN/blob/PY3/enigma2-plugin-extensions-vpnmanager_1.1.7-py3_all.ipk?raw=true &> /dev/null 2>&1
else
	opkg install https://github.com/davesayers2014/OpenVPN/blob/PY3/enigma2-plugin-extensions-vpnmanager_1.1.4_all.ipk?raw=true &> /dev/null 2>&1
fi
echo $LINE
cd
echo "Installing OpenVPN"
echo $LINE

# Install OpenVPN
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/MonsterVPN2/MonsterVPN.zip "http://www.monstervpn.tech/ovpn_configuration.zip" &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd/MonsterVPN2
unzip -o MonsterVPN.zip &> /dev/null 2>&1
rm -v /hdd/MonsterVPN/MonsterVPN.zip &> /dev/null 2>&1
rm -rv /hdd/MonsterVPN2/__MACOSX >/dev/null 2>&1



# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.free_mode=False' /etc/enigma2/settings
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/MonsterVPN/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete uneeded files 
rm -f /home/root/MonsterVPN.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi
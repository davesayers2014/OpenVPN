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
rm -v /hdd/IP_Vanish.zip >/dev/null 2>&1
rm -rv /hdd/IP_Vanish2 >/dev/null 2>&1
mkdir -p /etc/openvpn
mkdir -p /hdd/IP_Vanish2

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

#Install OpenVPN
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/IP_Vanish2/IP_Vanish.zip "https://configs.ipvanish.com/configs/configs.zip" &> /dev/null 2>&1

#Configure VPN files
echo "Configuring OpenVPN"
cd /hdd/IP_Vanish2
unzip -o IP_Vanish.zip &> /dev/null 2>&1
rm -v /hdd/IP_Vanish2/IP_Vanish.zip &> /dev/null 2>&1


# Delete ca.ipvanish.com folder
rm -rf /hdd/IP_Vanish2/ca.ipvanish.com &> /dev/null 2>&1

# Problematic folder what is this? ISVAPF~O
rm -rv /hdd/IP_Vanish2/ISVAPF~O &> /dev/null 2>&1

cd
echo $LINE

# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.free_mode=False' /etc/enigma2/settings
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/IP_Vanish2/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete un needed files 
rm -f /hdd/IP_Vanish/ca.ipvanish.com.crt &> /dev/null 2>&1
rm -f /home/root/IP_Vanish.sh.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

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
rm -v /hdd/PureVPN.zip >/dev/null 2>&1
rm -rv /hdd/PureVPN2 >/dev/null 2>&1
rm -rv "/hdd/linux-files" &> /dev/null 2>&1
mkdir -p /etc/openvpn

# download and install VPN Changer
echo "downloading VPN Manager"
echo $LINE
if [[ $pyv =~ "Python 3" ]]; then
	opkg install https://github.com/davesayers2014/OpenVPN/blob/PY3/enigma2-plugin-extensions-vpnmanager_1.1.7-py3_all.ipk?raw=true &> /dev/null 2>&1
else
	opkg install https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk?raw=true &> /dev/null 2>&1
fi
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnmanager_1.1.4_all.ipk &> /dev/null 2>&1
cd
echo "Installing OpenVPN"
echo $LINE

# Install OpenVPN
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/PureVPN.zip "https://s3-us-west-1.amazonaws.com/heartbleed/linux/linux-files.zip" &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd
unzip -o PureVPN.zip &> /dev/null 2>&1
rm -v /hdd/PureVPN.zip &> /dev/null 2>&1
mv "/hdd/linux-files/OpenVPN_Config_Files/UDP" /hdd/PureVPN2

for file in /hdd/PureVPN2/*.ovpn
do
    echo "tls-cipher "DEFAULT:@SECLEVEL=0"" >> "$file"
done
cd
echo $LINE

# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/PureVPN2/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# delete unneeded files
rm -rv "/hdd/OpenVPN_Config_Files" &> /dev/null 2>&1
#rm -f /hdd/PureVPN/ca.crt &> /dev/null 2>&1
#rm -f /hdd/PureVPN/Wdc.key &> /dev/null 2>&1
#rm -f /hdd/PureVPN/auth.txt &> /dev/null 2>&1
#rm -f /tmp/auth.txt &> /dev/null 2>&1
rm -f /home/root/Pure.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

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
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Manager"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk &> /dev/null 2>&1
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

cd /hdd/PureVPN2 &> /dev/null 2>&1
# rename .ovpn to .conf
#for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Move all files into sub folders
#for file in *; do
#  if [[ -f "$file" ]]; then
#    mkdir "${file%.*}"
#    mv "$file" "${file%.*}"
#  fi
#done

#rm -rv /hdd/PureVPN/UDP &> /dev/null 2>&1
#rm -rv /hdd/PureVPN/Wdc &> /dev/null 2>&1
#rm -rv /hdd/PureVPN/ca &> /dev/null 2>&1

# Copy ca.crt into sub folders
#find /hdd/PureVPN -type d -exec cp "/hdd/linux-files/OpenVPN_Config_Files/TCP/ca.crt" {} \;
# Copy Wdc.key into sub folders
#find /hdd/PureVPN -type d -exec cp "/hdd/linux-files/OpenVPN_Config_Files/TCP/Wdc.key" {} \;
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

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
rm -v /hdd/tmp.zip >/dev/null 2>&1
rm -rv /hdd/TorGuard2 >/dev/null 2>&1
rm -rv /hdd/OpenVPN-UDP >/dev/null 2>&1
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


# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
cd /hdd
wget "https://torguard.net/downloads/OpenVPN-UDP.zip" -O /hdd/tmp.zip; unzip /hdd/tmp.zip; rm /hdd/tmp.zip &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
mv "/hdd/OpenVPN-UDP" /hdd/TorGuard2
cd /hdd/TorGuard2

# rename .ovpn to .conf
#for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done


# Move all files into sub folders
#for file in *; do
#  if [[ -f "$file" ]]; then
#    mkdir "${file%.*}"
#    mv "$file" "${file%.*}"
#  fi
#done

#find /hdd/TorGuard -type d -exec cp "/hdd/TorGuard/ca/ca.crt" {} \; &> /dev/null 2>&1

# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/TorGuard/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete uneeded files 
#rm -f /hdd/TorGuard/ca.crt >/dev/null 2>&1
#rm -rv /hdd/TorGuard/ca >/dev/null 2>&1
rm -f /home/root/TorGuard.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

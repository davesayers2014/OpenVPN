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
rm -v /hdd/PIA_VPN.zip >/dev/null 2>&1
rm -rv /hdd/PIA_VPN >/dev/null 2>&1
mkdir -p /etc/openvpn
mkdir -p /hdd/PIA_VPN2

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

# Download Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/PIA_VPN2/PIA_VPN.zip "https://www.privateinternetaccess.com/openvpn/openvpn.zip" &> /dev/null 2>&1

#Configure VPN files
echo "Configuring OpenVPN"
cd /hdd/PIA_VPN2
unzip -o PIA_VPN.zip &> /dev/null 2>&1
rm -v /hdd/PIA_VPN2/PIA_VPN.zip &> /dev/null 2>&1

# replace spaces with _
for f in *\ *; do mv "$f" "${f// /_}"; done

# rename .ovpn to .conf
#for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Move all files into sub folders
#for file in *; do
#  if [[ -f "$file" ]]; then
#    mkdir "${file%.*}"
#    mv "$file" "${file%.*}"
#  fi
#done

# Copy cert file into sub folders
#find /hdd/PIA_VPN -type d -exec cp /hdd/PIA_VPN/ca.rsa.2048/ca.rsa.2048.crt {} \; &> /dev/null 2>&1

# Delete ca.rsa.2048 folder
#rm -rf /hdd/PIA_VPN/ca.rsa.2048 &> /dev/null 2>&1

# Copy pem file into sub folders
#find /hdd/PIA_VPN -type d -exec cp /hdd/PIA_VPN/crl.rsa.2048/crl.rsa.2048.pem {} \; &> /dev/null 2>&1


# Delete ca.rsa.2048 folder
#rm -rf /hdd/PIA_VPN/crl.rsa.2048 &> /dev/null 2>&1


# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/PIA_VPN2/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete un needed files 
rm -f /home/root/PIA.sh &> /dev/null 2>&1
rm -f /home/root/VPN.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

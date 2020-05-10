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
rm -v /hdd/Digibit.zip >/dev/null 2>&1
rm -rv /hdd/Digibit >/dev/null 2>&1
mkdir -p /etc/openvpn
mkdir -p /hdd/Digibit2

# download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Manager"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk &> /dev/null 2>&1
cd
echo "Installing OpenVPN"
echo $LINE

#Install OpenVPN
echo "Installing OpenVPN"
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

#Install OpenVPN
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/Digibit2/Digibit.zip "http://digibitdesign.com/certs/Certificates.zip" &> /dev/null 2>&1

#Configure OpenVPN
echo "Configuring OpenVPN"
cd /hdd/Digibit2
unzip -o Digibit.zip &> /dev/null 2>&1
rm -v /hdd/Digibit2/Digibit.zip &> /dev/null 2>&1

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
cd
echo $LINE

cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/Digibit2/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete unneeded files 
rm -f /home/root/Digibit.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

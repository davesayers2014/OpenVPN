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
rm -rv /hdd/FastestVPN2 >/dev/null 2>&1
rm -rv /hdd/UDP_Files >/dev/null 2>&1
rm -rv /hdd/TCP_Files >/dev/null 2>&1
mkdir -p /etc/openvpn

# download and install VPN Changer
echo "downloading VPN Manager"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk &> /dev/null 2>&1
cd

# Install OpenVPN
echo "Installing OpenVPN"
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
cd /hdd/
wget "https://support.fastestvpn.com/download/openvpn-tcp-udp-config-files/" -O /hdd/tmp.zip; unzip /hdd/tmp.zip; rm /hdd/tmp.zip &> /dev/null 2>&1
rm -rv /hdd/TCP_Files
mv /hdd/UDP_Files /hdd/FastestVPN2 &> /dev/null 2>&1
cd /hdd/FastestVPN2


# rename .ovpn to .conf
#for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Edit all conf files to have auth-user-pass/auth-user-pass auth.txt
#find . -name "*.conf" -exec sed -i "s/auth-user-pass/auth-user-pass auth.txt/g" '{}' \;

# Move all files into sub folders
#for file in *; do
#  if [[ -f "$file" ]]; then
#    mkdir "${file%.*}"
#    mv "$file" "${file%.*}"
#  fi
#done

cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.one_folder=True' /etc/enigma2/settings
sed -i '$i config.vpnmanager.directory=/hdd/FastestVPN2/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE


# Delete uneeded files 
rm -f /home/root/FastestVPN.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

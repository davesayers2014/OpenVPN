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
rm -v /hdd/temp.zip >/dev/null 2>&1
rm -rv /hdd/VyprVPN >/dev/null 2>&1
mkdir -p /etc/openvpn

# Download and install VPN Changer
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnmanager_1.0.8_all.ipk?raw=true &> /dev/null 2>&1
cd

# Install OpenVPN
echo "Installing OpenVPN"
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
cd /hdd
wget "https://support.goldenfrog.com/hc/article_attachments/360008728172/GF_OpenVPN_10142016.zip" -O /hdd/temp.zip; unzip temp.zip; rm temp.zip &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
rm -rv OpenVPN256 &> /dev/null 2>&1
mv "/hdd/OpenVPN160" VyprVPN
cd /hdd/VyprVPN &> /dev/null 2>&1
rm -v ca.vyprvpn.com.crt &> /dev/null 2>&1


# rename .ovpn to .conf
for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Move all files into sub folders
for file in *; do
  if [[ -f "$file" ]]; then
    mkdir "${file%.*}"
    mv "$file" "${file%.*}"
  fi
done

cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.directory=/hdd/VyprVPN/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE


# Delete uneeded files 
rm -f /home/root/VyprVPN.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

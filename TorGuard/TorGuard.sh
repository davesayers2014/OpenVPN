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
rm -rv /hdd/TorGuard >/dev/null 2>&1
mkdir -p /etc/openvpn

# Download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk &> /dev/null 2>&1
cd
wget -O /usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/plugin.py "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/TorGuard/plugin.py" &> /dev/null 2>&1

# Install OpenVPN
echo "Installing OpenVPN"
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /tmp/auth.txt "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/password.conf" &> /dev/null 2>&1
wget "https://torguard.net/downloads/OpenVPN-UDP.zip" -O /hdd/tmp.zip; unzip /hdd/tmp.zip; rm /hdd/tmp.zip &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd
mv "/hdd/OpenVPN-UDP" /hdd/TorGuard

cd /hdd/TorGuard

# rename .ovpn to .conf
for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Edit all conf files to have auth-user-pass/auth-user-pass auth.txt
find . -name "*.conf" -exec sed -i "s/auth-user-pass/auth-user-pass auth.txt/g" '{}' \;

# Move all files into sub folders
for file in *; do
  if [[ -f "$file" ]]; then
    mkdir "${file%.*}"
    mv "$file" "${file%.*}"
  fi
done

find /hdd/TorGuard -type d -exec cp "/hdd/TorGuard/ca.crt" {} \;

cd
echo $LINE
#Add username and password to auth.txt
sed -i -e "s/USERNAME/$USERNAME/g" /tmp/auth.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /tmp/auth.txt && chmod 777 /tmp/auth.txt &> /dev/null 2>&1

# Copy auth.txt to NowrdVPN sub folders
find /hdd/TorGuard -type d -exec cp /tmp/auth.txt {} \;
# Delete uneeded files 
rm -f /hdd/TorGuard/auth.txt &> /dev/null 2>&1
rm -f /hdd/TorGuard/ca.crt >/dev/null 2>&1
rm -rv /hdd/TorGuard/ca.crt >/dev/null 2>&1
rm -f /home/root/Surfhark.sh &> /dev/null 2>&1
rm -f /tmp/auth.txt &> /dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

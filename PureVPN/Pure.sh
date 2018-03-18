#!/bin/sh
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
rm -rv /hdd/PureVPN >/dev/null 2>&1
rm -rv "/hdd/Linux OpenVPN Updated files" &> /dev/null 2>&1
mkdir -p /etc/openvpn

# download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk &> /dev/null 2>&1
cd
wget -O /usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/plugin.py "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/PureVPN/plugin.py" &> /dev/null 2>&1
echo "Installing OpenVPN"
echo $LINE

# Install OpenVPN
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /tmp/auth.txt "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/password.conf" &> /dev/null 2>&1
wget -O /hdd/PureVPN.zip "https://s3-us-west-1.amazonaws.com/heartbleed/linux/linux-files.zip" &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd
unzip -o PureVPN.zip &> /dev/null 2>&1
rm -v /hdd/PureVPN.zip &> /dev/null 2>&1
mv "/hdd/Linux OpenVPN Updated files/UDP" /hdd/PureVPN

cd /hdd/PureVPN &> /dev/null 2>&1

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

# Copy ca.crt into sub folders
find /hdd/PureVPN -type d -exec cp "/hdd/Linux OpenVPN Updated files/ca.crt" {} \;
# Copy Wdc.key into sub folders
find /hdd/PureVPN -type d -exec cp "/hdd/Linux OpenVPN Updated files/Wdc.key" {} \;
cd
echo $LINE

# Add username and password to auth.txt
sed -i -e "s/USERNAME/$USERNAME/g" /tmp/auth.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /tmp/auth.txt && chmod 777 /tmp/auth.txt &> /dev/null 2>&1
# copy auth.txt to PureVPN sub folders 
find /hdd/PureVPN -type d -exec cp /tmp/auth.txt {} \;
# delete unneeded files
rm -rv "/hdd/Linux OpenVPN Updated files" &> /dev/null 2>&1
rm -f /hdd/PureVPN/auth.txt &> /dev/null 2>&1
rm -f /tmp/auth.txt &> /dev/null 2>&1
rm -f /home/root/Pure.sh &> /dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

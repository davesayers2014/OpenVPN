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
rm -v /hdd/PIA_VPN.zip >/dev/null 2>&1
rm -rv /hdd/PIA_VPN >/dev/null 2>&1
mkdir -p /etc/openvpn
mkdir -p /hdd/PIA_VPN

# Download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk &> /dev/null 2>&1
cd
wget -O /usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/plugin.py "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/PIA_VPN/plugin.py" &> /dev/null 2>&1

#Install OpenVPN
echo "Installing OpenVPN"
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /tmp/auth.txt "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/password.conf" &> /dev/null 2>&1
wget -O /hdd/PIA_VPN/PIA_VPN.zip "https://www.privateinternetaccess.com/openvpn/openvpn.zip" &> /dev/null 2>&1

#Configure VPN files
echo "Configuring OpenVPN"
cd /hdd/PIA_VPN
unzip -o PIA_VPN.zip &> /dev/null 2>&1
rm -v /hdd/PIA_VPN/PIA_VPN.zip &> /dev/null 2>&1

# replace spaces with _
for f in *\ *; do mv "$f" "${f// /_}"; done

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

# Copy cert file into sub folders
find /hdd/PIA_VPN -type d -exec cp /hdd/PIA_VPN/ca.rsa.2048/ca.rsa.2048.crt {} \; &> /dev/null 2>&1

# Delete ca.rsa.2048 folder
rm -rf /hdd/PIA_VPN/ca.rsa.2048 &> /dev/null 2>&1

# Copy pem file into sub folders
find /hdd/PIA_VPN -type d -exec cp /hdd/PIA_VPN/crl.rsa.2048/crl.rsa.2048.pem {} \; &> /dev/null 2>&1


# Delete ca.rsa.2048 folder
rm -rf /hdd/PIA_VPN/crl.rsa.2048 &> /dev/null 2>&1


cd
echo $LINE

# Add username and password to auth.txt
sed -i -e "s/USERNAME/$USERNAME/g" /tmp/auth.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /tmp/auth.txt && chmod 777 /tmp/auth.txt &> /dev/null 2>&1
# Copy auth.txt to IP_Vanish sub folders 
find /hdd/PIA_VPN -type d -exec cp /tmp/auth.txt {} \;
# Delete un needed files 
rm -f /hdd/PIA_VPN/ca.rsa.2048.crt &> /dev/null 2>&1
rm -f /hdd/PIA_VPN/crl.rsa.2048.pem &> /dev/null 2>&1
rm -f /hdd/PIA_VPN/auth.txt &> /dev/null 2>&1
rm -f /tmp/auth.txt &> /dev/null 2>&1
rm -f /home/root/PIA.sh &> /dev/null 2>&1
rm -f /home/root/VPN.sh &> /dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

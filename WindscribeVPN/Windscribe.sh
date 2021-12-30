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
rm -v /hdd/Windscribe.zip >/dev/null 2>&1
rm -rv /hdd/Windscribe >/dev/null 2>&1
mkdir -p /etc/openvpn

# Download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/PY3/enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnchanger_1.1.0_all.ipk &> /dev/null 2>&1
cd
wget -O /usr/lib/enigma2/python/Plugins/Extensions/VpnChanger/plugin.py "https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/WindscribeVPN/plugin.py" &> /dev/null 2>&1

# Install OpenVPN
echo "Installing OpenVPN"
echo $LINE
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /tmp/auth.txt "https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/login.conf" &> /dev/null 2>&1
wget -O /hdd/Windscribe.zip "https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/WindscribeVPN/Windscribe.zip" &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd
unzip -o Windscribe.zip &> /dev/null 2>&1
rm -v /hdd/Windscribe.zip &> /dev/null 2>&1
cd /hdd/Windscribe &> /dev/null 2>&1


cd
echo $LINE
#Add username and password to auth.txt
sed -i -e "s/USERNAME/$USERNAME/g" /tmp/auth.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /tmp/auth.txt && chmod 777 /tmp/auth.txt &> /dev/null 2>&1

# Copy auth.txt to NowrdVPN sub folders
find /hdd/Windscribe -type d -exec cp /tmp/auth.txt {} \;
# Delete uneeded files 
rm -f /hdd/Windscribe/auth.txt &> /dev/null 2>&1
rm -f /tmp/auth.txt &> /dev/null 2>&1
rm -f /home/root/Windscribe.sh &> /dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

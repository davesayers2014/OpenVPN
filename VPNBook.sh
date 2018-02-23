#!/bin/sh
USERNAME='USERNAME'
PASSWORD='PASSWORD'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
rm -rv /etc/openvpn >/dev/null 2>&1
mkdir -p /etc/openvpn >/dev/null 2>&1
echo "Installing OpenVPN" 
opkg update && opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1
cd
wget -O /etc/openvpn/Client.conf "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/Client.conf" &> /dev/null && chmod 777 /etc/openvpn/Client.conf && /etc/openvpn/Client.conf &> /dev/null 2>&1
wget -O /etc/openvpn/login.conf "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/login.conf" &> /dev/null 2>&1
echo "Configuring OpenVPN"
sed -i -e "s/USERNAME/$USERNAME/g" /etc/openvpn/login.conf;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/openvpn/login.conf && chmod 777 /etc/openvpn/login.conf &> /dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
rm -f /home/root/VPNBook.sh >/dev/null 2>&1
exit
fi

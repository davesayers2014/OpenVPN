#!/bin/sh
USERNAME='uuuu'
PASSWORD='pppp'
COUNTRY='GBR'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
rm -rv /etc/openvpn >/dev/null 2>&1
mkdir -p /etc/openvpn
echo "downloading OpenVPN"
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk?raw=true" &> /dev/null 2>&1
echo "Installing OpenVPN"
opkg --force-reinstall --force-overwrite install openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk &> /dev/null 2>&1
cd
wget -O /etc/openvpn/mpnvpn.conf "https://mypn.co/files/linux/mpnvpn.ovpn" &> /dev/null 2>&1
wget -O /etc/openvpn/user.txt "https://mypn.co/files/linux/user.txt" &> /dev/null 2>&1
echo "Configuring OpenVPN"
sed -i -e "s/USERNAME/$USERNAME/g" /etc/openvpn/user.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/openvpn/user.txt && chmod 777 /etc/openvpn/user.txt &> /dev/null 2>&1
sed -i -e "s/COUNTRY/$COUNTRY/g" /etc/openvpn/mpnvpn.conf && chmod 777 /etc/openvpn/mpnvpn.conf &> /dev/null 2>&1
exit
fi

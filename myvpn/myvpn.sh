#!/bin/sh
echo "check_certificate = off" >> ~/.wgetrc
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
#echo "downloading OpenVPN"
#cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk?raw=true" &> /dev/null 2>&1
echo "downloading IP Checker"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-ipchecker_001_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/enigma2-plugin-extensions-ipchecker_001_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing IP Checker"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-ipchecker_001_all.ipk &> /dev/null 2>&1
cd
echo "Installing OpenVPN"
echo $LINE
opkg update && opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1
echo "Installing OpenVPN Configs"
echo $LINE
wget -O /etc/openvpn/mpnvpn.conf "https://www.mypn.co/files/linux/mpnvpn.ovpn" &> /dev/null 2>&1
wget -O /etc/openvpn/user.txt "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/login.conf" &> /dev/null 2>&1
echo "Configuring OpenVPN"
echo $LINE
sed -i -e "s/USERNAME/$USERNAME/g" /etc/openvpn/user.txt;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/openvpn/user.txt && chmod 777 /etc/openvpn/user.txt &> /dev/null 2>&1
sed -i -e "s/COUNTRY/$COUNTRY/g" /etc/openvpn/mpnvpn.conf && chmod 777 /etc/openvpn/mpnvpn.conf &> /dev/null 2>&1
rm -f /home/root/script.sh >/dev/null 2>&1
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi

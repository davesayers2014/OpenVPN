#!/bin/sh
rm -rv /etc/openvpn >/dev/null 2>&1
mkdir -p /etc/openvpn
echo "downloading OpenVPN"
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk "https://github.com/davesayers2014/OpenVPN/blob/master/openvpn_2.4.3-r0.1_cortexa15hf-neon-vfpv4.ipk?raw=true" &> /dev/null 2>&1
echo "Installing OpenVPN" 
opkg --force-reinstall --force-overwrite install openvpn 2>&1
cd
wget -O /etc/openvpn/Client.conf "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/Client.conf" &> /dev/null && chmod 777 /etc/openvpn/Client.conf && /etc/openvpn/Client.conf &> /dev/null 2>&1
wget -O /etc/openvpn/login.conf "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/login.conf" &> /dev/null 2>&1
echo "Configuring OpenVPN"
sed -i -e 's/dddd/vpnbook'/g /etc/openvpn/login.conf;sed -i -e 's/zzzz/vc6h6rb'/g /etc/openvpn/login.conf && chmod 777 /etc/openvpn/login.conf && /etc/openvpn/login.conf &> /dev/null 2>&1
exit 1
fi

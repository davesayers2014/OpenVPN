#!/bin/sh
USERNAME='uuuu'
PASSWORD='pppp'
COUNTRY='GBR'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget --compression=none "http://raw.githubusercontent.com/davesayers2014/OpenVPN/master/myvpn/myvpn.sh" -O- | sed "s/uuuu/$USERNAME/g; s/pppp/$PASSWORD/g; s/GBR/$COUNTRY/g" > script.sh && chmod +x script.sh && ./script.sh

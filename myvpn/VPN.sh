#!/bin/sh
USERNAME='uuuu'
PASSWORD='pppp'
COUNTRY='GBR'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O script.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/myvpn/myvpn.sh && sed -i "s/uuuu/$USERNAME/g" script.sh && sed -i "s/pppp/$PASSWORD/g" script.sh && sed -i "s/GBR/$COUNTRY/g" script.sh && chmod +x script.sh && ./script.sh

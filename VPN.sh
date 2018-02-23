#!/bin/sh
USERNAME='USERNAME'
PASSWORD='PASSWORD'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O VPNBook.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/VPNBook.sh && sed -i "s/USERNAME/$USERNAME/g" script.sh && sed -i "s/PASSWORD/$PASSWORD/g" script.sh && chmod +x VPNBook.sh && ./VPNBook.sh

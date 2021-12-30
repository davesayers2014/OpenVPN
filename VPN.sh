USERNAME='vpnbook'
PASSWORD='5grtx8k'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O VPNBook.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/VPNBook.sh && sed -i "s/uuuu/$USERNAME/g" VPNBook.sh && sed -i "s/pppp/$PASSWORD/g" VPNBook.sh && chmod +x VPNBook.sh && ./VPNBook.sh

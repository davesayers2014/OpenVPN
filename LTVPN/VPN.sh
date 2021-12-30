USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O LTVPN.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/LTVPN/LTVPN.sh && sed -i "s/uuuu/$USERNAME/g" LTVPN.sh && sed -i "s/pppp/$PASSWORD/g" LTVPN.sh && chmod +x LTVPN.sh && ./LTVPN.sh

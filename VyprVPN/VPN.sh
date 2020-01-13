USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O LimeVPN.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/VyprVPN/VyprVPN.sh && sed -i "s/uuuu/$USERNAME/g" VyprVPN.sh && sed -i "s/pppp/$PASSWORD/g" VyprVPN.sh && chmod +x VyprVPN.sh && ./VyprVPN.sh

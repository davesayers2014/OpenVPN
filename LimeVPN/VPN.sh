USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O LimeVPN.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/test/LimeVPN/LimeVPN.sh && sed -i "s/uuuu/$USERNAME/g" LimeVPN.sh && sed -i "s/pppp/$PASSWORD/g" LimeVPN.sh && chmod +x LimeVPN.sh && ./LimeVPN.sh

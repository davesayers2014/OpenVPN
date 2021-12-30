USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O LimeVPN.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/IvacyVPN/LimeVPN.sh && sed -i "s/uuuu/$USERNAME/g" IvacyVPN.sh && sed -i "s/pppp/$PASSWORD/g" IvacyVPN.sh && chmod +x LimeVPN.sh && ./IvacyVPN.sh

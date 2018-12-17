USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O Windscribe.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/WindscribeVPN/Windscribe.sh && sed -i "s/uuuu/$USERNAME/g" Windscribe.sh && sed -i "s/pppp/$PASSWORD/g" Windscribe.sh && chmod +x Windscribe.sh && ./Windscribe.sh

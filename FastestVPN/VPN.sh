USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O FastestVPN.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/FastestVPN/FastestVPN.sh && sed -i "s/uuuu/$USERNAME/g" FastestVPN.sh && sed -i "s/pppp/$PASSWORD/g" FastestVPN.sh && chmod +x FastestVPN.sh && ./FastestVPN.sh

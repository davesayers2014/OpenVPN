USERNAME='uuuu'
PASSWORD='password'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
wget -O Nord.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/NordVPN/Nord.sh && sed -i "s/uuuu/$USERNAME/g" Nord.sh && sed -i "s/pppp/$PASSWORD/g" Nord.sh && chmod +x Nord.sh && ./Nord.sh

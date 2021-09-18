#!/bin/bash
echo "check_certificate = off" >> ~/.wgetrc
unset LD_PRELOAD

USERNAME='UUUU'
PASSWORD='PPPP'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
#!/bin/bash
# Bash Menu Script PY3
PS3='Please enter your choice: '
options=("Nord VPN" "IP Vanish" "Digibit" "PureVPN" "PIA VPN" "Windscribe" "SurfShark" "TorGuard" "IvacyVPN" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Nord VPN")
			echo "Running Nord"
				wget -O Nord.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/NordVPN/Nord.sh && sed -i "s/uuuu/$USERNAME/g" Nord.sh && sed -i "s/pppp/$PASSWORD/g" Nord.sh && chmod +x Nord.sh && ./Nord.sh
			;;
		"IP Vanish")
			echo "Running IP Vanish"
				wget -O IP_Vanish.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/IP_Vanish/IP_Vanish.sh && sed -i "s/uuuu/$USERNAME/g" IP_Vanish.sh && sed -i "s/pppp/$PASSWORD/g" IP_Vanish.sh && chmod +x IP_Vanish.sh && ./IP_Vanish.sh				
			;;
		"Digibit")
			echo "Running Digibit"
				wget -O Digibit.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/DigiBit/Digibit.sh && sed -i "s/uuuu/$USERNAME/g" Digibit.sh && sed -i "s/pppp/$PASSWORD/g" Digibit.sh && chmod +x Digibit.sh && ./Digibit.sh				
			;;
		"PureVPN")
			echo "Running PureVPN"
				wget -O Pure.sh https://github.com/davesayers2014/OpenVPN/raw/PY3/PureVPN/Pure.sh && sed -i "s/uuuu/$USERNAME/g" Pure.sh && sed -i "s/pppp/$PASSWORD/g" Pure.sh && chmod +x Pure.sh && ./Pure.sh				
			;;
		"PIA VPN")
			echo "Running PIA VPN"
				wget -O PIA.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/PIA_VPN/PIA.sh && sed -i "s/uuuu/$USERNAME/g" PIA.sh && sed -i "s/pppp/$PASSWORD/g" PIA.sh && chmod +x PIA.sh && ./PIA.sh				
			;;
		"Windscribe")
			echo "Running Windscribe"
				wget -O Windscribe.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/WindscribeVPN/Windscribe.sh && sed -i "s/uuuu/$USERNAME/g" Windscribe.sh && sed -i "s/pppp/$PASSWORD/g" Windscribe.sh && chmod +x Windscribe.sh && ./Windscribe.sh
			;;
		"SurfShark")
			echo "Running SurfShark"
				wget -O Surfshark.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/SurfShark/Surfshark.sh && sed -i "s/uuuu/$USERNAME/g" Surfshark.sh && sed -i "s/pppp/$PASSWORD/g" Surfshark.sh && chmod +x Surfshark.sh && ./Surfshark.sh
			;;
		"TorGuard")
			echo "Running TorGuard"
				wget -O TorGuard.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/TorGuard/TorGuard.sh && sed -i "s/uuuu/$USERNAME/g" TorGuard.sh && sed -i "s/pppp/$PASSWORD/g" TorGuard.sh && chmod +x TorGuard.sh && ./TorGuard.sh
			;;
		"IvacyVPN")
			echo "Running IvacyVPN"
				wget -O ivacyvpn.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/PY3/IvacyVPN/ivacyvpn.sh && sed -i "s/uuuu/$USERNAME/g" ivacyvpn.sh && sed -i "s/pppp/$PASSWORD/g" ivacyvpn.sh && chmod +x ivacyvpn.sh && ./ivacyvpn.sh
			;;
		"Quit")
			break
			;;
		*) echo invalid option;;
	esac
done

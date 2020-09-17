#!/bin/bash
####################################################
# XUEZ MASTERNODE INSTALLER WITH TOR               #
#                                                  #
#  https://github.com/taperj/xuez-tor              #
#                                                  #
#  V. 0.0.1                                        #
#                                                  #
#  By: taperj                                      #
#                                                  #
####################################################
RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
WHITE='\033[1;37m'
#
#
#Root user check
if [ "$EUID" -ne 0 ]
  then printf "${YELLOW}Please run as root or with sudo. ${RED}Exiting.${NC}\n"
  exit
fi
#
#
printf "${WHITE}MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMW0dokNMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMWXd,...c0WMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMNx;......'oKWMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMWO:..........;kNMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMWWWWWWWWWWWWWKxlllloooooooodKWWWWWWWWWWWWWMMMMMMMMM
MMMMMMMMMWWNNNNNNWWXxooooooooooooooodOXNNNNNNNNNNWWMMMMMMMMM
MMMMMMMMMMMWWNNNWNk:...............'oKNNNNNNNNNWWMMMMMMMMMMM
MMMMMMMMMMMMMWWN0o::::::;'........:kXNNNNNNNNWWMMMMMMMMMMMMM
MMMMMMMMMMMMMMXx;;kXXXXXXOc.....,dKNNNNNNNN0kKWMMMMMMMMMMMMM
MMMMMMMMMMMMNk:..'lKNNNNNNXk:',cOXNNNNNNX0o,':xXMMMMMMMMMMMM
MMMMMMMMMMW0l'.....;dKNNNNNNK00KNNNNNNX0o,....'cOWMMMMMMMMMM
MMMMMMMMWKo,.........:xKNNNNNNNNNNNNX0o,........,oKWMMMMMMMM
MMMMMMMXx;............':kXNNNNNNNNN0o,............;xXWMMMMMM
MMMMMMXl'..............,dKNNNNNNNNXk;...............lXMMMMMM
MMMMMMNk;.............:xKKKKXXKXXXXKkc'............:OWMMMMMM
MMMMMMMWKl'.........,lk0000OxooxO0000Od:'........;dXMMMMMMMM
MMMMMMMMMNk;.......:x0000Oxc,..'cxO0000ko;''''''c0WMMMMMMMMM
MMMMMMMMMMWKl'...'lxOOOOxc'......,cxO0000x;'.';dXMMMMMMMMMMM
MMMMMMMMMMMMNk;':dxkkxo:'..........,lxO00kc;:lOWMMMMMMMMMMMM
MMMMMMMMMMMMMW0dxkkxo;..............',:cc:;lkKWMMMMMMMMMMMMM
MMMMMMMMMMMMWKOkkxo;.....................'ck00XWMMMMMMMMMMMM
MMMMMMMMMMWN0kkkO0o,.................''';dKX000KNWMMMMMMMMMM
MMMMMMMMMWX0OOOO00Oxdollllllllllllllllodk0KK0K00KXWMMMMMMMMM
MMMMMMMMMWWNWWNWNNNNXx;'''''''''''''';xXNNNWWWWWWWWMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMWO:............:OWMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMXo'........'oXMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMWO:......:OWMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMXd'..'oXMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMW0ddOWMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM${NC}\n"
printf "${RED}***************************************************************************${NC}\n"
printf "${RED}****************${YELLOW}WELCOME TO THE XUEZ MASTERNODE INSTALLER${RED}****************${NC}\n"
printf "${YELLOW}******THIS SCRIPT WILL INSTALL A DOCKER CONTAINER WITH XUEZD AND TOR*****${NC}\n"
printf "${RED}***************************************************************************${NC}\n"
#
#
#Get install info:
#
printf "${WHITE}Enter the masternode privkey and hit enter:${NC}\n"
read MASTERNODEPRIVKEY
#
#
#Get masternode's public ip
#
printf "${WHITE}Detecting Public IP..."
#
#Check for cURL
if ! [ -x "$(command -v curl)" ]; then
        printf "${RED}cURL is not detected or not executable.${GREEN} Installing cURL.${NC}\n"
        apt-get -y install curl
fi
#
PUBLICIP=$(curl -s ifconfig.me)
printf "${GREEN}Public IP detected is: $PUBLICIP${NC}\n"
#
printf "${WHITE}Enter the ip you would like to use for the masternode and hit enter:${NC}\n"
read MASTERNODEADDR
#
#
#Port specification
#make sure not to conflict with tor on 9050 and 9051
#
printf "${WHITE}Enter the port number you'd like xuezd to listen on, default Port 41798 will be used if no port specified.${NC}\n"
read PORTNUMBER
if  [ "$PORTNUMBER" = "" ];then
	PORTNUMBER="0"
fi

isnumeric=`echo "$PORTNUMBER" | egrep "^[0-9]+$"`

if [ "$isnumeric" ]; then
        printf "${GREEN}Entered data is numeric or null... continuing.${NC}\n"
else
        printf "${RED}Entered data is non-numeric. Exiting.${NC}\n"
        exit
fi


if [ "$PORTNUMBER" != "0" ]
  then
        if [ "$PORTNUMBER" = "9050" ] || [ "$PORTNUMBER" = "9051" ]
                then
                        printf "${RED}Port $PORTNUMBER specified in user input. $PORTNUMBER is reserved for Tor. Exiting.${NC}\n"
                        printf "${RED}PLEASE RE-RUN THE SCRIPT SELECTING A DIFFERENT PORT.${NC}\n"
                        exit
        fi
          printf "${YELLOW}Port $PORTNUMBER specified in user input. Port $PORTNUMBER will be configured.${NC}\n"
  else
          printf "${YELLOW}No port number specified. Default Port 41798 will be used.${NC}\n"
          PORTNUMBER=41798
fi

#
#
#RPC
#
printf "${WHITE}Enter a username for RPC:${NC}\n"
read RPCUSER
printf "${WHITE}Enter a password for RPC:${NC}\n"
read RPCPASSWORD
printf "${WHITE}Enter any single IP(127.0.0.1 will automatically be added) that should have RPC access:${NC}\n"
read RPCIP
printf "${WHITE}Enter port that RPC should listen on(Default port 51473 will be used if none is specified):${NC}\n"
read RPCPORT

if [ "$RPCPORT" = "" ];then
	RPCPORT="0"
fi

isnumeric=`echo "$RPCPORT" | egrep "^[0-9]+$"`

if [ "$isnumeric" ]
then
	printf "${GREEN}Entered data is numeric or null... continuing.${NC}\n"
	unset RPCPORT
else
	printf "${RED}Entered data is non-numeric. Exiting.${NC}\n"
	exit
fi

if [ "$RPCPORT" = "" ]; then
        printf "${YELLOW}No port number specified. Default Port 51473 will be used.${NC}\n"
        RPCPORT=51473
else
        printf "${YELLOW}RPC Port $RPCPORT specified in user input. Port $RPCPORT will be configured.${NC}\n"

fi
#
#
#Sanity check
#
#####
#
#Check for docker
#

printf "${WHITE}SANITY CHECK...${NC}\n"

if ! [ -x "$(command -v docker)" ]; then
	printf "${RED}docker is not detected or not executable.${GREEN} Installing docker.${NC}\n"
	apt-get -y install docker docker.io
fi

if [ -x "$(command -v docker)" ]; then
        printf "${YELLOW}docker detected and executable.${GREEN} Continuing.${NC}\n"
fi

#
#
#Check for files and dirs needed
for file in xuez.conf Dockerfile services/xuezd/run services/xuezd/finish services/tor/run services/tor/finish services/stubby/run services/stubby/finish
do
if [ ! -f $file ]; then
	printf "${RED}SANITY CHECK FAILED: $file not found in the current directory, exiting!${NC}\n"
	exit
fi
done
#
#
##
for dir in services services/xuezd services/tor services/stubby
do
if [ ! -d $dir ]; then
	printf "${RED}SANITY CHECK FAILED: $dir directory not found, exiting!${NC}\n"
	exit
	fi
done
##
printf "${GREEN}SANITY CHECK PASSED!${NC}\n"
printf "${YELLOW}BEGINNING INSTALL...${NC}\n"
#
#
#
#
#Edit xuez.conf:
#
printf "${YELLOW}Editing xuez.conf...${NC}\n"
sed -i "s/masternodeprivkey=/masternodeprivkey=$MASTERNODEPRIVKEY/g" xuez.conf
sed -i "s/masternodeaddr=/masternodeaddr=$MASTERNODEADDR/g" xuez.conf
sed -i "s/rpcuser=/rpcuser=$RPCUSER/g" xuez.conf
sed -i "s/rpcpassword=/rpcpassword=$RPCPASSWORD/g" xuez.conf
sed -i "s/^rpcport=/rpcport=$RPCPORT/g" xuez.conf
sed -i "s/^port=/port=$PORTNUMBER/g" xuez.conf

if [ "$RPCIP" != "" ]; then

	sed -i "/^rpcallowip=127.0.0.1/a rpcallowip=$RPCIP"  xuez.conf
fi

#
#
#Edit Dockerfile
printf "${YELLOW}Editing Dockerfile...${NC}\n"
sed -i "s/HiddenServicePort 41798 127.0.0.1:41798/HiddenServicePort $PORTNUMBER 127.0.0.1:$PORTNUMBER/g" Dockerfile
sed -i "s/HiddenServicePort 51473 127.0.0.1:51473/HiddenServicePort $RPCPORT 127.0.0.1:$RPCPORT/g" Dockerfile


if [ -e "onion_private_key" ]; then
	chmod 600 "onion_private_key"
	sed -i '/ENTRYPOINT/'i\ 'COPY --chown=xuezd:xuezd onion_private_key /home/xuezd/.xuez/' Dockerfile
	sed -i '/ENTRYPOINT/'i\ 'RUN chown xuezd:xuezd -R /xuezd/.xuez/' Dockerfile
        sed -i '/ENTRYPOINT/'i\ 'RUN chmod 700 /home/xuezd/.xuez/' Dockerfile
        sed -i '/ENTRYPOINT/'i\ 'RUN chmod 600 /home/xuezd/.xuez/onion_private_key' Dockerfile



fi

#
#
#Build image
#
printf "${YELLOW}Building docker image xuez-tor...${NC}\n"
docker build -t xuez-tor-$PORTNUMBER .
#
#Create container
#
printf "${YELLOW}Creating container xuez-tor...${NC}\n"
docker create --name xuez-tor-$PORTNUMBER --restart=unless-stopped -p $PORTNUMBER:$PORTNUMBER -p $RPCPORT:$RPCPORT xuez-tor-$PORTNUMBER:latest
#
#get bootstrap (bootstrap retrieval snip thanks to deadthings)
apt update && apt install curl unrar -y
fileid="1KQFV7MYDEwOy_gLo80fJaXDSiXymuf-V"
filename="bootstrap.rar"
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}
unrar x ${filename}
rm ${filename} cookie

#copy bootstrap in to docker container
docker cp blocks xuez-tor-$PORTNUMBER:/home/xuezd/.xuez
docker cp peers.dat xuez-tor-$PORTNUMBER:/home/xuezd/.xuez
docker cp chainstate xuez-tor-$PORTNUMBER:/home/xuezd/.xuez
docker cp sporks xuez-tor-$PORTNUMBER:/home/xuezd/.xuez

#clean up
rm -vrf blocks peers.dat chainstate sporks

#
#Start container
#
printf "${YELLOW}Starting container xuez-tor...${NC}\n"
docker container start xuez-tor-$PORTNUMBER
sleep 10
docker ps
printf "${GREEN}INSTALLATION COMPLETE.${NC}\n"
printf "${YELLOW}ONCE SYNCED YOU CAN GET THE TOR(onion) ADDRESS TO ADD TO YOUR COLD WALLET masternode.conf as server address with:${NC}\n"
printf "${WHITE}$ sudo docker container exec xuez-tor-$PORTNUMBER grep AddLocal /home/xuezd/.xuez/debug.log${NC}\n"
printf "${YELLOW}THE ABOVE COMMAND SHOULD OUTPUT SOMETHING LIKE THIS EXAMPLE OUTPUT:${NC}\n"
printf "${WHITE}2019-11-24 02:33:16 AddLocal(zsddfken27kdsdx.onion:$PORTNUMBER,4)${NC}\n"
printf "${YELLOW}in this example you would add ${GREEN}zsddfken27kdsdx.onion:$PORTNUMBER${YELLOW} to your cold wallet masternode.conf as ip addr for this alias. Yours will be different than the example.${NC}\n"
printf "${RED}IMPORTANT: IF YOU ARE RUNNING A FIREWALL MAKE SURE TO ALLOW PORT $PORTNUMBER/TCP FOR xuezd${NC}\n"
printf "${YELLOW}Tips for the developer:${NC}\n"
printf "${YELLOW}BTC: 3HLx5AMe9S5SWzVqLwAib3oyGZm5nAAWKe${NC}\n"
printf "${YELLOW}XUEZ:XPc6D1b2P73py7wYBCzV22n7jBfW8D4bVR${NC}\n"
printf "${YELLOW}HAVE FUN ANONYMOUS XUEZ MASTERNODING!${NC}\n"

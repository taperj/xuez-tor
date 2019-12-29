# xuez-tor
docker container: XUEZ Coin masternode with Tor and Stubby

Description and purpose:
This repository is a contribution as a resource to easily build a docker image and create a container that contains a hot XUEZ Coin wallet configured to run as a masternode, xuezd uses Tor to connect to the network for privacy and anonymity and all dns queries are encrypted and anonymized using Stubby/Proxychains4/Tor. Tor/Stubby are contained within the same container as xuezd making this an all-in-one solution using s6-init to run multiple processes in the same container. The linkage between xuezd and the local Tor is configured on build of the image. Tor runs as user debian-tor within the container and xuezd runs as user xuezd. The image is based on Ubuntu 18.04 and the Dockerfile will pull this image as a base on build.

<b>BUILD INFO</b><br>
Steps to install:<br>
clone the repository with git:<br>
<code>git clone https://github.com/taperj/xuez-tor</code><br>
Change directory to the root of the project:<br>
<code>cd xuez-tor</code><br>
Make sure the installer is executable:<br>
<code>chmod +x installer</code><br>
Run the installer<br>
<code>sudo ./install.sh</code><br>

torpassword in xuez.conf is set to "decentralization" and should be changed to whatever you change the Tor controller password to in the following step. Note that you can build and use as is, it has been configured to work but it is highly suggested that you take the time to edit the Dockerfile and xuez.conf changing the tor control password prior to build, or after build once the container is deployed. I have added the following instructions are in the Dockerfile to guide you:
     
#Hashed Password is "decentralization" change this with tor --hash-password \<yournewpassword\><br>
#and use the ouput to replace the following in /etc/tor/torrc. Make sure to also update transcendence.conf torpassword= with the<br>
#new password in plain text, not hashed.<br>
&&    echo "HashedControlPassword 16:C7F40C06065809EE60D5C0B9086D2BDF88F32495CD1AE06E4571CB8212" >> /etc/tor/torrc \

Make sure to allow port 41798/tcp(or whatever port you specify to run the masternode on in the installer) in your hosts firewall(not within the container), this can usually be accomplished with:<br>
sudo ufw allow 41798/tcp<br>
<br>
<b>Description of encrypted/anonymized DNS linkage:</b><br>
Stubby is a small DNS stub resolver that uses TLS to encrypt its lookups when queried. I have configured Stubby to use proxychains4 which passes the query to a SOCKS5 proxy, being Tor. So any DNS queries within the container are encrypted locally with stubby and the encrypted lookup is anonymized over Tor.<br>
<br>
Tips for the developer..<br>
BTC: 3HLx5AMe9S5SWzVqLwAib3oyGZm5nAAWKe<br>
XUEZ: XPc6D1b2P73py7wYBCzV22n7jBfW8D4bVR<br>
<br>
<br>
<b>Relevant links:</b><br>
<b>S6-INIT:</b> https://skarnet.org/software/s6/ <br>
<b>Tor:</b> https://www.torproject.org/ <br>
<b>Stubby:</b> https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby <br>
<b>Proxychains4:</b> https://github.com/rofl0r/proxychains-ng <br>
<b>XUEZ Coin:</b> http://xuezcoin.com/ <br>
<b>Docker:</b> https://www.docker.com/ <br>

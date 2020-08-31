FROM ubuntu:18.04

RUN apt-get update \
	&&    apt-get install curl wget unzip -y \
	&&    curl --fail --silent -L https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz | tar xzvf - -C / \
	&&    apt-get install -y sudo tor stubby proxychains4 apt-transport-tor \
	&&    apt-get -y upgrade \
	&&    mkdir -v /home/debian-tor \
	&&    chown -v debian-tor:debian-tor /home/debian-tor \
	&&    chmod -v 750 /home/debian-tor \
	&&    useradd -s /bin/bash -d /home/xuezd -m xuezd \
 	&&    cd /home/xuezd \
	&&    mkdir /home/xuezd/.xuez \
	&&    chown xuezd:xuezd /home/xuezd/.xuez \
	&&    ln -s /home/xuezd/.xuez /root/.xuez \
 	&&    wget https://github.com/XUEZ/xuez/releases/download/1.0.1.10/xuez-linux-cli-10110.tgz \
 	&&    tar zxf xuez-linux-cli-10110.tgz \
 	&&    mv xuezd xuez-cli xuez-tx /usr/local/bin/ \
 	&&    chown root:root /usr/local/bin/xuezd /usr/local/bin/xuez-cli /usr/local/bin/xuez-tx \
 	&&    chmod 755 /usr/local/bin/xuezd /usr/local/bin/xuez-cli /usr/local/bin/xuez-tx \
 	&&    rm -rf /home/xuezd/.xuez \
 	&&    rm -f xuez-linux-cli-10110.tgz \
 	&&    apt-get clean -qq \
	&&    echo "Setting up /etc/tor/torrc" \
	&&    echo "User debian-tor" >> /etc/tor/torrc \
	&&    echo "DataDirectory /home/debian-tor/.tor" >> /etc/tor/torrc \
	&&    echo "HiddenServiceDir /home/debian-tor/.torhiddenservice/" >> /etc/tor/torrc \
	&&    echo "HiddenServicePort 41798 127.0.0.1:41798" >> /etc/tor/torrc \
        &&    echo "HiddenServicePort 51473 127.0.0.1:51473" >> /etc/tor/torrc \
	# Hashed Password is "decentralization" change this with tor --hash-password <yournewpassword> 
	# and use the ouput to replace the following in /etc/tor/torrc. Make sure to also update transcendence.conf torpassword= with the 
        # new password in plain text, not hashed.
	&&    echo "HashedControlPassword 16:C7F40C06065809EE60D5C0B9086D2BDF88F32495CD1AE06E4571CB8212" >> /etc/tor/torrc \
	&&    echo "ControlPort 9051" >> /etc/tor/torrc \
	&&    echo "Done setting up torrc." \
	&&    echo "This may take a moment..."

COPY ./services /etc/services.d/
COPY --chown=xuezd:xuezd xuez.conf /home/xuezd/.xuez/xuez.conf
COPY --chown=root:root stubby.yml /etc/stubby/
COPY --chown=root:root proxychains.conf /etc/
ENTRYPOINT [ "/init" ]

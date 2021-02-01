#!/bin/sh

#
_err() { echo $r "\n !! error:\n    $1\n" $z; }
file=/etc/centrifugo/config.json

if [ -z ${CI_BUILD_CFG_API+x} ] || [ -z $CI_BUILD_CFG_API ]; then
	_err "CI_BUILD_CFG_API not defined"; exit 1
fi

if [ -z ${CI_BUILD_CFG_TKN+x} ] || [ -z $CI_BUILD_CFG_TKN ]; then
	_err "CI_BUILD_CFG_TKN not defined"; exit 1
fi

#
sudo curl -s https://packagecloud.io/install/repositories/FZambia/centrifugo/script.deb.sh | sudo bash 
sudo apt-get install -y centrifugo
sudo systemctl enable centrifugo

#
#touch /etc/centrifugo/config.json
sudo cp -r ../cfu/default0.config.json  /etc/centrifugo/config.json

#
sed -i "s/_CFUGO_KEY_API_/$CI_BUILD_CFG_API/g" $file
sed -i "s/_CFUGO_KEY_TKN_/$CI_BUILD_CFG_TKN/g" $file

#
sudo centrifugo checkconfig --config=/etc/centrifugo/config.json 
#centrifugo --config=/var/www/mn.overbase.net/utils/etc/cfu/default0.config.json
sudo systemctl restart centrifugo
sudo systemctl enable centrifugo

#
echo $y "
 !! finished
     centrifugo
" $z

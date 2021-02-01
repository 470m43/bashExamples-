#!/bin/sh

#
_err() { echo $r "\n !! error:\n    $1\n" $z; }
file=/etc/telegraf/telegraf.conf

if [ -z ${CI_MONITOR_MNG_DBA_HOST+x} ] || [ -z $CI_MONITOR_MNG_DBA_HOST ]; then
	_err "CI_MONITOR_MNG_DBA_HOST not defined"; exit 1
fi

if [ -z ${CI_BUILD_MNG_DBA_MONITOR_PASS+x} ] || [ -z $CI_BUILD_MNG_DBA_MONITOR_PASS ]; then
	_err "CI_BUILD_MNG_DBA_MONITOR_PASS not defined"; exit 1
fi

if [ -z ${CI_MONITOR_MNG_DBA_PASS+x} ] || [ -z $CI_MONITOR_MNG_DBA_PASS ]; then
	_err "CI_MONITOR_MNG_DBA_PASS not defined"; exit 1
fi

#
sudo apt-get install -y gnupg2 gnupg1 gnupg
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get install apt-transport-https
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

#
sudo apt update
sudo apt-get install -y telegraf

#
sudo mv /etc/telegraf/telegraf.conf  /etc/telegraf/telegraf.conf.dflt
sudo cp -r ../telegraf/*  /etc/telegraf/

#
sudo sed -i "s/_dba_mng_monitor_db_host_/$CI_MONITOR_MNG_DBA_HOST/g" $file
sudo sed -i "s/_dba_mng_monitor_db_pass_/$CI_BUILD_MNG_DBA_MONITOR_PASS/g" $file
sudo sed -i "s/_dba_mng_monitor_influxdb_pass_/$CI_MONITOR_MNG_DBA_PASS/g" $file

#
sudo chmod 1 /etc/telegraf/nfschk.sh
sudo usermod -aG sudo telegraf

#
sudo systemctl enable telegraf
sudo systemctl restart telegraf


#
echo $y "
 !! finished
     telegraf
" $z

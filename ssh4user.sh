#!/bin/sh

dir=/home/abc

#
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.dflt
sudo sed -i "s/PasswordAuthentication/#PasswordAuthentication/g" /etc/ssh/sshd_config
sudo systemctl restart sshd 

#
if [ -d "$dir" ]; then
    sudo mkdir $dir/.ssh && sudo cp -r conf/authorized_keys $dir/.ssh
    sudo chown abc: $dir/.ssh/authorized_keys
    sudo chmod 600 $dir/.ssh/authorized_keys
fi

#
echo $y "
 !! finished
     ssh config and key
" $z


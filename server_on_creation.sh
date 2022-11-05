#! /bin/bash
# -x echos commands to log
set -x
#export DEBIAN_FRONTEND=noninteractive
sudo DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" dist-upgrade -y --force-yes

# update and upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq

# add java repo
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update

# accept java installer agreement
sudo echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

# install java
sudo apt-get install -y oracle-java8-installer

# install web server for logs
sudo apt-get install -y lighttpd

sudo apt-get install -y awscli

# download a boot script to rc.d
sudo wget -O /etc/init.d/server_on_reboot.sh http://s3.amazonaws.com/bobsgameserver/server_on_reboot.sh

# make it executable
sudo chmod +x /etc/init.d/server_on_reboot.sh

# start on reboot
sudo update-rc.d server_on_reboot.sh start 20 1 2 3 4 5 .


sudo reboot

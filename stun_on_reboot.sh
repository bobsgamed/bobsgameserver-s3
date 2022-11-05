#! /bin/bash

### BEGIN INIT INFO
# Provides:          stun_on_reboot
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     1 2 3 4 5
# Default-Stop:      
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO


# -x echos commands to log
set -x
export DEBIAN_FRONTEND=noninteractive

# update and upgrade
sudo apt-get update && sudo apt-get upgrade -y



# download stun.jar from private s3 bucket
#sudo wget -O /home/ubuntu/stun.jar http://s3.amazonaws.com/bobsgameserver/stun.jar
sudo aws s3 cp --region us-east-1 s3://bobsgameserver/stun.jar /home/ubuntu

# run stun as a screen session
sudo -H byobu-screen -h 99999 -d -m sudo java -jar /home/ubuntu/stun.jar -Xmx1024m



#! /bin/bash

### BEGIN INIT INFO
# Provides:          index_on_reboot
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



# download server.jar from private s3 bucket
#sudo wget -O /home/ubuntu/index.jar http://s3.amazonaws.com/bobsgameserver/index.jar
sudo aws s3 cp --region us-east-1 s3://bobsgameserver/index.jar /home/ubuntu

# run server as a screen session
sudo -H byobu-screen -h 99999 -d -m sudo java -jar /home/ubuntu/index.jar -Xmx1024m


#!/usr/bin/env bash

########################################################################
# Script  : Basic Ubuntu 16.04 host configuration.
# Author  : Agastyo Satriaji Idam
# Contact : play.satriajidam@gmail.com
# Website : satriajidam.github.io
########################################################################

set -o errexit # make script exits when a command fails
set -o pipefail # make script exits when the rightmost command of a pipeline exits with non-zero status
set -o nounset # make script exits when it tries to use undeclared variables
#set -o xtrace # trace what gets executed for debugging purpose

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@" 
fi

# fix annoying "stdin: is not a tty" problem on provisioning
sed -i "/mesg n/d" /root/.profile

# adjust timezone to Jakarta
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# setup language
#echo "export LANG=en_US.UTF-8" | tee -a /etc/environment
#echo "export LANGUAGE=en_US.UTF-8" | tee -a /etc/environment
#echo "export LC_ALL=en_US.UTF-8" | tee -a /etc/environment
#source /etc/environment

# enable 4GB swap
cd /
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" | tee -a /etc/fstab
echo "vm.swappiness=10" | tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf

# clean up
apt-get clean
rm -rf /tmp/* /var/tmp/*

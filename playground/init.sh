#!/bin/bash

set -x

##################
# Basic
##################
apt-get update
apt-get install -y      \
    git                 \
    tmux                \
    curl


##################
# Install Docker
##################

apt-get install -y                      \
     apt-transport-https                \
     ca-certificates                    \
     gnupg2                             \
     software-properties-common

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

add-apt-repository                                                                      \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs)                                                                   \
   stable"

apt-get update
apt-get install -y docker-ce


##################
# BBR
##################
modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control


##################
# TCP Fast Open
##################
echo 3 > /proc/sys/net/ipv4/tcp_fastopen


##################
# Clean
##################
apt-get autoremove -q -y        && \
    apt-get autoclean -q -y     && \
    rm -rf /var/lib/apt/lists/*


##################
# Oh My Tmux
##################
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
echo "set -g prefix C-'\'" >> .tmux.conf.local


##################
# Oh My ZSH
##################
apt-get install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

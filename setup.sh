#!/bin/bash

# Abort when exit code not 0
set -e

# Check if run as root and exit if not root
["$EUID" -ne 0] && echo "run as root" && exit 1

# Update the system
apt update && apt upgrade -y

# Install necessary packages
apt install -y sudo openssh-server ufw git htop curl fail2ban

# add user with sudo rights
useradd admin
echo "admin:adminpass" | chpasswd
usermod -aG sudo admin

# Harden SSH server
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*Port.*/Port 2222/' /etc/ssh/sshd_config

# enable and start ssh
systemctl enable ssh
systemctl start ssh

# configure firewall
ufw allow 2222/tcp
ufw enable

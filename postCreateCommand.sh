#!/bin/sh

apt update
apt install openssh-server screen net-tools sudo git -y
mkdir /var/run/sshd
groupadd -g 1000 vscode
useradd -s /bin/bash --uid 1000 --gid 1000 -m vscode
echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode
chmod 0440 /etc/sudoers.d/vscode
echo vscode:PASSWORD_FOR_USER_vscode | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
tee -a /etc/ssh/sshd_config > /dev/null <<EOT
#Legacy changes
KexAlgorithms +diffie-hellman-group1-sha1
Ciphers +aes128-cbc
EOT
mkdir -p /var/log/syslog-ng/

# https://github.com/openssl/openssl/issues/4708
openssl rehash /workspaces/syslog-ng/cert/ca
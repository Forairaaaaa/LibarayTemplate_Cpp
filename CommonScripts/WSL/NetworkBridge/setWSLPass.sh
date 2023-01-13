#!/bin/bash
# IP地址需要按需修改
new_ip=192.168.31.233
brd=192.168.31.255
# 网桥一般是.255
gateway=192.168.31.1
nameserver=192.168.31.1
net_dev=eth0

# 注意，下面这里需要用到wsl的sud执行命令，所以需要填写你wsl的密码
echo <Your password> | sudo -S ip addr del $(ip addr show $net_dev | grep 'inet\b' | awk '{print $2}' | head -n 1) dev $net_dev

sudo ip addr add $new_ip/24 broadcast $brd dev $net_dev

sudo ip route add 0.0.0.0/0 via $gateway dev $net_dev

sudo sed -i "\$c nameserver $nameserver" /etc/resolv.conf


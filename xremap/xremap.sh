#!/bin/sh
cd /home/catalin/.config/xremap
if [ -z $1 ]; then 
    sudo nohup xremap --watch xremap.conf.yaml &
else
    sudo nohup xremap --device 'dakai' --watch xremap.dakai.conf.yaml &
    sudo nohup xremap --device 'AT Translated Set 2 keyboard' --watch xremap.conf.yaml &
fi

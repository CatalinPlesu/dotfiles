#!/usr/bin/sh

pkill -9 dwmblocks
~/.config/dwmblocks/dwmblocks.stats&
sleep 5
pkill -9 dwmblocks
~/.config/dwmblocks/dwmblocks&

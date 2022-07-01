#!/bin/sh
backlight_control $1
pkill -RTMIN+2 dwmblocks

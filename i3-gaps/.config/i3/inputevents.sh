#!/bin/bash

if [ "$1" = "XIDeviceEnabled" ] && [ "$3" = "XISlaveKeyboard" ]; then
    echo "inputevents: xset"
    xset r rate 280 30
    setxkbmap -option caps:escape
    numlockx on
elif [ "$1" = "XIDeviceEnabled" ] && [ "$4" = "Apple Inc. Magic Trackpad 2" ]; then
    echo "inputevents: gestures restart"
    libinput-gestures-setup restart
fi

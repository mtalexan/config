#!/bin/bash

if [ ! -e /tmp/mouse-configured ] ; then
    echo "force configuring natural scrolling"
    #set reverse scrolling by setting negative vert & horiz scroll
    #and set lower sensitivity scrolling so it's more usable (higher is less sensitive)
    synclient VertScrollDelta=-300 HorizScrollDelta=-300
    touch /tmp/mouse-configured
fi

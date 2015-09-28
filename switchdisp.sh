#!/bin/bash

# requires : wmctrl
#   $sudo apt-get install wmctrl
#
# usages
#   move to left  : ./switchdisplay.sh 2l
#   move to right : ./switchdisplay.sh 2r


#
# user conf
#
left_display_width=1680
#right_display_width=1920
offset=65


#
# main (not change)
#
function getWindowWidth()
{
    ret=( `xwininfo $1 | grep Width:` ) 
    echo "${ret[1]}"
}

function getWindowX()
{
    ret=( `xwininfo -id $1 | grep "Absolute\ upper-left\ X:"` )
    echo "${ret[3]}"
}

function getWindowY()
{
    ret=( `xwininfo -id $1 | grep "Absolute\ upper-left\ Y:"` )
    echo "${ret[3]}"
}

function getWindowId() 
{
    ret=( `xprop -root | grep ^_NET_ACTIVE_WINDOW` )
    echo "${ret[4]}"
}


root_width=`getWindowWidth -root`
active_window_id=`getWindowId`
active_window_width=`getWindowWidth "-id ${active_window_id}"`
active_window_x=`getWindowX "${active_window_id}"`
active_window_y=`getWindowY "${active_window_id}"`


if [ $1 == "2r" ] && [ ${active_window_x} -lt ${left_display_width} ]; then
    echo "to right"
    new_window_x=`echo "scale=5; ${active_window_x}+${left_display_width}-${offset}-1" | bc`
elif [ $1 == "2l" ] && [ ${active_window_x} -ge ${left_display_width} ]; then
    echo "to left"
    new_window_x=`echo "scale=5; ${active_window_x}-${left_display_width}+${offset}-1" | bc`
else
    exit
fi
#new_window_x=${new_window_x%.*}


# debug
echo "root width   = "${root_width}
echo "window id    = "${active_window_id}
echo "window width = "${active_window_width}
echo "window pos   = "${active_window_x}, ${active_window_y}
echo "move pos     = "${new_window_x}, ${active_window_y}


wmctrl -i -r $active_window_id -e 0,$new_window_x,-1,-1,-1


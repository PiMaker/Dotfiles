#!/bin/bash

export LC_TIME=de_AT.UTF-8

BAR_HEIGHT=25  # polybar height
BORDER_SIZE=1  # border size from your wm settings
YAD_WIDTH=222  # 222 is minimum possible value
YAD_HEIGHT=188 # 188 is minimum possible value
DATE="$(date)"

case "$1" in
--popup)

    if [ "$(xdotool getwindowfocus getwindowname)" = "yad-calendar" ]; then
        exit 0
    fi

    eval "$(xdotool getmouselocation --shell)"
    #eval "$(xdotool getdisplaygeometry --shell)"
    WIDTH=7280
    HEIGHT=1440

    # X
    if [ "$((X + YAD_WIDTH / 2 + 2 + BORDER_SIZE))" -gt "$WIDTH" ]; then #Right side
        : $((pos_x = WIDTH - YAD_WIDTH - BORDER_SIZE - 4))
    elif [ "$((X - YAD_WIDTH / 2 - 2 - BORDER_SIZE))" -lt 1 ]; then #Left side
        : $((pos_x = BORDER_SIZE))
    else #Center
        : $((pos_x = X - YAD_WIDTH / 2 - 2))
    fi

    # Y
    if [ "$Y" -gt "$((HEIGHT / 2))" ]; then #Bottom
        : $((pos_y = HEIGHT - YAD_HEIGHT - 4 - BAR_HEIGHT - BORDER_SIZE))
    else #Top
        : $((pos_y = BAR_HEIGHT + BORDER_SIZE))
    fi

    yad --calendar --undecorated --fixed --close-on-unfocus --no-buttons \
        --width=$YAD_WIDTH --height=$YAD_HEIGHT --posx=$pos_x --posy=$pos_y \
        --title="yad-calendar" >/dev/null &
    ;;
*)
    echo "$DATE"
    ;;
esac

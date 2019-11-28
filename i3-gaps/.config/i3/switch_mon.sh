#!/bin/bash

set -e
#set -x

# format: array[] of:
# {
#   "num": 2,
#   "name": "2",
#   "visible": true,
#   "focused": true,
#   "rect": {
#     "x": 1920,
#     "y": 25,
#     "width": 3440,
#     "height": 1415
#   },
#   "output": "HDMI-A-0",
#   "urgent": false
# }
workspaces=$(i3-msg -t get_workspaces | jq '.[] | select(.visible)')

# move a workspace to another screen, input format is as above
function move() {
    from=$(echo "$1" | jq '.num')
    to=$(echo "$2" | jq '.output')

    i3-msg "[workspace=${from}] move workspace to output ${to}"
}

# get currently focused/active workspace
current_ws=$(echo "$workspaces" | jq 'select(.focused)')
current_x=$(echo "$current_ws" | jq '.rect.x')
current_y=$(echo "$current_ws" | jq '.rect.y')
current_w=$(echo "$current_ws" | jq '.rect.width')
current_h=$(echo "$current_ws" | jq '.rect.height')
alt_ws="none"

# get current mouse coordinates relative to workspace...
eval "$(xdotool getmouselocation --shell --prefix "MOUSE_")"
declare -i mouse_x_rel
declare -i mouse_y_rel

# ...only if the mouse is in the current workspace at all though
if (( MOUSE_X >= current_x && MOUSE_X < current_x + current_w && \
      MOUSE_Y >= current_y && MOUSE_Y < current_y + current_h )); then
    let "mouse_x_rel = MOUSE_X - current_x"
    let "mouse_y_rel = MOUSE_Y - current_y"
else
    # otherwise indicate the mouse was not on screen
    let "mouse_x_rel = -1"
fi

# switch on input movement direction provided to script
case $1 in
    "left" )
        alt_ws=$(echo "$workspaces" \
            | jq "select(.rect.x < $current_x)" \
            | jq -s 'max_by(.rect.x)')
        ;;
    "right" )
        alt_ws=$(echo "$workspaces" \
            | jq "select(.rect.x > $current_x)" \
            | jq -s 'min_by(.rect.x)')
        ;;
    *)
        echo "usage: $0 (left|right)"
        exit 1
        ;;
esac

if [ "$alt_ws" = "none" ] || [ "$alt_ws" = "" ]; then
    # no screens found, exit with status code 2
    exit 2
fi

# alright, we have two screens to swap!
move "$current_ws" "$alt_ws"
move "$alt_ws" "$current_ws"

# focus both workspaces once to keep them in foreground
i3-msg "workspace $(echo "$alt_ws" | jq '.num')"
i3-msg "workspace $(echo "$current_ws" | jq '.num')"

# move mouse cursor along with $current_ws, either with relative
# position calculated above or by falling back to center of screen
if (( mouse_x_rel < 0 )); then
    xdotool mousemove \
        $(echo "$alt_ws" | jq '.rect.x + .rect.width / 2') \
        $(echo "$alt_ws" | jq '.rect.y + .rect.height / 2')
else
    xdotool mousemove \
        $(echo "$alt_ws" \
            | jq ".rect.x + .rect.width*(${mouse_x_rel}/${current_w})") \
        $(echo "$alt_ws" \
            | jq ".rect.y + .rect.height*(${mouse_y_rel}/${current_h})")
fi


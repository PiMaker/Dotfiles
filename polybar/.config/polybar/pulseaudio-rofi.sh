#!/bin/sh

outputs() {
    OUTPUT=$(pactl list short sinks | cut  -f 2 | rofi -dmenu -p "Output" -mesg "Select preferred output source" )
    pactl set-default-sink "$OUTPUT" >/dev/null 2>&1

    for playing in $(pactl list sink-inputs | awk '/^Sink Input/ && gsub(/^#/, "", $3) {print $3}'); do
        pactl move-sink-input "$playing" "$OUTPUT" >/dev/null 2>&1
    done
}

inputs() {
    INPUT=$(pactl list short sources | cut  -f 2 | grep input | rofi -dmenu -p "Output" -mesg "Select preferred input source" )
    pactl set-default-source "$INPUT" >/dev/null 2>&1

    for recording in $(pactl list source-outputs | awk '/^Source Output/ && gsub(/^#/, "", $3) {print $3}'); do
        pactl move-source-output "$recording" "$INPUT" >/dev/null 2>&1
    done
}

volume_up() {
    pactl set-sink-volume @DEFAULT_SINK@ +3%
}

volume_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -3%
}

mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

volume_source_up() {
    pactl set-source-volume @DEFAULT_SOURCE@ +3%
}

volume_source_down() {
    pactl set-source-volume @DEFAULT_SOURCE@ -3%
}

mute_source() {
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

get_default_sink() {
    pactl info | awk -F": " '/^Default Sink: /{print $2}'
}

output_volume() {
     pactl list sinks | awk '/^\s+Name: /{indefault = $2 == "'"$(get_default_sink)"'"}
             /^\s+Mute: / && indefault {muted=$2}
             /^\s+Volume: / && indefault {volume=$5}
             END { print muted=="no"?volume:"Muted" }'
}

get_default_source() {
    pactl info | awk -F": " '/^Default Source: /{print $2}'
}

input_volume() {
     pactl list sources | awk '/^\s+Name: /{indefault = $2 == "'"$(get_default_source)"'"}
             /^\s+Mute: / && indefault {muted=$2}
             /^\s+Volume: / && indefault {volume=$5}
             END { print muted=="no"?volume:"Muted" }'
}

check_for_parent() {
    # polybar sometimes doesn't kill us correctly
    # so commit suicide ourselves if we get attached to init
    if [ $PPID = "1" ]; then
        exit 0
    fi
}

output_volume_listener() {
    if command -v pulseaudio-events > /dev/null; then
        pulseaudio-events -f sink -f server -o changed | while read -r event; do
            check_for_parent
            output_volume
        done
    else
        # very slow, only do if faster pulseaudio-events is not available
        pactl subscribe | while read -r event; do
            if echo "$event" | grep -q "change"; then
                check_for_parent
                output_volume
            fi
        done
    fi
}

input_volume_listener() {
    if command -v pulseaudio-events > /dev/null; then
        pulseaudio-events -f source -f server -o changed | while read -r event; do
            check_for_parent
            input_volume
        done
    else
        # very slow, only do if faster pulseaudio-events is not available
        pactl subscribe | while read -r event; do
            if echo "$event" | grep -q "change"; then
                check_for_parent
                input_volume
            fi
        done
    fi
}

case "$1" in
    --output)
        outputs
    ;;
    --input)
        inputs
    ;;
    --mute)
        mute
    ;;
    --mute_source)
        mute_source
    ;;
    --volume_up)
        volume_up
    ;;
    --volume_down)
        volume_down
    ;;
    --volume_source_up)
        volume_source_up
    ;;
    --volume_source_down)
        volume_source_down
    ;;
    --output_volume)
        output_volume
    ;;
    --input_volume)
        input_volume
    ;;
    --output_volume_listener)
        output_volume
        output_volume_listener
    ;;
    --input_volume_listener)
        input_volume
        input_volume_listener
    ;;
    *)
        echo "Wrong argument"
    ;;
esac

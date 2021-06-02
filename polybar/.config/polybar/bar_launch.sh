#!/bin/bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
SCRIPT=$0

echo "bar_launch script"
echo "MONITOR: $MONITOR"

RETRY=${RETRY:-0}
RETRY_INC=$((RETRY+1))
if (( RETRY > 5 )); then
  echo "Retried too often, aborting!"
  exit 1
fi

# Default systray mon specified here:
SYSTRAY_MON="${SYSTRAY_MON:-DP-4}"

if [ -z "$MONITOR" ]; then
  echo "No monitor specified, doing them all."
  killall polybar || true

  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Doing monitor: $m"
    unset SYSTRAY
    if [ "$m" = $SYSTRAY_MON ]; then
       export SYSTRAY=right
    fi
    MONITOR=$m $SCRIPT &
  done
  exit 0
fi

set -o pipefail
set -e

#trap 'case $? in
#        139) $SCRIPT;;
#      esac' EXIT

polybar -q --reload main &
POLYPID=$!

echo "Waiting, checking if retry is needed..."
sleep 3

if ! [[ $(ps -A | grep $POLYPID) ]]; then
	echo "Retrying!"
	env RETRY=$RETRY_INC $SCRIPT
	exit 0
fi

disown

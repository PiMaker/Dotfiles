#!/bin/bash

ps -AF | tail -n +2 | while read line; do
    if [ "$(echo "$line" | tr -s " " | cut -d" " -f7)" = "$1" ]; then
        echo "$line"
    fi
done

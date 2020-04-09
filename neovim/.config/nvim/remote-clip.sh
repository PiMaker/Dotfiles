#!/bin/bash

if [[ -n "$SSH_CONNECTION" ]]; then
    SRC=$(echo "$SSH_CONNECTION" | cut -d' ' -f1)
    REMOTE="remote-clip-access@$SRC"

    PIPE=$(mktemp)

    # key will automatically call xclip for us on remote
    cat | ssh -i ~/.config/nvim/remote-clip.key "$REMOTE" >$PIPE 2>/dev/null &
    PID=$!

    until grep "success" $PIPE >/dev/null || kill -0 $PID; do sleep 0.001; done
    sleep 1
    kill -0 $PID 2>/dev/null && kill $PID
    rm $PIPE

    echo "Copied to remote clipboard on $SRC"
else
    xclip -selection clipboard /dev/stdin
    echo "Copied to local clipboard"
fi

#!/bin/bash

CONTAINER_NAME="htb-vnc-lab"
SESSION="htb":

docker exec -it "$CONTAINER_NAME" bash -lc "
  tmux has-session -t $SESSION 2>/dev/null || (
    tmux new-session -d -s $SESSION
    tmux rename-window -t $SESSION:0 'vpn'
    tmux send-keys -t $SESSION:0 'sudo openvpn --config ~/vpn/starting_point_H4rdC0r3Dev.ovpn' C-m

    tmux split-window -h -t $SESSION
    tmux rename-window -t $SESSION:1 'work'
  )

  tmux attach -t $SESSION
"

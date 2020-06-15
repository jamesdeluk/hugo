---
title: tmux
---

```
tmux

tmux ls # view sessions
tmux attach -t 0 # attach to session 0
tmux rename-session -t 0 <name> # rename session
tmux new -s <name> # new session with name
tmux kill-session -t 0 # kill session 0

ctrl-b = command key

% # new pane to right
" # new pane to bottom
arrows # swap panes
c # new window
0 # window 0
, # rename window
d # detach

# in shell
exit # close pane
```
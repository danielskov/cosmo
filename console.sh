#!/bin/sh
SESSION=cosmo
echo "starting $SESSION tmux session"

tmux has-session -t $SESSION
if [ $? != 0 ]
then
    cd ~/cosmo
    # Create new session, name it, name the window, detach

    tmux new-session -s $SESSION -n matlab -d
    tmux send-keys -t $SESSION './cosmo_matlab_starter.sh' C-m

    tmux new-window -t $SESSION -n rsync
    tmux send-keys -t $SESSION 'watch -n 10 ./update.sh' C-m

    tmux new-window -t $SESSION -n top
    tmux send-keys -t $SESSION 'top' C-m

    tmux select-window -t $SESSION:1 # select first pane

fi
tmux attach -t $SESSION

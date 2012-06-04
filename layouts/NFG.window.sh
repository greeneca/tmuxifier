# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "/var/www/thedandelion/thegathering"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "NFG"

# Split window into panes.
tmux split-window -t "$session:$window.0" -v -p 20 ncftp
tmux split-window -t "$session:$window.1" -h -p 50

# Set active pane.
tmux select-pane -t "$session:$window.0"

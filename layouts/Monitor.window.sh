# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "/home/greeneca/Ubuntu One/Colibri/monitor_script"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "Monitor"

# Split window into panes.
tmux split-window -t "$session:$window.0" -v -p 20

# Set active pane.
tmux select-pane -t "$session:$window.0"

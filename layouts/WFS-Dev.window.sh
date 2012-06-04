# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "~/Projects/WFS-Dev"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "WFS-Dev"

# Split window into panes.
#tmux split-window -t "$session:$window.0" -h -p 20

# Set active pane.
#tmux select-pane -t "$session:$window.0"

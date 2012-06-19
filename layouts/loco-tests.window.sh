# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/Documents/locomotive_engine"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "loco-tests"

# Split window into panes.
#split_v 20
split_h 50
run_cmd "be cucumber" 0

# Run commands.
#run_cmd "top"     # runs in active pane
#run_cmd "date" 1  # runs in pane 1

# Set active pane.
#select_pane 0

# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/Documents/sites/MSDC"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "MSDC-Server"

# Split window into panes.
split_v 15
#split_h 50

# Run commands.
run_cmd "rails s -p 3456" 0     # runs in active pane
#run_cmd "date" 1  # runs in pane 1

# Set active pane.
#select_pane 0

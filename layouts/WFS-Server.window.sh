# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "/home/greeneca/Documents/sites/whatsforsupper"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "WFS-Server"

split_v 20
run_cmd "rails s -p 2345" 0
select_pane 1


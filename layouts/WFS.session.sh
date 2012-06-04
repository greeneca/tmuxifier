# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "/home/greeneca/Documents/sites/whatsforsupper"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "WFS"; then

  # Load a defined window layouts.
  load_window "WFS-Server"
  load_window "WFS-Console"
  load_window "WFS-Dev"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session

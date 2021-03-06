#
# Layout Helpers
#
# These functions are available exclusively within layout files, and enable
# the layout files to function at all, but also provide useful short-hands to
# otherwise more complex means.
#

# Create a new window.
#
# Arguments:
#   - $1: (optional) Name/title of window.
#   - $2: (optional) Shell command to execute when window is created.
#
new_window() {
  if [ -n "$1" ]; then window="$1"; fi
  if [ -n "$2" ]; then local command=("$2"); fi
  if [ -n "$window" ]; then local winarg=(-n "$window"); fi

  if [ -n "$window_root" ]; then cd "$window_root"; fi
  tmux new-window -t "$session:" "${winarg[@]}" "${command[@]}"
}

# Split current window/pane vertically.
#
# Arguments:
#   - $1: (optional) Percentage of frame the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_v() {
  if [ -n "$1" ]; then local percentage=(-p "$1"); fi
  tmux split-window -t "$session:$window.$2" -v "${percentage[@]}"
}

# Split current window/pane horizontally.
#
# Arguments:
#   - $1: (optional) Percentage of frame the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_h() {
  if [ -n "$1" ]; then local percentage=(-p "$1"); fi
  tmux split-window -t "$session:$window.$2" -h "${percentage[@]}"
}

# Select a specific window.
#
# Arguments:
#   - $1: Window ID or name to select.
#
select_window() {
  tmux select-window -t "$session:$1"
}

# Select a specific pane in the current window.
#
# Arguments:
#   - $1: Pane ID to select.
#
select_pane() {
  tmux select-pane -t "$session:$window.$1"
}

# Runs a shell command in the currently active pane/window.
#
# Arguments:
#   - $1: Shell command to run.
#   - $2: (optional) Target pane ID to run command in.
#
run_cmd() {
  tmux send-keys -t "$session:$window.$2" "$1"
  tmux send-keys -t "$session:$window.$2" "C-m"
}

# Cusomize session root path. Default is `$HOME`.
#
# Arguments:
#   - $1: Directory path to use for session root.
#
session_root() {
  local dir="$(__expand_path $@)"
  if [ -d "$dir" ]; then
    session_root="$dir"
  fi
}

# Customize window root path. Default is `$session_root`.
#
# Arguments:
#   - $1: Directory path to use for window root.
#
window_root() {
  local dir="$(__expand_path $@)"
  if [ -d "$dir" ]; then
    window_root="$dir"
  fi
}

# Load specified window layout.
#
# Arguments:
#   - $1: Name of window layout to load.
#
load_window() {
  local file="$TMUXIFIER_LAYOUT_PATH/$1.window.sh"
  if [ -f "$file" ]; then
    window="$1"
    source "$file"
    window=

    # Reset `$window_root`.
    if [[ "$window_root" != "$session_root" ]]; then
      window_root "$session_root"
    fi
  else
    echo "No such window layout found '$1' in '$TMUXIFIER_LAYOUT_PATH'."
  fi
}

# Load specified session layout.
#
# Arguments:
#   - $1: Name of session layout to load.
#
load_session() {
  local file="$TMUXIFIER_LAYOUT_PATH/$1.session.sh"
  if [ -f "$file" ]; then
    session="$1"
    source "$file"
    session=

    # Reset `$session_root`.
    if [[ "$session_root" != "$HOME" ]]; then
      session_root="$HOME"
    fi
  else
    echo "No such session layout found '$1' in '$TMUXIFIER_LAYOUT_PATH'."
  fi
}

# Create a new session, returning 0 on success, 1 on failure.
#
# Arguments:
#   - $1: (optional) Name of session to create, if not specified `$session`
#         is used.
#
# Example usage:
#
#   if initialize_session; then
#     load_window "example"
#   fi
#
initialize_session() {
  if [ -n "$1" ]; then
    session="$1"
  fi

  #echo Ensure tmux server is running for has-session check.
  tmux start-server

  #echo Check if the named session already exists.
  if ! tmux has-session -t "$session:"; then
    #echo Create the new session.
    env TMUX="" tmux new-session -d -s "$session"

    #echo Set default-path for session
    if [ -n "$session_root" ] && [ -d "$session_root" ]; then
      cd "$session_root"
      tmux set-option -t "$session:" default-path "$session_root"
    fi

    # In order to ensure only specified windows are created, we move the
    # default window to position 99, and later remove it with the
    # `finalize_session` function.
    tmux move-window -s "$session:1" -t "$session:99"

    # Ensure correct pane splitting.
    finalize_and_go_to_session

    # Session created, return ok exit status.
    return 0
  fi
  # Session already existed, return error exit status.
  return 1
}

# Finalize session creation and then switch to it if needed.
#
# When the session is created, it leaves a unused window in position #99, this
# is the default window which was created with the session, but it's also a
# window that was not explicitly created. Hence we kill it.
#
# If the session was created, we've already been switched to it. If it was not
# created, the session already exists, and we'll need to specifically switch
# to it here.
#
finalize_and_go_to_session() {
  ! tmux kill-window -t "$session:99"
  #if [[ "$(tmuxifier-current-session)" != "$session" ]]; then
    #__go_to_session
  #fi
}


#
# Internal functions
#

# Expands given path.
#
# Example:
#
#   $ __expand_path "~/Projects"
#   /Users/jimeh/Projects
#
__expand_path() {
  echo $(eval echo "$@")
}

__go_to_session() {
  echo "Go to session"
  #if [ -z "$TMUX" ]; then
    #tmux -u attach-session -t "$session:"
  #else
    #tmux -u switch-client -t "$session:"
  #fi
}

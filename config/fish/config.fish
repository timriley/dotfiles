# Turn off the default greeting
set fish_greeting

# Fish's login shell PATH setup is infuriatingly broken with version 3.0.x, with
# e.g. /usr/local/bin being put _after_ /usr/bin.
#
# Specify my own "preferred" path dirs here (in reverse order) and ensure they
# get re-placed at the front of the current $PATH.
#
# Postgres.app's bin dir is added here, specifically before asdf inits, so #
# asdf's shims end up first of all (allowing Postgres.app to be seen by asdf as
# the "system" postgres)
set -l extra_path_dirs /usr/local/sbin /usr/local/bin /Applications/Postgres.app/Contents/Versions/latest/bin
for extra_dir in $extra_path_dirs
  set PATH $extra_dir (string match -v $extra_dir $PATH)
end

status --is-interactive; and source /usr/local/opt/asdf/asdf.fish

set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showcolorhints 'yes'

set --export EDITOR "code"

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"

function fish_user_key_bindings
  # Thanks, https://github.com/fish-shell/fish-shell/issues/905#issuecomment-20559486
  bind \cc 'echo; commandline ""; commandline -f repaint'
end

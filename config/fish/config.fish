# Turn off the default greeting
set fish_greeting

# Specify my preferred path dirs here (in reverse order) and ensure they get
# re-placed at the front of the current $PATH.
#
# Include Postgres.app here, before asdf inits, so asdf's shims end up first
# of all (allowing Postgres.app to be seen by asdf as the "system" postgres)
set -l extra_path_dirs /Applications/Postgres.app/Contents/Versions/latest/bin
for extra_dir in $extra_path_dirs
  set PATH $extra_dir (string match -v $extra_dir $PATH)
end

fish_add_path /opt/homebrew/bin

direnv hook fish | source

source /opt/homebrew/opt/asdf/asdf.fish

source ~/.secrets.fish

set --export EDITOR "code"

# Required for postgres to build, see https://github.com/smashedtoatoms/asdf-postgres/issues/52
set --export HOMEBREW_PREFIX "/opt/homebrew"

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"
set --export HOMEBREW_NO_AUTO_UPDATE "1"

# Default extra options for asdf postgres installations
set --export POSTGRES_EXTRA_CONFIGURE_OPTIONS "--with-uuid=e2fs"

function fish_user_key_bindings
  # Thanks, https://github.com/fish-shell/fish-shell/issues/905#issuecomment-20559486
  bind \cc 'echo; commandline ""; commandline -f repaint'
end

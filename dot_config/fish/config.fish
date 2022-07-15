# Turn off the default greeting
set fish_greeting

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)
if test -d (brew --prefix)"/share/fish/completions"
  set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end
if test -d (brew --prefix)"/share/fish/vendor_completions.d"
  set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# Direnv
direnv hook fish | source

# asdf
source /opt/homebrew/opt/asdf/asdf.fish

# Editor
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

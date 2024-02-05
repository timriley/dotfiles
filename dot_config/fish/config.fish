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

# mise
mise activate fish | source

# Editor
set --export EDITOR "zed"

# For CLI apps like lazygit to keep their configs here instead of ~/Library
set --export XDG_CONFIG_HOME "$HOME/.config"

# Required for postgres to build, see https://github.com/smashedtoatoms/asdf-postgres/issues/52
set --export HOMEBREW_PREFIX "/opt/homebrew"

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"
set --export HOMEBREW_NO_AUTO_UPDATE "1"

# Default extra options for mise postgres installations
set --export POSTGRES_EXTRA_CONFIGURE_OPTIONS "--with-uuid=e2fs"
set --export ICU_CFLAGS "-I$(brew --prefix icu4c)/include"
set --export ICU_LIBS "-L$(brew --prefix icu4c)/lib -licui18n -licuuc -licudata"

function fish_user_key_bindings
  # Thanks, https://github.com/fish-shell/fish-shell/issues/905#issuecomment-20559486
  bind \cc 'echo; commandline ""; commandline -f repaint'
end

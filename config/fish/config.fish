# Turn off the default greeting
set fish_greeting

# Add Postgres.app tools to path, but before asdf inits, so asdf's shims end up first
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH

status --is-interactive; and source /usr/local/opt/asdf/asdf.fish

set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showcolorhints 'yes'

set --export EDITOR "code"

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"

function fish_user_key_bindings
  # Thanks, https://github.com/fish-shell/fish-shell/issues/905#issuecomment-20559486
  bind \cc 'echo; commandline ""; commandline -f repaint'
end

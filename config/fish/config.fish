# Turn off the default greeting
set fish_greeting

status --is-interactive; and . (rbenv init -|psub)
status --is-interactive; and . (nodenv init -|psub)

set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showcolorhints 'yes'

set --export EDITOR "code"

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"

function fish_user_key_bindings
  # Thanks, https://github.com/fish-shell/fish-shell/issues/905#issuecomment-20559486
  bind \cc 'echo; commandline ""; commandline -f repaint'
end

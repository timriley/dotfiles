function gwc --description 'cd into a git worktree by branch name (interactive if no args)'
  if test (count $argv) -eq 0
    if not command -q fzf
      echo "gwc: interactive mode requires fzf"
      return 1
    end
    set header (printf 'Select a worktree\n\n  enter: cd  esc: cancel')
    set path (git worktree list | tail -n +2 | awk '{full=$1; sub(".*/", "", $1); print full "\t" $0}' | fzf --delimiter='\t' --with-nth=2 --prompt="  worktree> " --header=$header --header-first | awk -F'\t' '{print $1}')
    if test -z "$path"
      return 0
    end
    cd $path
  else
    set main_root (git worktree list --porcelain | head -1 | string replace 'worktree ' '')
    cd (dirname $main_root)/(basename $main_root)__(string replace -a / - $argv[1])
  end
end

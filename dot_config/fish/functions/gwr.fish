function gwr --description 'git worktree remove by branch name (interactive if no args)'
  if test (count $argv) -eq 0
    if not command -q fzf
      echo "gwr: interactive mode requires fzf"
      return 1
    end
    set header (printf 'Select worktrees to remove\n\n  tab: select multiple  enter: confirm  esc: cancel')
    set paths (git worktree list | tail -n +2 | awk '{full=$1; sub(".*/", "", $1); print full "\t" $0}' | fzf --multi --delimiter='\t' --with-nth=2 --prompt="  worktree> " --header=$header --header-first | awk -F'\t' '{print $1}')
    if test (count $paths) -eq 0
      return 0
    end
    for path in $paths
      git worktree remove $path
    end
  else if test -d $argv[1]
    git worktree remove $argv
  else
    set main_root (git worktree list --porcelain | head -1 | string replace 'worktree ' '')
    git worktree remove (dirname $main_root)/(basename $main_root)__(string replace -a / - $argv[1]) $argv[2..-1]
  end
end

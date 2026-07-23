function gw --description 'git worktree shortcut'
  if test (count $argv) -eq 0
    echo "Worktrees"
    echo ""
    git worktree list | awk '{sub(".*/", "", $1); print}' | column -t
    echo ""
    echo "  gwa <branch>   add worktree (creates branch if needed)"
    echo "  gwc <branch>   cd into worktree"
    echo "  gwr [branch]   remove worktree (interactive if no args)"
    echo "  gwl            list worktrees"
    echo "  gw --help      show git worktree help"
  else
    git worktree $argv
  end
end

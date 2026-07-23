function gwa --description 'git worktree add at sibling dir <repo>__<branch>'
  if test (count $argv) -lt 1
    echo "Usage: gwa <branch>"
    return 1
  end
  set branch $argv[1]
  set main_root (git worktree list --porcelain | head -1 | string replace 'worktree ' '')
  set worktree_path (dirname $main_root)/(basename $main_root)__(string replace -a / - $branch)

  if git show-ref --verify --quiet refs/heads/$branch
    git worktree add $worktree_path $branch
  else
    git worktree add -b $branch $worktree_path
  end
end

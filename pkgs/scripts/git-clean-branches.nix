{ writeShellScriptBin }:
writeShellScriptBin "git-clean-branches" ''
  git for-each-ref --format '%(refname:short)' refs/heads | grep -v "master\|main\|develop\|development\|dev" | xargs git branch -D
''

nix-shell -p bitwarden-cli --command "bw login; bw get attachment id_ed25519 --itemid b49c4926-e119-4655-8db0-b19c008a438b --output ~/.ssh/id_ed25519"

nix-shell -p git --command "cd ~/nixos-config; git remote set-url origin git@github.com:miniluz/nixos-config; git submodule init; git submodule update; cd private; git checkout main; git pull"

echo -n "Enter host name: "
read MACHINE_NAME

nix-shell -p nix-output-monitor expect --command "sudo unbuffer nixos-rebuild swith -f ~/nixos-config/entry.nix -A nixosConfigurations.($MACHINE_NAME) --option extra-experimental-features 'nix-command flakes' --option max-jobs auto 2>&1 | nom"

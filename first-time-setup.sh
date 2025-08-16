#!/usr/bin/env bash

nix-shell -p bitwarden-cli --command "bw login; bw get attachment id_ed25519 --itemid b49c4926-e119-4655-8db0-b19c008a438b --output ~/.ssh/id_ed25519"

nix-shell -p git --command "cd ~/nixos-config; git remote set-url origin git@github.com:miniluz/nixos-config"

echo -n "Enter host name: "
read -r MACHINE_NAME

sudo -v
nix-shell -p nix-output-monitor expect git --command "sudo unbuffer nixos-rebuild switch -f ~/nixos-config/entry.nix -A outputs.nixosConfigurations.$MACHINE_NAME --option extra-experimental-features 'nix-command flakes' --option max-jobs auto 2>&1 | nom"

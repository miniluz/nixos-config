# A rebuild script that commits on a successful build
set -e

# cd to your config dir
pushd "$NH_FLAKE"

# Pull latest changes and fail if pull fails
if ! git pull; then
    echo "Failed to pull latest changes, exiting."
    popd
    exit 1
fi

# Edit your config
"${NIX_CONFIG_EDITOR:-${EDITOR:-vi}}" "$NH_FLAKE"

# Early return if no changes were detected (thanks @singiamtel!)
if [ -z "$(git status --porcelain)" ]; then
    echo "No changes detected, exiting."
    popd
    exit 1
fi

# Autoformat your nix files
nixfmt . &>/dev/null \
|| ( nixfmt . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff HEAD

git add .

echo "NixOS Rebuilding..."

# Ask for sudo before anything happens
sudo -v

while true; do
  sudo -v
  sleep 60
done &
KEEP_SUDO_PID=$!

# Rebuild, output simplified errors, log trackebacks
set -o pipefail
if ! (nh os switch 2>&1 | tee "$NH_FLAKE/nixos-switch.log") then
  echo "NixOS Rebuild failed!"
  notify-send -e "NixOS Rebuilt Failed!" --icon=computer-fail-symbolic
  kill $KEEP_SUDO_PID
  exit 1
fi

# Kill sudo loop
kill $KEEP_SUDO_PID


# Get the current generation info and build commit message
commit_message=$(nixos-rebuild list-generations --json | jq -r '.[] | select(.current == true) | "\(.generation) - \(.date)"')

# Check if we got a valid commit message
if [ -z "$commit_message" ]; then
    echo "Error: Could not find current generation" >&2
    exit 1
fi

# Commit all changes witih the generation metadata
git commit -am "$commit_message"

git push

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available

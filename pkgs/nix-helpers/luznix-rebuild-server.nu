
# A rebuild script that commits on a successful build
def fail [message] {
    print $"ERROR: ($message)"
    exit 1
}

def fail-and-revert-commit [message] {
    git reset HEAD~1
    fail $message
}

def main [] {
    let flake_path: path = "/home/miniluz/nixos-config-base" | path expand
    let server_flake_path: path = $env.NH_FLAKE | path expand
    cd $flake_path

    print "Pulling changes..."
    try {
    git pull
    } catch {
        fail "Failed to pull latest changes"
    }

    print $"Opening config in $NIX_CONFIG_EDITOR \(($env.NIX_CONFIG_EDITOR)\) or $EDITOR \(($env.EDITOR)\)..."
    print "Close it to continue"
    let editor: string = ($env | get -o NIX_CONFIG_EDITOR | default ($env | get --ignore-errors EDITOR | default 'vi'))
    ^$editor $flake_path

    if ((git status --porcelain | str trim) | is-empty) {
        fail "No changes detected"
    }

    let nixfmt_output = nixfmt . | complete
    if ($nixfmt_output.exit_code != 0) {
        print $nixfmt_output.stdout
        print $nixfmt_output.stderr
        fail "Formatting failed"
    }

    print "Adding changes"
    git add .

    # git diff HEAD --submodule=diff

    print "Commiting changes"
    try { git commit -am "Server rebuild" }

    print "Updating server flake"
    nix flake update --flake $server_flake_path miniluz-hosts

    print "NixOS Rebuilding..."

    sudo -v
    try {
        luznix-os-switch
    } catch {
        fail-and-revert-commit "NixOS Rebuild failed!"
    }

    print "Pushing changes"
    git push
}

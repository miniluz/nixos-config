# A rebuild script that commits on a successful build
def fail [message] {
    print $"ERROR: ($message)"
    notify-send -e "NixOS Rebuilt Failed!" $message --icon=computer-fail-symbolic
    exit 1
}

def do_in_submodule [closure] {
    cd private
    do $closure
}
def do_in_submodule_and_repo [closure] {
    do_in_submodule $closure
    do $closure
}

def fail_and_revert_commit [message] {
    print "Reverting changes..."
    do_in_submodule_and_repo {
        git reset HEAD~1
    }
    fail $message
}

def main [] {
    let flake_path: path = "~/nixos-config-base" | path expand
    let server_flake_path: path = $env.NH_FLAKE | path expand

    cd $flake_path

    print "Pulling changes..."
    do_in_submodule_and_repo {
        try {
            git pull
        } catch {
            fail "Failed to pull latest changes"
        }
    }

    print $"Opening config in $NIX_CONFIG_EDITOR \(($env.NIX_CONFIG_EDITOR)\) or $EDITOR \(($env.EDITOR)\)..."
    print "Close it to continue"
    let editor: string = ($env | get --ignore-errors NIX_CONFIG_EDITOR | default ($env | get --ignore-errors EDITOR | default 'vi'))
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

    if ((git status --porcelain | str trim) | is-empty) {
        fail "No changes detected"
    }

    do_in_submodule_and_repo { print $"Adding changes in ($env.PWD)" ; git add . }
    do_in_submodule_and_repo { print $"Committing changes in ($env.PWD)" ; git commit --allow-empty -am "Update from server" }

    # git diff HEAD --submodule=diff

    try {
        nix flake update --flake $server_flake_path miniluz-hosts
    } catch {
        fail_and_revert_commit "Failed to update changes to server"
    }

    print "NixOS Rebuilding..."

    sudo -v
    try {
        luznix-os-switch
    } catch {
        fail_and_revert_commit "NixOS Rebuild failed!"
    }

    do_in_submodule_and_repo { try { print $"Pushing changes in ($env.PWD)" ; git push } }

    notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
}

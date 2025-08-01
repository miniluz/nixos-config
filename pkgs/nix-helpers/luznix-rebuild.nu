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

def main [] {
    let flake_path: path = $env.NH_FLAKE | path expand
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

    do_in_submodule_and_repo { print $"Adding changes in ($env.PWD)" ; git add . }

    # git diff HEAD --submodule=diff

    print "NixOS Rebuilding..."

    sudo -v

    let keep_sudo_pid = job spawn {
        loop {
            sudo -v
            sleep 60sec
        }
    }

    luznix-os-switch

    let switch_result = $env.LAST_EXIT_CODE

    job kill $keep_sudo_pid

    if ($switch_result != 0) {
        fail "NixOS Rebuild failed!"
    }

    let commit_message = (
        nixos-rebuild list-generations --json
        | from json
        | where current == true
        | sort-by date --reverse
        | first 1
        | each { |it| $"($it.generation) - ($it.date)" }
        | str join "\n"
    )

    if ($commit_message | is-empty) {
        fail "Could not find current generation"
    }

    do_in_submodule_and_repo { try { print $"Commiting changes in ($env.PWD)" ; git add . ; git commit -am $commit_message } }

    do_in_submodule_and_repo { try { print $"Pushing changes in ($env.PWD)" ; git push } }

    notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
}

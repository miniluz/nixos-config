# A rebuild script that commits on a successful build
def fail [message] {
    print $"ERROR: ($message)"
    notify-send -e "NixOS Rebuilt Failed!" $message --icon=computer-fail-symbolic
    exit 1
}

def main [] {
    let flake_path: path = $env.NH_FLAKE | path expand
    cd $flake_path

    rm -f ./result

    print "Pulling changes..."
    try {
    git pull
    } catch {
        fail "Failed to pull latest changes"
    }

    print $"Opening config in $NIX_CONFIG_EDITOR \(($env.NIX_CONFIG_EDITOR)\) or $EDITOR \(($env.EDITOR)\)..."
    print "Close it to continue"
    let editor: string = ($env | get -o NIX_CONFIG_EDITOR | default ($env | get -o EDITOR | default 'vi'))
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

    print "NixOS Rebuilding..."

    sudo -v
    try {
        luznix-os-switch
    } catch {
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

    print "Commiting changes"
    git commit -am $commit_message 

    print "Pushing changes"
    git push

    notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
}

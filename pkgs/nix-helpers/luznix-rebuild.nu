# A rebuild script that commits on a successful build

def main [] {
    let flake_path: path = $env.NH_FLAKE | path expand
    cd $flake_path

    print "Pulling changes..."
    git pull
    if ($env.LAST_EXIT_CODE != 0) {
        print "Failed to pull latest changes, exiting."
        exit 1
    }

    print $"Opening config in $NIX_CONFIG_EDITOR \(($env.NIX_CONFIG_EDITOR)\) or $EDITOR \(($env.EDITOR)\)..."
    print "Close it to continue"
    let editor: string = ($env | get --ignore-errors NIX_CONFIG_EDITOR | default ($env | get --ignore-errors EDITOR | default 'vi'))
    ^$editor $flake_path

    if ((git status --porcelain | str trim) | is-empty) {
        print "No changes detected, exiting."
        exit 1
    }

    let nixfmt_output = nixfmt . | complete
    if ($nixfmt_output.exit_code != 0) {
        print $nixfmt_output.stdout
        print $nixfmt_output.stderr
        print "Formatting failed!"
        exit 1
    }

    git add .

    git diff HEAD

    print "NixOS Rebuilding..."

    sudo -v

    let keep_sudo_pid = job spawn {
        loop {
            sudo -v
            sleep 60sec
        }
    }

    nh os switch o+e>| tee { save --force ($flake_path | path join "nixos-switch.log") }
    let switch_result = $env.LAST_EXIT_CODE

    job kill $keep_sudo_pid

    if ($switch_result != 0) {
        print "NixOS Rebuild failed!"
        notify-send -e "NixOS Rebuilt Failed!" --icon=computer-fail-symbolic
        return 1
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
        print -e "Error: Could not find current generation"
        exit 1
    }

    git commit -am $commit_message

    git push

    notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
}

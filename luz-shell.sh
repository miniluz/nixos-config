#!/usr/bin/env false

nix shell github:miniluz/nixos-config#miniluz-pkgs.luz-shell-utils

nix run github:miniluz/nixos-config#miniluz-pkgs.luz-shell

nix profile install github:miniluz/nixos-config#miniluz-pkgs.luz-shell --extra-experimental-features nix-command --extra-experimental-features flakes

# You'll also wanna add this to the .bashrc
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
    then
    shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    exec fish $LOGIN_OPTION
fi

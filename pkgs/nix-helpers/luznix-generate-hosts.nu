# Nushell script to find all ".nix" files in a given folder and its subdirectories,
# and create an 'import-all.nix' file in that folder to import them.
# The generated import uses the format `{ imports = [ relative-path-1 relative-path-2 ]; }`.
def main [target_folder: path] {
    if not (($target_folder | path type) == "dir") {
        error $"Error: '($target_folder)' is not a directory."
        return
    }

    let absolute_target_folder: path = ($target_folder | path expand)

    let systems: list<string> = (
        ls $absolute_target_folder
        | where type == "dir"
        | get name
        | path relative-to $absolute_target_folder
    )

    let system_entries: list<string> = ($systems
        | each { |system_name|
            $"
                ($system_name) = nixpkgs.lib.nixosSystem {
                    specialArgs = {
                        inherit
                        inputs
                        paths
                        ;
                    };
                    modules = [
                        nixos-modules
                        overlay-module
                        ./($system_name)/configuration.nix
                    ];
                };
            "
        }
    )

    let system_entries_attributes = ($system_entries | str join "\n\n")

    let import_all_nix_content = $"
        { nixpkgs, overlay-module, nixos-modules, paths, ... }@inputs:
        {
        ($system_entries_attributes)
        }
    "

    let output_file_path = ($absolute_target_folder | path join "hosts.nix")

    $import_all_nix_content | save --force $output_file_path

    print $"Successfully created 'hosts.nix' in '($absolute_target_folder)'."
}

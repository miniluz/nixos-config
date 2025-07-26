# Nushell script to find all ".nix" files in a given folder and its subdirectories,
# and create an 'import-all.nix' file in that folder to import them.
# The generated import uses the format `{ imports = [ <relative-path-1> <relative-path-2> ]; }`.
def main [target_folder: path] {
    # Ensure the provided target_folder is indeed a directory.
    if not ($target_folder | path type) == directory {
        error "Error: '$target_folder' is not a directory."
        return
    }

    # Resolve the target_folder to its absolute path for consistent relative path calculations.
    let absolute_target_folder = ($target_folder | path expand)

    # Recursively find all files ending with ".nix" within the target folder,
    # explicitly excluding 'import-all.nix'.
    let nix_files = (
        ls ...(glob $"($absolute_target_folder)/**/*.{nix}")
        | where type == file
        | where name != 'import-all.nix' # Exclude import-all.nix
        | get path
    )

    # Generate the import strings for each .nix file.
    # Each path is made relative to the target_folder and wrapped in angle brackets for Nix import syntax.
    let import_entries = ($nix_files
        | each { |file_path|
            let relative_path = ($file_path | path relative-to $absolute_target_folder)
            $"  <($relative_path)>"
        }
    )

    # Join the individual import entries with newlines to form the content for the 'imports' list.
    let imports_list_content = ($import_entries | str join "\n")

    # Construct the full content for the 'import-all.nix' file.
    let import_all_nix_content = $"{{ imports = [\n($imports_list_content)\n]; }}"

    # Define the full path for the output file.
    let output_file_path = ($absolute_target_folder | path join "import-all.nix")

    # Save the generated content to the 'import-all.nix' file.
    # '--force' ensures the file is overwritten if it already exists.
    $import_all_nix_content | save --force $output_file_path

    # Print a success message to the user.
    print $"Successfully created 'import-all.nix' in '($absolute_target_folder)'."
}

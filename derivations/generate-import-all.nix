{ pkgs, lib, ... }:
let
  makeNushellSearchList =
    subDir: paths:
    "[ "
    + (builtins.concatStringsSep ":" (
      builtins.map (path: path + "/" + subDir) (builtins.filter (x: x != null) paths)
    ))
    + "]";
  makeNushellSearchListOutput =
    output: subdir: pkgs:
    makeNushellSearchList subdir (map (lib.getOutput output) pkgs);
  makeNushellBinList = makeNushellSearchListOutput "bin" "bin";
  writeNuApplication =
    {
      /**
        The name of the script to write.

        # Type

        ```
        String
        ```
      */
      name,
      /**
        The shell script's text, not including a shebang.

        # Type

        ```
        String
        ```
      */
      text,
      /**
        Inputs to add to the shell script's `$PATH` at runtime.

        # Type

        ```
        [String|Derivation]
        ```
      */
      runtimeInputs ? [ ],
      /**
        `stdenv.mkDerivation`'s `meta` argument.

        # Type

        ```
        AttrSet
        ```
      */
      meta ? { },
      /**
        `stdenv.mkDerivation`'s `passthru` argument.

        # Type

        ```
        AttrSet
        ```
      */
      passthru ? { },
      /**
        Extra arguments to pass to `stdenv.mkDerivation`.

        :::note{.caution}
        Certain derivation attributes are used internally,
        overriding those could cause problems.
        :::

        # Type

        ```
        AttrSet
        ```
      */
      derivationArgs ? { },
      /**
        Whether to inherit the current `$PATH` in the script.

        # Type

        ```
        Bool
        ```
      */
      inheritPath ? true,
    }:
    pkgs.writeTextFile {
      inherit
        name
        meta
        passthru
        derivationArgs
        ;
      executable = true;
      destination = "/bin/${name}";
      allowSubstitutes = true;
      preferLocalBuild = false;
      text =
        ''
          #!${pkgs.nushell}/bin/nu
          $env.Path = ${lib.optionalString inheritPath "$env.Path | prepend"} ${makeNushellBinList runtimeInputs}"
        ''
        + ''
          ${text}
        '';
    };
in
writeNuApplication {
  name = "generate-import-all";
  text = builtins.readFile ./generate-import-all.nu;
}

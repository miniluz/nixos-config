flake-path:
let
  lock = builtins.fromJSON (builtins.readFile "${flake-path}/flake.lock");
  node = lock.nodes.root.inputs.__flake-compat;
  inherit (lock.nodes.${node}.locked) narHash rev url;
  flake-compat = builtins.fetchTarball {
    url = "${url}/archive/${rev}.tar.gz";
    sha256 = narHash;
  };
  flake = import flake-compat {
    src = flake-path;
    copySourceTreeToStore = false;
    useBuiltinsFetchTree = true;
  };
in
flake

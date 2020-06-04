let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {};

  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${sources.nixpkgs}"
    "darwin=${sources.nix-darwin}"
    "darwin-config=$HOME/nix-config/current-machine"
  ];

  scripts = {
    format = pkgs.writeShellScriptBin "format" "nixpkgs-fmt $(find . -name '*.nix')";

    install-darwin = pkgs.writeShellScriptBin "install-darwin" ''
      set -e
      export NIX_PATH="${nixPath}"
      $(nix-build ${sources.nix-darwin} -A installer --no-out-link)/bin/darwin-installer
    '';
  };
in

pkgs.mkShell {
  buildInputs = [
    pkgs.nixpkgs-fmt

    scripts.install-darwin
    scripts.format
  ];
}

let
  sources = import ./nix/sources.nix;

  overlay = self: super: {
    niv = (import sources.niv {}).niv;
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${sources.nixpkgs}"
    "darwin=${sources.nix-darwin}"
    "darwin-config=$HOME/nix-config/current-machine/default.nix"
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

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  scripts = {
    format = pkgs.writeShellScriptBin "format" ''
      export PATH=${pkgs.lib.makeBinPath [ pkgs.nixpkgs-fmt ]}:$PATH
      nixpkgs-fmt $(find . -name '*.nix')
    '';
  };
in
pkgs.mkShell {
  buildInputs = [
    scripts.format
    pkgs.home-manager
  ];
}

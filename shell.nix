let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  home-manager = pkgs.home-manager.overrideAttrs (old: {
    src = sources.home-manager;
  });
in
pkgs.mkShell {
  buildInputs = [
    home-manager
    pkgs.nixpkgs-fmt
  ];
}

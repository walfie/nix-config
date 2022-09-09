{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vim-plugins-overlay.url = "path:./overlays/vim-plugins";
  };

  outputs = inputs @ { nixpkgs, home-manager, ... }:
    let
      # `cargo-watch` fails to build on M1 Mac, so use the x86 version.
      #
      # Workaround: https://github.com/hercules-ci/flake-parts/issues/50#issuecomment-1212175176
      # Underlying issue: https://github.com/NixOS/nixpkgs/issues/146349
      rosetta-overlay = final: prev: {
        cargo-watch = inputs.nixpkgs.legacyPackages.x86_64-darwin.cargo-watch;
      };

      overlays = [
        inputs.rust-overlay.overlays.default
        inputs.vim-plugins-overlay.overlays.default
        rosetta-overlay
      ];
    in
    {
      homeConfigurations.personal = home-manager.lib.homeManagerConfiguration (
        let
          system = "x86_64-darwin";
          pkgs = import nixpkgs { inherit system overlays; };
        in
        import ./machines/personal { inherit system pkgs; }
      );
    };
}

{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    call-flake.url = "github:divnix/call-flake";
  };

  outputs = inputs @ { nixpkgs, nixpkgs-unstable, call-flake, nixvim, ... }:
    let
      overlays = [
        inputs.rust-overlay.overlays.default
        (call-flake ./flakes/fish-plugins).overlays.default
      ];

      mkHomeManagerConfig = { hmModule, system }:
        let
          system-specific-overlay = final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${system};
            nixvim.nvim = (call-flake ./flakes/nixvim-config).packages.${system}.default;
          };
          nixpkgs-module = {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.allowUnfreePredicate = _: true;
            nixpkgs.overlays = overlays ++ [ system-specific-overlay ];
          };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            hmModule
            nixpkgs-module
            inputs.nix-index-database.homeModules.nix-index
          ];
        };
    in
    {
      inherit nixpkgs overlays nixvim;

      homeConfigurations.personal = mkHomeManagerConfig {
        system = "aarch64-darwin";
        hmModule = ./machines/personal;
      };

      homeConfigurations.wsl = mkHomeManagerConfig {
        system = "x86_64-linux";
        hmModule = ./machines/personal/wsl.nix;
      };
    };
}

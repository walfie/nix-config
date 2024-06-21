{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    call-flake.url = "github:divnix/call-flake";
  };

  outputs = inputs @ { nixpkgs, home-manager, call-flake, ... }:
    let
      overlays = [
        inputs.rust-overlay.overlays.default
        (call-flake ./overlays/vim-plugins).overlays.default
        (call-flake ./overlays/fish-plugins).overlays.default
      ];

      nixpkgs-module = { nixpkgs.overlays = overlays; };

      mkHomeManagerConfig = { pkgs, module }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          module
          nixpkgs-module
          inputs.nix-index-database.hmModules.nix-index
        ];
      };
    in
    {
      homeConfigurations.personal = mkHomeManagerConfig {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        module = ./machines/personal;
      };
    };
}

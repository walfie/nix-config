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
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.home-manager.follows = "home-manager";
    call-flake.url = "github:divnix/call-flake";
  };

  outputs = inputs @ { nixpkgs, home-manager, call-flake, nixvim, ... }:
    let
      overlays = [
        inputs.rust-overlay.overlays.default
        (call-flake ./flakes/vim-plugins).overlays.default
        (call-flake ./flakes/fish-plugins).overlays.default
      ];

      mkHomeManagerConfig = { hmModule, system }:
        let
          nvim = (call-flake ./flakes/nixvim-config).packages.${system}.default;
          nixvim-overlay = final: prev: { nixvim.nvim = nvim; };
          nixpkgs-module = { nixpkgs.overlays = overlays ++ [ nixvim-overlay ]; };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            hmModule
            nixpkgs-module
            inputs.nix-index-database.hmModules.nix-index
          ];
        };
    in
    {
      inherit nixpkgs overlays nixvim;

      homeConfigurations.personal = mkHomeManagerConfig {
        system = "x86_64-darwin";
        hmModule = ./machines/personal;
      };
    };
}

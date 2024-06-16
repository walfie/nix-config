{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
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
        (import ./overlays/packages)
      ];
    in
    {
      homeConfigurations.personal = home-manager.lib.homeManagerConfiguration (
        import ./machines/personal {
          pkgs = import nixpkgs {
            inherit overlays;
            system = "x86_64-darwin";
          };
        }
      );
    };
}

{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vim-plugins-overlay.url = "path:./overlays/vim-plugins";
  };

  outputs = inputs @ { nixpkgs, home-manager, ... }:
    let
      overlays = [
        inputs.rust-overlay.overlays.default
        inputs.vim-plugins-overlay.overlays.default
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

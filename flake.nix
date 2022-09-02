{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vim-plugins-overlay.url = "path:./overlays/vim-plugins";
    vim-plugins-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";

      overlays = [
        inputs.rust-overlay.overlays.default
        inputs.vim-plugins-overlay.overlays.default
      ];
      pkgs = import nixpkgs { inherit system overlays; };
    in
    {
      homeConfigurations.personal = home-manager.lib.homeManagerConfiguration (
        import ./machines/personal { inherit system pkgs; }
      );
    };
}

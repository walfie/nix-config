{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, rust-overlay, ... }:
    let
      system = "x86_64-darwin";
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs { inherit system overlays; };
    in
    {
      homeConfigurations.luminas = home-manager.lib.homeManagerConfiguration (
        import ./machines/luminas { inherit system pkgs; }
      );
    };
}

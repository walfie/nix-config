{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations.luminas = home-manager.lib.homeManagerConfiguration (
        import ./machines/luminas { inherit system pkgs; }
      );
    };
}

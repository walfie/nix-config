{
  description = "nixvim configuration";

  inputs = {
    call-flake.url = "github:divnix/call-flake";
    dream2nix.url = "github:nix-community/dream2nix";
    pico8-ls = { url = "github:japhib/pico8-ls"; flake = false; };
  };

  outputs = { call-flake, pico8-ls, dream2nix, ... }:
    let
      root-flake = call-flake ../..;
      nixpkgs = root-flake.nixpkgs;
      eachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    in
    {
      packages = eachSystem (system: {
        default = dream2nix.lib.evalModules {
          packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
          specialArgs = { inherit pico8-ls; };
          modules = [
            ./default.nix
            {
              paths.projectRoot = ./.;
              paths.projectRootFile = "flake.nix";
              paths.package = ./.;
            }
          ];
        };
      });
    };
}

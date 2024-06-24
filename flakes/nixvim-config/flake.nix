{
  description = "nixvim configuration";

  inputs = {
    call-flake.url = "github:divnix/call-flake";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ { flake-parts, call-flake, ... }:
    let
      parent-flake = call-flake ../../.;
      vim-plugins-flake = call-flake ../vim-plugins;

      nixvim = parent-flake.nixvim;
      nixpkgs = parent-flake.nixpkgs;
      overlays = parent-flake.overlays ++ [ vim-plugins-flake.overlays.default ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvimModule = { inherit pkgs; module = import ./default.nix; };
          nixvimForSystem = nixvim.legacyPackages.${system};
          nvim = nixvimForSystem.makeNixvimWithModule nixvimModule;
        in
        {
          _module.args.pkgs = import nixpkgs { inherit system overlays; };

          # Run `nix flake check .` to verify that your config is not broken
          checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;

          # Lets you run `nix run .` to start nixvim
          packages.default = nvim;
        };
    };
}

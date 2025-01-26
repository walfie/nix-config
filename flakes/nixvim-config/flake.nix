{
  description = "nixvim configuration";

  inputs = {
    call-flake.url = "github:divnix/call-flake";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ { flake-parts, call-flake, ... }:
    let
      root-flake = call-flake ../..;
      vim-plugins-flake = call-flake ../vim-plugins;
      nixvim = root-flake.nixvim;
      nixpkgs = root-flake.nixpkgs;
      pico8-ls = call-flake ../pico8-ls;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvimModule = { inherit pkgs; module = import ./default.nix; };
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
          packages-overlay = final: prev: {
            pico8-ls = pico8-ls.${system}.default;
          };
        in
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = root-flake.overlays ++ [
              vim-plugins-flake.overlays.default
              packages-overlay
            ];
          };

          # Run `nix flake check .` to verify that your config is not broken
          checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;

          # Lets you run `nix run .` to start nixvim
          packages.default = nvim;
        };
    };
}

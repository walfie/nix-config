{
  description = "Home Manager configuration";

  inputs = {
    # Flakes
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Vim plugins
    vim-ctrlsf.url = "github:dyng/ctrlsf.vim";
    vim-ctrlsf.flake = false;
    vim-minibufexpl.url = "github:weynhamz/vim-plugin-minibufexpl";
    vim-minibufexpl.flake = false;
  };

  outputs = inputs @ { nixpkgs, home-manager, rust-overlay, ... }:
    let
      system = "x86_64-darwin";

      mkVimOverlay = { inputs, names }: final: prev:
        let
          mkVimPlugin = name: prev.vimUtils.buildVimPlugin {
            inherit name;
            src = inputs.${name};
          };
        in
        {
          vimPlugins = prev.vimPlugins // (prev.lib.genAttrs names mkVimPlugin);
        };

      vimOverlay = mkVimOverlay {
        inherit inputs;
        names = [ "vim-ctrlsf" "vim-minibufexpl" ];
      };
      overlays = [ (import rust-overlay) (vimOverlay) ];
      pkgs = import nixpkgs { inherit system overlays; };
    in
    {
      homeConfigurations.luminas = home-manager.lib.homeManagerConfiguration (
        import ./machines/luminas { inherit system pkgs; }
      );
    };
}

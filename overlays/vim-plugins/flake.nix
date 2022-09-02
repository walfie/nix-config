{
  description = "Overlay for (Neo)vim plugins";

  inputs = {
    vim-ctrlsf.url = "github:dyng/ctrlsf.vim";
    vim-ctrlsf.flake = false;
    vim-minibufexpl.url = "github:weynhamz/vim-plugin-minibufexpl";
    vim-minibufexpl.flake = false;
    neo-tree-nvim.url = "github:nvim-neo-tree/neo-tree.nvim/v2.x";
    neo-tree-nvim.flake = false;
    nui-nvim.url = "github:MunifTanjim/nui.nvim";
    nui-nvim.flake = false;
  };

  outputs = inputs: {
    overlays.default = final: prev:
      prev.lib.composeManyExtensions [
        (self: super:
          let
            mkVimPlugin = name: src: super.vimUtils.buildVimPluginFrom2Nix { inherit name src; };
          in
          {
            vimPlugins = super.vimPlugins // (builtins.mapAttrs mkVimPlugin inputs);
          }
        )

        (import ./overrides.nix)
      ]
        final
        prev;
  };
}

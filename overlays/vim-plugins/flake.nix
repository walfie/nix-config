{
  description = "Overlay for (Neo)vim plugins";

  inputs = {
    fzf-lua.url = "github:ibhagwan/fzf-lua";
    fzf-lua.flake = false;
    neo-tree-nvim.url = "github:nvim-neo-tree/neo-tree.nvim/v2.x";
    neo-tree-nvim.flake = false;
    nui-nvim.url = "github:MunifTanjim/nui.nvim";
    nui-nvim.flake = false;
    vim-ctrlsf.url = "github:dyng/ctrlsf.vim";
    vim-ctrlsf.flake = false;
    barbar-nvim.url = "github:romgrk/barbar.nvim";
    barbar-nvim.flake = false;
  };

  outputs = inputs: {
    overlays.default = final: prev:
      prev.lib.composeManyExtensions [
        (self: super:
          let
            mkVimPlugin = name: src: super.vimUtils.buildVimPluginFrom2Nix { inherit name src; };
          in
          {
            vimExtraPlugins = builtins.mapAttrs mkVimPlugin inputs;
          }
        )

        (import ./overrides.nix)
      ]
        final
        prev;
  };
}

final: prev:
{
  vimExtraPlugins = prev.vimExtraPlugins // {
    # https://github.com/NixOS/nixpkgs/blob/21de2b97/pkgs/applications/editors/vim/plugins/overrides.nix#L419-L421
    fzf-lua = prev.vimExtraPlugins.fzf-lua.overrideAttrs (old: {
      propagatedBuildInputs = [ prev.fzf ];
    });

    neo-tree-nvim = prev.vimExtraPlugins.neo-tree-nvim.overrideAttrs (old: {
      dependencies = with prev.vimPlugins; [
        prev.vimPlugins.plenary-nvim
        prev.vimExtraPlugins.nui-nvim
      ];
    });
  };
}

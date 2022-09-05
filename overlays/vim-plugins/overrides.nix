final: prev:
{
  vimExtraPlugins = prev.vimExtraPlugins // {
    neo-tree-nvim = prev.vimExtraPlugins.neo-tree-nvim.overrideAttrs (old: {
      dependencies = with prev.vimPlugins; [
        prev.vimPlugins.plenary-nvim
        prev.vimExtraPlugins.nui-nvim
      ];
    });
  };
}

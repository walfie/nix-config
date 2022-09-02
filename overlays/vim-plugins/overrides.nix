final: prev:
{
  vimPlugins = prev.vimPlugins // {
    neo-tree-nvim = prev.vimPlugins.neo-tree-nvim.overrideAttrs (old: {
      dependencies = with prev.vimPlugins; [ plenary-nvim nui-nvim ];
    });
  };
}

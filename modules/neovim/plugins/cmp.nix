{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      preselect = "cmp.PreselectMode.None";
      mapping = {
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<CR>" = "cmp.mapping.confirm()";
      };

      # Sources will be automatically enabled since `cmp.autoEnableSources` is `true`
      sources = [
        { name = "buffer"; }
        { name = "luasnip"; }
        { name = "nvim_lsp"; }
        #{ name = "nvim_lsp_signature_help"; }
        { name = "nvim_lua"; }
        { name = "path"; }
      ];
    };
  };
}

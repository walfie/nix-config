{
  programs.nixvim = {
    plugins.barbar = {
      enable = true;
      settings = {
        animation = false;
        icons = {
          buffer_index = true;
          button = false;
        };
      };
      keymaps = {
        previous.key = "<C-h>";
        next.key = "<C-l>";
        close.key = "<Leader>q";
      };
    };

    keymaps = [
      {
        action = "<Cmd>BufferClose!<CR>";
        key = "<Leader>Q";
        mode = "n";
      }
    ];

    extraConfigLua = ''
      local bufferline_api = require("bufferline.api")
      for index = 1,9 do
        vim.api.nvim_create_user_command("B" .. index, function()
          bufferline_api.goto_buffer(index)
        end, { desc = "Go to buffer " .. index })
      end
    '';
  };
}

vim.g.neo_tree_remove_legacy_commands = 1;

local neotree = require("neo-tree")
local neotree_command = require("neo-tree.command")

neotree.setup({
  close_if_last_window = true,
  enable_git_status = false,
  enable_diagnostics = false,
  window = {
    width = 30,
    mappings = {
      ["/"] = "none",
      ["b"] = "buffers",
      ["A"] = { "add_directory", config = { show_path = "absolute" } },
      ["a"] = { "add", config = { show_path = "absolute" } },
      ["c"] = { "copy", config = { show_path = "absolute" } },
      ["m"] = { "move", config = { show_path = "absolute" } },
    },
  },
  filesystem = {
    hide_dotfiles = false,
    hide_gitignored = false,
    follow_current_file = true,
    group_empty_dirs = true,
    filtered_items = {
      visible = true,
    },
    commands = {
      buffers = function()
        neotree_command.execute({ source = "buffers" })
      end,
    },
  },
  buffers = {
    window = {
      mappings = {
        ["d"] = "buffer_delete",
        ["b"] = "filesystem",
        ["bd"] = "none",
      },
    },
    commands = {
      filesystem = function()
        neotree_command.execute({ source = "filesystem" })
      end,
    },
  },
  event_handlers = {
    {
      event = "vim_buffer_enter",
      handler = function(_)
        if vim.bo.filetype == "neo-tree" then
          vim.opt_local.statusline = "%#Normal#"
        end
      end,
    }
  },
  -- Remove default containers (allow seeing long file names)
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/a7d6f05e57487326fd70b24195c3b7a86a88b156/lua/neo-tree/defaults.lua#L216-L257
  renderers = {
    directory = {
      { "indent" },
      { "icon" },
      { "current_filter" },
      { "name", zindex = 10 },
      { "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
      { "clipboard", zindex = 10 },
      { "diagnostics", errors_only = true, zindex = 20, align = "right" },
    },
    file = {
      { "indent" },
      { "icon" },
      { "name", zindex = 10 },
      { "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
      { "bufnr", zindex = 10 },
      { "modified", zindex = 20, align = "right" },
      { "diagnostics", zindex = 20, align = "right" },
      { "git_status", zindex = 20, align = "right" },
    },
  },
})

vim.keymap.set("n", "<Leader>n", ":Neotree toggle<CR>", {
  desc = "Toggle neo-tree",
  silent = true,
})


-- General vim settings
do
  vim.opt.expandtab = true -- Insert spaces instead of tabs
  vim.opt.incsearch = false -- Disable incremental search (only scroll on submitting the search)
  vim.opt.lazyredraw = true -- Don't redraw screen while executing macros
  vim.opt.linebreak = true -- Wrap long lines on word boundaries
  vim.opt.list = true -- Show listchars
  vim.opt.listchars = { tab = "> ", trail = ".", nbsp = "+" } -- Display characters for whitespace
  vim.opt.modeline = false -- Ignore modelines (vim-specific comments in files)
  vim.opt.number = true -- Show line numbers
  vim.opt.sessionoptions = { "buffers" } -- Only store buffer info in `:mksession`
  vim.opt.shiftwidth = 2 -- 2-space indentation by default
  vim.opt.synmaxcol= 2048 -- Stop syntax highlighting on long lines
  vim.opt.undofile = true -- Keep undo history after closing nvim
  vim.opt.virtualedit = { "block" } -- Allow placing cursor anywhere in virtual select mode
  vim.opt.visualbell = true -- Disable error sounds

  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appear/become resolved.
  vim.opt.signcolumn = "number"

  -- Searching
  vim.opt.ignorecase = true -- Case-insensitive search by default
  vim.opt.smartcase = true -- If search pattern has uppercase, use case-sensitive match

  -- Highlight right margin
  vim.opt.colorcolumn = { 72, 80, 90, 100 }
  vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 235 })

  -- Status line
  vim.opt.statusline = table.concat({
    "%F", -- Full path to file
    "%=", -- Add spaces to right-justify the rest of the line
    "%l/%L,%v", -- Line number / Total number of lines, Virtual column
    " %p%%", -- Percentage through file (lines)
  })

  -- Disable slow SQL dynamic completion
  vim.g.omni_sql_no_default_maps = 1
end

-- Commands
do
  -- Remove trailing whitespace
  -- (`e` flag to suppress error if no trailing whitespace found)
  vim.api.nvim_create_user_command("Clean", [[:%s/\s\+$//e]], {})
end

-- Mappings
do
  -- Copy to clipboard
  -- https://www.reddit.com/r/neovim/comments/3fricd/easiest_way_to_copy_from_neovim_to_system/ctrru3b/
  vim.keymap.set({"n", "v"}, "<Leader>y", [["+y]], { noremap = true })
  vim.keymap.set({"n", "v"}, "<Leader>Y", [["+yg_]], { noremap = true })

  -- Paste from clipboard
  vim.keymap.set({"n", "v"}, "<Leader>p", [["+p]], { noremap = true })
  vim.keymap.set({"n", "v"}, "<Leader>P", [["+P]], { noremap = true })

  -- Switch between buffers
  vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-h>", ":bprevious<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-l>", ":bnext<CR>", { noremap = true, silent = true })

  -- Clear highlighed search
  vim.keymap.set("n", "<CR>", ":nohlsearch<CR><CR>", { noremap = true, silent = true })
end

-- Autocommands
do
  -- Stop automatically inserting comments when inserting a new line
  -- https://vim.fandom.com/wiki/Disable_automatic_comment_insertion#Disabling_in_general
  vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function ()
        vim.opt.formatoptions:remove('c')
        vim.opt.formatoptions:remove('r')
        vim.opt.formatoptions:remove('o')
      end,
  })

  -- When editing crontab, disable backups to avoid the 'temp file must be
  -- edited in place' error
  -- https://vim.fandom.com/wiki/Editing_crontab
  vim.api.nvim_create_autocmd("FileType", {
      pattern = "crontab",
      callback = function ()
        vim.opt_local.backup = false
        vim.opt_local.writebackup = false
      end,
  })
end


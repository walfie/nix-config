-- General vim settings
vim.opt.expandtab = true -- Insert spaces instead of tabs
vim.opt.lazyredraw = true -- Don't redraw screen while executing macros
vim.opt.linebreak = true -- Wrap long lines on word boundaries
vim.opt.list = true -- Show listchars
vim.opt.listchars = { tab = "> ", trail = ".", nbsp = "+" } -- Display characters for whitespace
vim.opt.incsearch = false -- Disable incremental search (only scroll on submitting the search)
vim.opt.modeline = false -- Ignore modelines (vim-specific comments in files)
vim.opt.number = true -- Show line numbers
vim.opt.sessionoptions = { "buffers" } -- Only store buffer info in `:mksession`
vim.opt.shiftwidth = 2 -- 2-space indentation by default
vim.opt.synmaxcol= 2048 -- Stop syntax highlighting on long lines
vim.opt.undofile = true -- Keep undo history after closing nvim
vim.opt.virtualedit = { "block" } -- Allow placing cursor anywhere in virtual select mode
vim.opt.visualbell = true -- Disable error sounds

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


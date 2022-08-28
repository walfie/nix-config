" Write to a file as root
command! W :execute ':silent w !sudo tee % >/dev/null' | :edit!
command! Wq :execute ':W' | :q

" Strip all trailing whitespace
command! Clean :execute ':%s/\s\+$//'

" Misc settings
set expandtab " Insert spaces instead of tabs
set lazyredraw " Don't redraw screen while executing macros
set linebreak " Wrap long lines on word boundaries
set list " Show listchars
set listchars=tab:>\ ,trail:.,nbsp:+ " Display characters for whitespace
set noincsearch " Disable incremental search (only scroll on submitting the search)
set nomodeline " Ignore modelines (vim-specific comments in files)
set number " Show line numbers
set sessionoptions=buffers " Only store buffer info in `:mksession`
set shiftwidth=2 " 2-space indentation by default
set synmaxcol=2048 " Stop syntax highlighting on long lines
set undofile " Keep undo history after closing nvim
set virtualedit=block " Allow placing cursor anywhere in virtual select mode
set visualbell " Disable error sounds

" Status line (file, line, total lines, vcolumn, percent)
set statusline=%F%=%l/%L,%v\ %p%%

" Searching
set ignorecase " Case-insensitive search by default
set smartcase " If search pattern has uppercase, consider case

" Don't change cursor shape in neovim insert mode
" https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-shape-in-the-terminal
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=

"FormatOptions to disable autocomments
autocmd FileType * setlocal formatoptions-=c fo-=o fo-=r fo+=l

" Avoid 'crontab: temp file must be edited in place' error while editing crontab
" https://vim.fandom.com/wiki/Editing_crontab
autocmd FileType crontab setlocal nobackup nowritebackup

" Disable slow SQL dynamic completion
let g:omni_sql_no_default_maps = 1

" Colors
set t_Co=256
match TrailingWhiteSpace /\s\+$/

" Highlight right margin
if exists('+colorcolumn')
  set colorcolumn=72,80,90,100
  highlight ColorColumn ctermbg=235
endif

" Copy to clipboard
" https://www.reddit.com/r/neovim/comments/3fricd/easiest_way_to_copy_from_neovim_to_system/ctrru3b/
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Delete buffer
map <silent> <Leader>q :Bdelete<CR>
map <silent> <Leader>Q :Bdelete!<CR>

" Switch between buffers
nnoremap <silent> <C-t> :enew<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-h> :bprevious<CR>

" Clear highlighted text
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


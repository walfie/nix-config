" Write to a file as root
command! W :execute ':silent w !sudo tee % >/dev/null' | :edit!
command! Wq :execute ':W' | :q

" Strip all trailing whitespace
command! Clean :execute ':%s/\s\+$//'

" Misc settings
syntax on
set autoindent
set backspace=2
set expandtab
set hidden
set lazyredraw
set linebreak
set list
set listchars=tab:>\ ,trail:.
set noincsearch
set nomodeline
set number
set sessionoptions=buffers
set shiftwidth=2
set shortmess-=S
set showcmd
set showmode
set synmaxcol=2048
set tabstop=2
set virtualedit=block

" Status line (file, line, total lines, vcolumn, percent)
set laststatus=2
set statusline=%F%=%l/%L,%v\ %p%%

" Disable error sounds
set visualbell
set noerrorbells

" Persistent undo
set undodir=~/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

" Conform to XDG base directory specification
if !empty($XDG_DATA_HOME)
  set undodir=$XDG_DATA_HOME/vim/undo
  set directory=$XDG_DATA_HOME/vim/swap
  set backupdir=$XDG_DATA_HOME/vim/backup
  set viewdir=$XDG_DATA_HOME/vim/view
  let g:NERDTreeBookmarksFile=$XDG_DATA_HOME . '/vim/NERDTreeBookmarks'

  if !has('nvim')
    set viminfo+='1000,n$XDG_DATA_HOME/vim/viminfo
  endif
endif

if !empty($XDG_CACHE_HOME)
  let g:netrw_home=$XDG_CACHE_HOME . '/vim'
endif

" Searching
set ignorecase
set smartcase
set hlsearch

" Don't change cursor shape in neovim insert mode
" https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-shape-in-the-terminal
:set guicursor=
:autocmd OptionSet guicursor noautocmd set guicursor=

"FormatOptions to disable autocomments
autocmd FileType * setlocal formatoptions-=c fo-=o fo-=r fo+=l
autocmd FileType minibufexpl setlocal statusline=%#Normal#
autocmd FileType crontab setlocal nobackup nowritebackup

" Disable SQL dynamic completion
let g:omni_sql_no_default_maps = 1

" Colors
set t_Co=256
match TrailingWhiteSpace /\s\+$/

"Highlight right margin
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


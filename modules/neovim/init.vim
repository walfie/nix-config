" Write to a file as root
command! W :execute ':silent w !sudo tee % >/dev/null' | :edit!
command! Wq :execute ':W' | :q

" Strip all trailing whitespace
command! Clean :execute ':%s/\s\+$//'

" FormatOptions to disable autocomments
autocmd FileType * setlocal formatoptions-=c fo-=o fo-=r fo+=l

" Avoid 'crontab: temp file must be edited in place' error while editing crontab
" https://vim.fandom.com/wiki/Editing_crontab
autocmd FileType crontab setlocal nobackup nowritebackup

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


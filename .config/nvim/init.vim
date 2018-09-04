" Allows one to cycle through menu options
set wildmenu

" Sets each tab to two spaces and expands all tabs into two spaces
set tabstop=2 shiftwidth=2 expandtab

" Disable swp files because git
set noswapfile

" set relative line numbers by default
" set number ensures that the current line is
" displayed instead of a zero with relative numbers
set number
set relativenumber

" Ignore case in / and ? searches
set ignorecase

" Set the cursor line
set cursorline

" Set our leader key to space
let mapleader = "\<space>"
let maplocalleader = ";;"

" make sure that splits appear bellow and to the right
set splitright
set splitbelow

" Dictory browsing commands
nnoremap <leader>ff :e .<CR>
nnoremap <leader>fv :vsplit .<CR>
nnoremap <leader>fh :split .<CR>

" Commands to get to vim configuration quickly
command! ReloadConfig source $MYVIMRC
command! LoadConfig edit $MYVIMRC

" buffer browsing commands
" jump to previous buffer
nnoremap <silent><leader><tab> :buffer#<CR>
" jump to a buffer
nnoremap <leader>bb :buffers<CR>:b
" jump to buffer but create it in a right split
nnoremap <leader>br :buffers<CR>:vert belowright sb
" jump to buffer but create it in a bottom split
nnoremap <leader>ba :buffers<CR>:bo belowright sb
" delete a buffer
nnoremap <leader>bd :buffers<CR>:bd

" fast navigation
nnoremap <leader>w <C-W>

" repeat the last : command
nnoremap <leader>r @:<CR>

" switch off highlighting
nnoremap <leader>L :nohl<CR>

function! OpenQuickfix(command) 
  execute('cexp ' . "system('" . a:command . "')")
  if len(getqflist())
    execute 'copen'
  else
    execute 'cclose'
  endif
endfunction

augroup cppmappings
  autocmd!
  autocmd FileType cpp nnoremap <buffer> <localleader>b :call OpenQuickfix('make build')<CR>
  autocmd FileType cpp nnoremap <buffer> <localleader>r :make run<CR>
  autocmd FileType cpp setlocal tabstop=4 shiftwidth=4
augroup END

augroup gomappings
  autocmd!
  " If we have neovim open the results of run in a terminal buffer in the
  " screen bellow otherwise just use a bang command
  if has('nvim')
    autocmd FileType go nnoremap <buffer> <localleader>r :10split term://go run %<CR>
  else
    autocmd FileType go nnoremap <buffer> <localleader>r :!go run %<CR>
  endif
  " Build a go program and open the results in the quickfix window
  autocmd FileType go nnoremap <buffer> <silent><localleader>b :call OpenQuickfix('go build ' . bufname('%'))<CR>
augroup END

colorscheme desert

if has('nvim')
  " open a split terminal window
  nnoremap <leader>tv :vsplit term://bash<CR>
  nnoremap <leader>ts :10split term://bash<CR>

  " Allows us to escape from terminal windows in normal mode
  tnoremap <Esc> <C-n><C-\>
  tnoremap <M-p> <C-n><C-\><C-W>p

  augroup term
    autocmd!
    " Automatically start insert mode when we enter a temrinal buffer
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
    " Switch off line numbers in terminal mode
    autocmd TermOpen term://* setlocal nonumber norelativenumber
  augroup END
augroup nand2tetris
  autocmd!
  autocmd filetype vhdl setlocal syntax=off
augroup END

endif

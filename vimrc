" =====================================================================================================================
" @@ Config
" =====================================================================================================================

set number
set noerrorbells
set nowritebackup
set nobackup
set nowrap

set virtualedit=block
set backspace=indent,eol,start
set ambiwidth=double
set wildmenu
set shellslash
set showmatch
set matchtime=1
set cinoptions+=:0
set hlsearch
set incsearch
set cursorline
set showtabline=2
set showcmd
set display=lastline

set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set guioptions-=T
set guioptions+=a
set smartindent
set noswapfile
set title
set clipboard+=unnamed,autoselect
set ignorecase
set smartcase
set wrapscan

set nrformats=
set whichwrap=b,s,h,l,<,>,[,],~
set mouse=a
filetype on
set cmdheight=2
autocmd BufWritePre * :%s/\s\+$//ge

syntax on

" =====================================================================================================================
" @@ Appearance
" =====================================================================================================================

set laststatus=2
colorscheme slate

function! ReplaceColours()
  highlight User1 cterm=bold ctermfg=015 ctermbg=057 " Insert
  highlight User2 cterm=bold ctermfg=015 ctermbg=125 " Normal
  highlight User3 cterm=bold ctermfg=015 ctermbg=172 " Terminal
  highlight User4 cterm=bold ctermfg=015 ctermbg=011 " Visual
  highlight User5 cterm=bold ctermfg=015 ctermbg=175 " Default

  let modes = {'i': '1* INSERT', 'n': '2* NORMAL', 'R': '4* REPLACE', 'c': '3* COMMAND', 't': '3* TERMIAL', 'v': '4* VISUAL', 'V': '4* VISUAL', "\<C-v>": '4* VISUAL'}
  let mode = match(keys(modes), mode()) != -1 ? modes[mode()] : '5* Another'

  return '%' . mode . ' %*' . ' %<%F ' . '%m%h%w' . '%=' . 'VIM - ' . '%l/%L %c [%p%%'
endfunction

autocmd VimEnter,ColorScheme * highlight Comment ctermfg=175
autocmd VimEnter,ColorScheme * highlight StatusLine cterm=NONE ctermfg=15 ctermbg=175 " Default StatusLine with Active
autocmd VimEnter,ColorScheme * highlight StatusLineNC cterm=NONE ctermfg=7 ctermbg=0 " Default StatusLine with Inactive
autocmd VimEnter,ColorScheme * highlight Normal ctermbg=238
autocmd VimEnter,ColorScheme * set statusline=%!ReplaceColours()

" =====================================================================================================================
" @@ Visible FullWidthSpace
" =====================================================================================================================

function! FullWidthSpace()
  highlight FullWidthSpace cterm=reverse ctermfg=DarkMagenta
endfunction

if has('syntax')
  augroup FullWidthSpace
  autocmd!
  autocmd ColorScheme       * call FullWidthSpace()
  autocmd VimEnter,WinEnter * match FullWidthSpace /　/
  augroup END
  call FullWidthSpace()
endif

" =====================================================================================================================
" @@ AutoPair
" =====================================================================================================================

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" =====================================================================================================================
" @@ Terminal
" =====================================================================================================================

function! OpenTerminal()
  botright split
  execute 'terminal ++close ++shell'
  wincmd j
  quit
  resize 10
endfunction

nnoremap <silent> <C-t> :call OpenTerminal()<CR>
tnoremap <ESC> <c-\><c-n>

augroup TerminalHighlight
  autocmd!
  autocmd TerminalOpen * highlight Terminal ctermbg=NONE guibg=NONE
  autocmd TerminalOpen * setlocal winhighlight=Normal:Terminal
augroup END

" =====================================================================================================================
" @@ Netrw
" =====================================================================================================================

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_preview=0
let g:netrw_winsize=20
let g:netrw_altv=1
let g:netrw_alto=1

let g:netrw_keepdir=0
let g:netrw_preview=1
let g:netrw_chgwin=-1

let g:NetrwIsOpen=0

function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
    while (i >= 1)
      if (getbufvar(i, "&filetype") == "netrw")
        silent exec "bwipeout " . i
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Vexplore  " Netrwを水平分割で開く
  endif
endfunction

nnoremap <silent> <C-n> :call ToggleNetrw()<CR>


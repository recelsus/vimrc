" =====================================================================================================================
" @@ init
" =====================================================================================================================

let g:pluginEnable = 1                       " 外部プラグインを利用する場合は1 しない場合は0
let g:exSyntaxEnable = 1                     " 外部SyntaxHighlightを利用する場合は1, しない場合は0

" =====================================================================================================================
" @@ Config
" =====================================================================================================================

set number                                   " 行番号を表示する
set noerrorbells                             " ビープ音を無効にする
set nowritebackup                            " ファイルのバックアップを作成しない
set nobackup                                 " ファイルのバックアップを作成しない
set nowrap                                   " 行の折り返しを無効にする

set virtualedit=block                        " 仮想編集モードをブロック選択に設定する
set backspace=indent,eol,start               " バックスペースキーでインデント、行末、行の開始位置を削除可能にする
set ambiwidth=double                         " 両幅文字の幅を2に設定する
set wildmenu                                 " コマンド補完時にメニューを表示する
set shellslash                               " シェルコマンドでスラッシュを使用する
set showmatch                                " 対応する括弧を表示する
set matchtime=1                              " 対応する括弧の表示時間を1に設定する
set cinoptions+=:0                           " Cインデントオプションに0を追加する
set hlsearch                                 " 検索結果をハイライト表示する
set incsearch                                " インクリメンタルサーチを有効にする
set cursorline                               " カーソル行をハイライトする
set showtabline=2                            " タブラインを常に表示する
set showcmd                                  " コマンドの一部を表示する
set display=lastline                         " 画面外の行の最後の部分を表示する

set expandtab                                " タブ文字をスペースに変換する
set shiftwidth=2                             " 自動インデントの幅を2スペースに設定する
set softtabstop=2                            " ソフトタブストップを2に設定する
set tabstop=2                                " タブストップを2に設定する

set guioptions-=T                            " GUIオプションからツールバーを削除する
set guioptions+=a                            " GUIオプションに自動コマンドを追加する
set smartindent                              " スマートインデントを有効にする
set noswapfile                               " スワップファイルを作成しない
set title                                    " ウィンドウのタイトルを設定する
set clipboard+=unnamed,autoselect            " クリップボードを共有する（unnamedとautoselect）
set ignorecase                               " 検索時に大文字小文字を無視する
set smartcase                                " スマートケース検索を有効にする
set wrapscan                                 " 検索の循環を有効にする

set nrformats=                               " 数値フォーマットをリセットする
set whichwrap=b,s,h,l,<,>,[,],~              " カーソルの移動を特定の場所に許可する
set mouse=a                                  " マウスを有効にする
filetype on                                  " ファイルタイプを有効にする
set cmdheight=2                              " コマンドラインの高さを2に設定する

" =====================================================================================================================
" @@ Appearance
" =====================================================================================================================

" ColourSchemeをslateに設定
set laststatus=2
colorscheme slate

" ステータスラインに現在のモードを表示
function! ReplaceColours()
  highlight User1 cterm=bold ctermfg=015 ctermbg=057 " Insert
  highlight User2 cterm=bold ctermfg=015 ctermbg=125 " Normal
  highlight User3 cterm=bold ctermfg=015 ctermbg=172 " Terminal
  highlight User4 cterm=bold ctermfg=015 ctermbg=011 " Visual
  highlight User5 cterm=bold ctermfg=015 ctermbg=175 " Default

  let modes = {'i': '1* INSERT', 'n': '2* NORMAL', 'R': '4* REPLACE', 'c': '3* COMMAND', 't': '3* TERMIAL', 'v': '4* VISUAL', 'V': '4* VISUAL', "\<C-v>": '4* VISUAL'}
  let mode = match(keys(modes), mode()) != -1 ? modes[mode()] : '5* Another'

  return '%' . mode . ' %*' . ' %<%F ' . '%m%h%w' . '%=' . '%l/%L %c [%p%%'
endfunction

autocmd VimEnter,ColorScheme * highlight Comment ctermfg=175 " コメントの色
autocmd VimEnter,ColorScheme * highlight StatusLine cterm=NONE ctermfg=15 ctermbg=175 " Default StatusLine with Active
autocmd VimEnter,ColorScheme * highlight StatusLineNC cterm=NONE ctermfg=7 ctermbg=0 " Default StatusLine with Inactive
autocmd VimEnter,ColorScheme * highlight Normal ctermbg=234 " 背景色
autocmd VimEnter,ColorScheme * set statusline=%!ReplaceColours()

" =====================================================================================================================
" @@ SyntaxHighlight
" =====================================================================================================================

syntax on
if g:exSyntaxEnable

  let g:syntaxDir = expand('$HOME/.vim/after/syntax')

  " wgetできるsyntaxファイルのURLを指定
  let g:syntaxFiles = [
      \ 'https://raw.githubusercontent.com/octol/vim-cpp-enhanced-highlight/master/after/syntax/cpp.vim',
      \ 'https://raw.githubusercontent.com/leafgarland/typescript-vim/master/syntax/typescript.vim',
      \ 'https://raw.githubusercontent.com/vim/vim/master/runtime/syntax/javascript.vim',
      \ 'https://raw.githubusercontent.com/vim/vim/master/runtime/syntax/python.vim'
      \]

  function! EnsureDirectory(dir)
    if !isdirectory(a:dir)
      call mkdir(a:dir, 'p')
    endif
  endfunction

  " syntaxファイルをダウンロード
  function! DownloadSyntaxFiles()
    call EnsureDirectory(g:syntaxDir)
    for file_url in g:syntaxFiles
      let file_name = fnamemodify(file_url, ':t')
      let file_path = g:syntaxDir . '/' . file_name
      if !filereadable(file_path)
        echomsg 'Downloading ' . file_name . ' into ' . shellescape(file_path)
        call system('wget -O ' . shellescape(file_path) . ' ' . shellescape(file_url))
      endif
    endfor
  endfunction

  autocmd VimEnter * call DownloadSyntaxFiles()

endif

" =====================================================================================================================
" @@ AutoCommand
" =====================================================================================================================

autocmd BufWritePre * :%s/\s\+$//ge          " 保存時に末尾スペースを削除

" Undoを永続化 ----------------------------------------------------

autocmd VimEnter * call system('mkdir -p ' . expand('$HOME') . '/.vim/undo')

if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' .. undo_path
  set undofile
endif

" 全角スペースを可視化 --------------------------------------------

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

" AutoPair --------------------------------------------------------

inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap (<CR> (<CR>)<Esc>O

inoremap " ""<Left>
inoremap ' ''<Left>

inoremap <expr> <BS> RemovePair()

function! RemovePair()
  let col = col('.') - 1
  if getline('.')[col - 1] ==# '{' && getline('.')[col] ==# '}'
    return "\<C-O>l\<C-O>x\<C-O>h\<C-O>x"
  elseif getline('.')[col - 1] ==# '(' && getline('.')[col] ==# ')'
    return "\<C-O>l\<C-O>x\<C-O>h\<C-O>x"
  elseif getline('.')[col - 1] ==# '[' && getline('.')[col] ==# ']'
    return "\<C-O>l\<C-O>x\<C-O>h\<C-O>x"
  elseif getline('.')[col - 1] ==# '"' && getline('.')[col] ==# '"'
    return "\<C-O>l\<C-O>x\<C-O>h\<C-O>x"
  elseif getline('.')[col - 1] ==# ''' && getline('.')[col] ==# '''
    return "\<C-O>l\<C-O>x\<C-O>h\<C-O>x"
  else
    return "\<BS>"
  endif
endfunction

" ターミナルをCtrl+tで起動(終了はexit)-----------------------------

function! OpenTerminal()
  botright split
  execute 'terminal ++close ++shell'
  wincmd j
  quit
  resize 10
endfunction

" Ctrl+t && ESCでNormalMode
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

let g:netrw_banner=0                         " Netrwバナーを非表示にする
let g:netrw_liststyle=3                      " ツリー形式でリスト表示を行う
let g:netrw_browse_split=4                   " ファイルを新しいタブで開く
let g:netrw_preview=0                        " ファイルプレビューを無効にする
let g:netrw_winsize=20                       " Netrwウィンドウのサイズを20に設定する
let g:netrw_altv=1                           " 垂直分割を使用して代替ウィンドウを開く
let g:netrw_alto=1                           " ファイルを代替ウィンドウに開く

let g:netrw_keepdir=0                        " Netrwウィンドウでディレクトリを変更する
let g:netrw_preview=1                        " ファイルプレビューを有効にする
let g:netrw_chgwin=-1                        " ファイルを開いたときに最後にアクセスしたウィンドウにフォーカスを当てる

let g:NetrwIsOpen=0                          " Netrwの状態を初期化する

" Netrwウィンドウをトグル
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

" <C-n>キーにNetrwウィンドウのトグルをマッピングする
nnoremap <silent> <C-n> :call ToggleNetrw()<CR>

" =====================================================================================================================
" @@ Plugins Config
" =====================================================================================================================

if g:pluginEnable

  let g:pluginDir = expand('$HOME/.vim/plugins')
  let g:plugins = [
    \ 'https://github.com/prabirshrestha/vim-lsp.git',
    \ 'https://github.com/mattn/vim-lsp-settings.git'
    \ ]

  " ディレクトリが存在しない場合に作成する
  function! EnsureDirectory(dir)
    if !isdirectory(a:dir)
      call mkdir(a:dir, 'p')
    endif
  endfunction

  function! ClonePlugins()
    call EnsureDirectory(g:pluginDir)
    for plugin in g:plugins
      let plugin_name = matchstr(plugin, '[^/]*$')
      let plugin_name = substitute(plugin_name, '\.git', '', '')
      let plugin_path = g:pluginDir . '/' . plugin_name
      if !isdirectory(plugin_path)
        call system('git clone ' . shellescape(plugin) . ' ' . plugin_path)
        echomsg 'Cloning ' . plugin_name . ' into ' . shellescape(plugin_path)
      else
        echomsg plugin_name . ' already exists in ' . shellescape(plugin_path)
      endif
    endfor
  endfunction

  autocmd VimEnter * call ClonePlugins()   " Vim起動時にプラグインをクローン
endif

" =====================================================================================================================
" @@ LSP
" =====================================================================================================================

let g:plugin_path = expand('~/.vim/plugins')

if g:pluginEnable && isdirectory(g:plugin_path . '/vim-lsp') && isdirectory(g:plugin_path . '/vim-lsp-settings')
  set runtimepath+=~/.vim/plugins/vim-lsp
  set runtimepath+=~/.vim/plugins/vim-lsp-settings

  function! SetupLSP()
    if executable('clangd')
      call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
    endif

    if executable('bash-language-server')
      call lsp#register_server({
        \ 'name': 'bashls',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
    endif

    if executable('typescript-language-server')
      call lsp#register_server({
        \ 'name': 'tsserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'whitelist': ['typescript', 'typescriptreact', 'javascript', 'javascriptreact'],
        \ })
    endif

  endfunction

  augroup lsp_setup
    autocmd!
    autocmd VimEnter * call SetupLSP()
  augroup END

  function! LspHover()
    try
      call lsp#ui#vim#hover()
    catch /^Vim\%((\a\+)\)\=:E\d\+/
      echo "No hover information available"
    endtry
  endfunction

  augroup lsp_completion
    autocmd!
      autocmd FileType typescript,typescriptreact,javascript,javascriptreact,cpp,sh setlocal omnifunc=lsp#complete
  augroup END

  inoremap <expr> <C-s> pumvisible() ? "\<C-y>" : "\<C-x>\<C-o>"
  inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
  inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
  inoremap <expr> <CR> pumvisible() ? complete_info().selected == -1 ? "\<C-g>u\<CR>\<C-r>=escape(@., '\')" : "\<C-y>" : "\<CR>"

  inoremap <C-n> <Nop>
  inoremap <C-p> <Nop>

  nmap <silent> gd <Plug>(lsp-definition)
  nmap <silent> gr <Plug>(lsp-references)
  nmap <silent> gi <Plug>(lsp-implementation)
  nmap <silent> K :call LspHover()<CR>
endif

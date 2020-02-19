"necessary on some Linux distros for pathogen to properly load bundles
set nocompatible                " choose no compatibility with legacy vi
filetype on

call plug#begin('~/.vim/plugged')

" Plugins go here
Plug 'tpope/vim-repeat'
Plug 'slashmili/alchemist.vim'
Plug 'tpope/vim-fugitive', { 'on': [] }
Plug 'bling/vim-airline'
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'mattn/emmet-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-surround'
Plug 'elzr/vim-json'
Plug 'chemzqm/vim-jsx-improve'
Plug 'rizzatti/dash.vim'
Plug 'isRuslan/vim-es6'
Plug 'preservim/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'
Plug 'burner/vim-svelte'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'dkarter/bullets.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Optional:
Plug 'honza/vim-snippets'

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.sh
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

function! BuildTern(info)
  if a:info.status == 'installed' || a:info.force
    !npm install
  endif
endfunction

Plug 'marijnh/tern_for_vim', { 'do': function('BuildTern') }

function! Installjshint(info)
  if a:info.status == 'installed' || a:info.force
    !npm install -g jshint
  endif
endfunction

command! Gstatus call LazyLoadFugitive('Gstatus')
command! Gdiff call LazyLoadFugitive('Gdiff')
command! Glog call LazyLoadFugitive('Glog')
command! Gblame call LazyLoadFugitive('Gblame')

function! LazyLoadFugitive(cmd)
  call plug#load('vim-fugitive')
  call fugitive#detect(expand('%:p'))
  exe a:cmd
endfunction

Plug 'scrooloose/syntastic', { 'do': function('Installjshint') }

call plug#end()

set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on         " load file type plugins + indentation

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Off automatic backup
set nobackup
set nowritebackup
set noswapfile

set history=1000                "store lots of :cmdline history

set showmode                    "show current mode down the bottom

set number                      "add line numbers
set showbreak=                  "set wrap linebreak nolist

"add some line space for easy reading
set linespace=4

"disable visual bell
set visualbell t_vb=

"statusline setup
"set statusline=%f       "tail of the filename
"set statusline+=%=      "left/right separator
"set statusline+=%c,     "cursor column
"set statusline+=%l/%L   "cursor line/total lines
"set statusline+=\ %P    "percent through file
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P

set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T

" use comma as <Leader> key instead of backslash
let mapleader=","
"
" activate mustache abbreviations
let g:mustache_abbreviations = 1

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
"set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"tell the term has 256 colors
set t_Co=256
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h18
let g:Powerline_symbols = 'fancy'
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

if has("gui_running")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    set guifont=M+\ 1m\ for\ Powerline:h18
  endif
endif

autocmd BufNewFile,BufRead *.jade set filetype=jade
autocmd BufNewFile,BufRead *.styl set filetype=styl
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.coffee set filetype=coffee

syntax on
set background=dark
colorscheme molokai

set guitablabel=%M%t

"map to CommandT TextMate style finder
let g:ctrlp_map = '<c-t>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX

nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>b :!plugged<CR>

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"key mapping for yank lines to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

"key mapping for saving file
"nmap <C-s> :w<CR>

"key mapping for tab navigation
nmap <Tab> gt
nmap <S-Tab> gT
nmap ( ()<left>

"key mapping for clean search
nmap <silent> <leader>/ :nohlsearch<CR>

autocmd vimenter * call s:SetupSnippets()

if has("autocmd")
  autocmd BufWritePost .vimrc source $MYVIMRC
endif

function! s:SetupSnippets()
  try
    call ExtractSnips("~/.vim/plugged/vim-snippets/snippets/javascript", "javascript")
    call ExtractSnips("~/.vim/snippets/javascript.snippet", "javascript")
  catch
  endtry
endfunction

" ragtag
let g:ragtag_global_maps = 1

" Running specs from inside vim
map <Leader>w :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>

autocmd FileType python set sts=4 sw=4

set runtimepath^=~/.vim/plugged/ctrlp.vim

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

imap <C-J> <esc>a<Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger
let g:airline_powerline_fonts = 1
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

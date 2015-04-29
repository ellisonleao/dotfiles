"*****************************************************************************
"" Neobundle Load
"*****************************************************************************
"{{{
 if has('vim_starting')
   set nocompatible               " Be iMproved

   " Required :
   set runtimepath+=~/.vim/bundle/neobundle.vim/
 endif

 " Required :
 call neobundle#begin(expand('~/.vim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required :
 NeoBundleFetch 'Shougo/neobundle.vim'

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note : You don't set neobundle setting in .gvimrc!
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'bling/vim-airline'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'gorodinskiy/vim-coloresque.git'
NeoBundle 'tpope/vim-surround'
NeoBundle 'ryanss/vim-hackernews'
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}


 call neobundle#end()

 " Required :
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck

"}}}


"*****************************************************************************
"                                Basic Setup
"*****************************************************************************
"{{{
" Unleash all VIM power
set nocompatible

" Fix backspace indent
set backspace=indent,eol,start

" Better modes.  Remeber where we are, support yankring
set viminfo=!,'100,\"100,:20,<50,s10,h,n~/.viminfo

" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Enable hidden buffers
set hidden

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,.pyc,__pycache__

"" Remember last location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal g'\"" | endif
endif

" GREP
set grepprg=ack

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set ttyfast
set binary

"Directories for swp files
set nobackup
set nowritebackup
set noswapfile

set sh=/bin/sh

set fileformats=unix,dos,mac
set backspace=indent,eol,start
set showcmd
set shell=zsh

" Set spell pt-br
" remove used: set nospell
" set spell spelllang=pt
highlight clear SpellBad
highlight SpellBad term=reverse cterm=underline

" enable neocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

"}}}


"*****************************************************************************
"                              Visual Settigns
"*****************************************************************************
"{{{
" colorscheme, fonts, menus and etc
set background=dark
syntax on
set number

" Menus I like :-)
" This must happen before the syntax system is enabled
let no_buffers_menu=1
set mousemodel=popup
highlight BadWhitespace ctermbg=red guibg=red
colorscheme seti

set t_Co=256
set nocursorline
set guioptions=egmrt

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
  else
  let g:CSApprox_loaded = 1

  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
endif

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Disable the pydoc preview window for the omni completion
set completeopt-=preview

" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

" Status bar
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Use modeline overrides
set modeline
set modelines=10

let g:airline_theme = 'luna'
let g:airline_enable_branch = 1
let g:airline_enable_syntastic = 1
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


"}}}


"*****************************************************************************
"                               Abbreviations
"*****************************************************************************
"{{{
" no one is really happy until you have this shortcuts
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q

"}}}


"*****************************************************************************
"                                 Variables
"*****************************************************************************
"{{{

" python support
" --------------
"  don't highlight exceptions.
let python_highlight_all=1
let python_highlight_exceptions=1
let python_highlight_builtins=1

let html_no_rendering=1
let javascript_enable_domhtmlcss=1
let c_no_curly_error=1

let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite


"}}}


"*****************************************************************************
"                                  Function
"*****************************************************************************
"{{{
function s:setupWrapping()
set wrap
set wm=2
set textwidth=79
endfunction

function s:setupMarkup()
call s:setupWrapping()
noremap <buffer> <Leader>p :Mm <CR>
endfunction

" GUI Tab settings
function! GuiTabLabel()
  let label = ''
  let buflist = tabpagebuflist(v:lnum)
  if exists('t:title')
      let label .= t:title . ' '
  endif
  let label .= '[' . bufname(buflist[tabpagewinnr(v:lnum) - 1]) . ']'
  for bufnr in buflist
      if getbufvar(bufnr, '&modified')
          let label .= '+'
          break
      endif
  endfor
  return label
endfunction
set guitablabel=%{GuiTabLabel()}

"}}}


"*****************************************************************************
"                               Autocmd Rules
"*****************************************************************************

"{{{
" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart
" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Clean whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" make use real tabs
au FileType make set noexpandtab


"********** Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79,99
    \ formatoptions+=croq softtabstop=4 smartindent
    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
    \smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd BufRead,BufNewFile *.py,*pyw set shiftwidth=4
autocmd BufRead,BufNewFile *.py,*.pyw set expandtab
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/
autocmd BufNewFile *.py,*.pyw set fileformat=unix
autocmd BufRead *.py,*.pyw set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufNewFile,BufRead *.py_tmpl,*.cover setlocal ft=python
" Ignore line width for syntax checking
let g:syntastic_python_flake8_post_args='--ignore=E501'

"********** Go
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

"********** HTML
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
autocmd FileType html,xhtml,xml,htmldjango,htmljinja setlocal colorcolumn=100 expandtab shiftwidth=4 tabstop=8 softtabstop=4


"********** C/C++
autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79

"********** vim
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType vim setlocal foldenable foldmethod=marker

"********** Javascript
autocmd FileType javascript setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=79
autocmd BufNewFile,BufRead *.json setlocal ft=javascript

"********** Cmake
autocmd BufNewFile,BufRead CMakeLists.txt setlocal ft=cmake

"********** Ruby
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

" Set auto reload file
set autoread

"}}}


"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"{{{

" Chrome OS remap <C-w> (command close tab)
map <tab> <c-w>
map <tab><tab> <c-w><c-w>
map ,w <c-w>

" Python Execution
noremap <C-K> :!python<CR>
noremap <C-L> :!python %<CR>

" Split Screen
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk

" Grep
noremap <leader>g :Ack <C-R>=""<CR>
noremap <leader>b :b <C-R>=""<CR>

" Copy
noremap YY "+y<CR>

" Paste
noremap P "+gP<CR>

" Cut
noremap XX "+x<CR>

" Termnal nav
nmap <S-p> :bp<CR>
nmap <S-o> :bn<CR>
noremap ,z :bp<CR>
noremap ,q :bp<CR>
noremap ,x :bn<CR>
noremap ,w :bn<CR>

" Close buffer
noremap ,d :bd<CR>

" Clean search (highlight)
noremap <leader>\ :noh<CR>

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" ctags
map <F8> :!/usr/local/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
map <leader>] g<c-]>

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"

" CtrlP
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|tox)$'
let g:ctrlp_user_command = "find %s -type f | grep -Ev '"+ g:ctrlp_custom_ignore +"'"
let g:ctrlp_use_caching = 0
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
noremap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_map = ',e'
let g:ctrlp_open_new_file = 'r'


" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


"}}}

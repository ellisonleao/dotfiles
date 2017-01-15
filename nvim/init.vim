"*****************************************************************************
"" Plug Load
"*****************************************************************************
"{{{
call plug#begin('~/.vim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'flazz/vim-colorschemes'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'heavenshell/vim-jsdoc'
Plug 'editorconfig/editorconfig-vim'
Plug 'tweekmonster/django-plus.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'fatih/vim-go'
Plug 'neomake/neomake'
Plug 'myusuf3/numbers.vim'

call plug#end()

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

"set encoding=utf-8
"set fileencoding=utf-8
"set fileencodings=utf-8
"set bomb
set ttyfast
"set binary

"Directories for swp files
set nobackup
set nowritebackup
set noswapfile

set sh=/bin/sh

set fileformats=unix,dos,mac
set showcmd
set shell=bash

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" JSDoc
let g:jsdoc_enable_es6=1

" Use deoplete.
let g:deoplete#enable_at_startup = 1

let g:python_host_prog = '/Users/ellison/.pyenv/versions/2/bin/python'
let g:python3_host_prog = '/Users/ellison/.pyenv/versions/3/bin/python'


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
set mouse-=a
highlight BadWhitespace ctermbg=red guibg=red
colorscheme molokai

set nocursorline
"set guioptions=egmrt

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

let g:airline_theme = 'molokai'
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

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

" paste, no paste with \o
set pastetoggle=<leader>o

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
let html_no_rendering=1
let javascript_enable_domhtmlcss=1
let c_no_curly_error=1

let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

"}}}



"*****************************************************************************
"                               Autocmd and Syntax Specific Rules
"*****************************************************************************

"{{{
" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart
" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Validate
autocmd! BufWritePost,BufEnter * Neomake

"" Clean whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" make use real tabs
au FileType make set noexpandtab

set autowrite

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
let python_highlight_builtins=1
let python_highlight_exceptions=1
let python_highlight_doctests=0

"********** Go
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType go setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8

" \n and \p for quickfix list navigation \c to close it
autocmd FileType go map <leader>n :cnext<CR>
autocmd FileType go map <leader>p :cprevious<CR>
autocmd FileType go nnoremap <leader>c :cclose<CR>

" \r run - \b build - \l lint - \t test
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>c  <Plug>(go-coverage-toggle)

let g:go_metalinter_autosave = 1
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"

let g:deoplete#sources#go#pointer = 1

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
autocmd BufRead,BufNewFile *.js,*.jsx,*.json match BadWhitespace /^\t\+/
autocmd BufRead,BufNewFile *.js,*.jsx,*.json match BadWhitespace /\s\+$/


"********** Less & Sass
autocmd FileType less setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80
autocmd FileType sass setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80

"********** Ruby
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 colorcolumn=79,99

"********** bash
autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80

"********** rust
let g:racer_cmd = "/Users/ellison/.cargo/bin/racer"
let $RUST_SRC_PATH="/Users/ellison/Code/rust/src"


" Set auto reload file
set autoread

"}}}


"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"{{{

" Split Screen
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

" try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk

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

" JSDoc
nmap <leader>j :JsDoc<CR>

" Fuzzy Finder
noremap <leader>f :FZF<CR>

"}}}

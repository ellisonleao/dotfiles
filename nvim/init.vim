"*****************************************************************************
"" Plug Load
"*****************************************************************************
"{{{
call plug#begin('~/.vim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'fatih/vim-go'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'heavenshell/vim-jsdoc'
Plug 'tweekmonster/django-plus.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
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
set wildignore+=*.o,*.obj,.git,*.rbc,.pyc,__pycache__,*.beam
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

"" Remember last location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal g'\"" | endif
endif

"Directories for swp files
set nobackup
set nowritebackup
set noswapfile

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" some writing concerns
set autoindent smartindent
set completeopt=menuone,preview

"}}}


"*****************************************************************************
"                              Visual Settigns
"*****************************************************************************
"{{{
" colorscheme, fonts, menus and etc
" set background=dark
" set number
" set t_Co=256
" let g:reshash256=1
let base16colorspace=256

" This must happen before the syntax system is enabled
set mouse-=a
colorscheme base16-default-dark

" let the colors begin
syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

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

set lazyredraw

"}}}


"*****************************************************************************
"                      Autocmd and Syntax Specific Rules
"*****************************************************************************

"{{{
" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Validate
autocmd! BufWritePost,BufWritePre * Neomake

"" Clean whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"********** Makefile
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
autocmd BufNewFile *.py,*.pyw set fileformat=unix
autocmd BufRead *.py,*.pyw set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufNewFile,BufRead *.py_tmpl,*.cover setlocal ft=python

" Ignore line width for syntax checking
let python_highlight_builtins=1
let python_highlight_exceptions=1
let python_highlight_doctests=0
let g:neomake_python_flake8_args = ['--ignore', 'E402,E501']

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
let g:deoplete#sources#go#pointer = 1
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

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

"********** Less & Sass
autocmd FileType less setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80
autocmd FileType sass setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80

"********** Ruby
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 colorcolumn=79,99

"********** bash
autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80

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

" Termnal nav
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

" Fuzzy Finder
noremap <leader>f :FZF<CR>

"}}}
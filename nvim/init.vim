"" Plug Load
"*****************************************************************************
"{{{
call plug#begin('~/.vim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'tweekmonster/django-plus.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'

call plug#end()

"}}}


"*****************************************************************************
"                                Basic Setup
"*****************************************************************************
"{{{
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
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.rbc,.pyc,__pycache__,*.beam
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=node_modules/*,bower_components/*,
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set completeopt=menuone,noinsert,noselect

"" Remember last location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal g'\"" | endif
endif

"Directories for swp files
set nobackup
set nowritebackup
set noswapfile

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" some writing concerns
set autoindent smartindent

" neovim python modules
let g:python3_host_prog='/Users/ellison/.pyenv/versions/3/bin/python'
let g:python_host_prog='/Users/ellison/.pyenv/versions/2/bin/python'

"}}}


"*****************************************************************************
"                              Visual Settigns
"*****************************************************************************
"{{{
" colorscheme, fonts, menus and etc
set number
let base16colorspace=256

" This must happen before the syntax system is enabled
set mouse-=a
colorscheme base16-default-dark

" let the colors begin
syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" airline
let g:airline_theme = 'base16'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1

let g:airline_section_a = airline#section#create_left(['mode'])
let g:airline_section_y = airline#section#create_right(['linenr', '%3v'])
let g:airline_section_z = '%{strftime("%d/%m/%Y %H:%M")}'

" paste, no paste with \o
set pastetoggle=<leader>o

set lazyredraw

" color column 100 by default
set cc=100

" don't give |ins-completion-menu| messages.  For example,
" '-- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c

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

"" Clean whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" file format always unix
set fileformat=unix

"********** Makefile
au FileType make set noexpandtab
set autowrite

"********** Python
autocmd FileType python setlocal colorcolumn=80
let g:python_highlight_all = 1

" ignore some flak8 rules
let g:ale_python_flake8_args = '--ignore E402,E501'

"********** Go
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

" \n and \p for quickfix list navigation \q to close it
autocmd FileType go map <leader>n :cnext<CR>
autocmd FileType go map <leader>p :cprevious<CR>
autocmd FileType go nnoremap <leader>q :cclose<CR>

" \r run
" \b build
" \l lint
" \t test
" \c coverage
" \i info
" \e rename
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>c  <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>i <Plug>(go-info)
autocmd FileType go nmap <leader>e <Plug>(go-rename)

let g:deoplete#sources#go#gocode_binary = '$GOPATH/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = '~/.cache/deoplete/go/$GOOS_$GOARCH'
let g:go_addtags_transform = 'camelcase'

let g:go_metalinter_autosave = 1
"let g:deoplete#sources#go#pointer = 1
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_auto_type_info = 0
let g:go_snippet_case_type = "camelcase"

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
autocmd FileType javascript setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
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
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
noremap <silent> <leader>f :Find <CR>
"}}}

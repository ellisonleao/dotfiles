"" Plug Load
"*****************************************************************************
"{{{

" auto install plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'chriskempson/base16-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'janko-m/vim-test'
Plug 'kristijanhusak/vim-carbon-now-sh', {'on': 'CarbonNowSh'}

call plug#end()

"}}}


"*****************************************************************************
"                                Basic Setup
"*****************************************************************************
"{{{
" Fix backspace indent
set backspace=indent,eol,start

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

" " Tab completion
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

" some writing concerns
set autoindent smartindent

" neovim python modules
let g:python3_host_prog=$HOME.'/.pyenv/versions/3/bin/python'
let g:python_host_prog=$HOME.'/.pyenv/versions/2/bin/python'
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
colorscheme base16-material-darker

" let the colors begin
syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" color column 100 by default
set cc=100

" if hidden not set, TextEdit might fail.
set hidden

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" airline
let g:airline_theme = 'base16'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#show_splits = 1

let g:airline_section_a = airline#section#create_left(['mode'])
let g:airline_section_y = airline#section#create_right(['linenr', '%3v'])
let g:airline_section_z = '%{strftime("%d/%m/%Y %H:%M")}'

" Configure ALE.
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'javascript': ['prettier'],
    \'bash': ['shfmt'],
    \'python': ['black']
    \}
let g:ale_linters = {
	\ 'javascript': ['eslint'],
	\ 'python': ['pyls'],
	\ 'bash': ['bash-language-server']
	\}

nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>

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

" file format always unix
" set fileformat=unix

" ************* Go specific settings
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

let g:go_addtags_transform = 'camelcase'
let g:go_metalinter_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_auto_type_info = 0
let g:go_snippet_case_type = "camelcase"

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


" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

"}}}

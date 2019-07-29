"*****************************************************************************
"{{{

" auto install plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source "$HOME/.config/nvim/init.vim"
endif

call plug#begin('~/.vim/plugged')

" Code languages
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'sheerun/vim-polyglot'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" snippets, keyboard helpers
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" testing
Plug 'janko-m/vim-test', {'on': ['TestNearest', 'TestLast', 'TestSuite']}

" linter , lsp completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'w0rp/ale'

" visual plugins
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'critiqjo/vim-bufferline'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'kristijanhusak/vim-carbon-now-sh', {'on': 'CarbonNowSh'}
Plug 'junegunn/goyo.vim', {'for': 'markdown'}

call plug#end()

"}}}


"*****************************************************************************
"                                Basic Setup
"*****************************************************************************
"{{{

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
let base16colorspace=256

" This must happen before the syntax system is enabled
set mouse-=a
colorscheme base16-default-dark

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

" lower updatetime refresh
set updatetime=100

" always show tabline
set showtabline=2

" Lighline
let g:lightline = {
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'gitbranch', 'readonly', 'modified' ]
  \   ],
  \   'right': [['lineinfo'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']],
  \ },
  \ 'tabline': {'left': [['buffers']]},
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \   'linter_warnings': 'LightlineLinterWarnings',
  \   'linter_errors': 'LightlineLinterErrors',
  \   'linter_ok': 'LightlineLinterOK',
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel',
  \   'readonly': 'error',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'left',
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ }
\ }

augroup LightLineOnALE
  autocmd!
  autocmd User ALEFixPre   call lightline#update()
  autocmd User ALEFixPost  call lightline#update()
  autocmd User ALELintPre  call lightline#update()
  autocmd User ALELintPost call lightline#update()
augroup end

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

" Deoplete
let g:deoplete#enable_at_startup = 1

" ALE configs
highlight ALEWarning ctermbg=LightBlue
"let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_lint_delay = 1000
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'javascript': ['prettier'],
    \'python': ['black'],
    \'sh': ['shfmt']
    \}

let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['pyls'],
    \ 'sh': ['shellcheck']
    \}

nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
let g:ale_set_quickfix = 1

" close quickfix buffer when we close last buffer tab
au BufEnter * call MyLastWindow()
function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

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
set fileformat=unix

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
let g:go_term_mode = "vsplit"

" Set auto reload file
set autoread

" ************* Python specific settings

"" Mappings for vim-test in just python files for now
autocmd FileType python nmap <silent> <leader>t :TestNearest<CR>
autocmd FileType python nmap <silent> <leader>T :TestFile<CR>
autocmd FileType python nmap <silent> <leader>a :TestSuite<CR>
autocmd FileType python nmap <silent> <leader>l :TestLast<CR>
autocmd FileType python nmap <silent> <leader>g :TestVisit<CR>

"" Test strategies
let test#strategy = {
    \ 'nearest': 'neovim',
    \ 'file': 'neovim',
    \ 'suite': 'neovim',
    \}
let test#python#runner = 'pytest'
let test#python#pytest#options = '-W ignore -s --cov-report term-missing'

"}}}


"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"{{{

" if has('nvim')
"   tmap <C-o> <C-\><C-n>
" endif

" Split Screen
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

" Termnal nav
noremap ,z :bp<CR>
noremap ,q :bp<CR>
noremap ,x :bn<CR>
noremap ,w :bn<CR>

" split navigation
noremap ,j <C-W><C-J>
noremap ,k <C-W><C-K>
noremap ,l <C-W><C-L>
noremap ,h <C-W><C-H>

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

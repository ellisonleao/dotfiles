" auto install plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo '~/.local/share/nvim/site/autoload/plug.vim' --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source '~/.config/nvim/init.vim'
endif

call plug#begin('~/.vim/plugged')

" Code languages
Plug 'sheerun/vim-polyglot'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" snippets, keyboard helpers
Plug 'tpope/vim-commentary'
Plug 'honza/vim-snippets'
Plug 'AndrewRadev/splitjoin.vim'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" testing
Plug 'janko-m/vim-test', {'on': ['TestNearest', 'TestLast', 'TestSuite', 'TestVisit', 'TestFile']}

" linter , lsp completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" visual plugins
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'critiqjo/vim-bufferline'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'kristijanhusak/vim-carbon-now-sh', {'on': 'CarbonNowSh'}
Plug 'junegunn/goyo.vim', {'for': 'markdown'}

call plug#end()




"*****************************************************************************
"                                Basic Setup
"*****************************************************************************


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
let g:python3_host_prog='~/.pyenv/versions/3.7.4/bin/python'
let g:python_host_prog='~/.pyenv/versions/2.7.15/bin/python'



"*****************************************************************************
"                              Visual Settigns
"*****************************************************************************

" colorscheme, fonts, menus and etc
let base16colorspace=256
set termguicolors

" This must happen before the syntax system is enabled
set mouse-=a
colorscheme base16-seti

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
set noshowmode

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

let g:lightline = {
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'gitbranch', 'readonly', 'modified' ]
  \   ],
  \   'right': [['lineinfo'], ['cocstatus', 'currentfunction']],
  \ },
  \ 'tabline': {'left': [['buffers']]},
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel',
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction'
  \ }
\ }




"*****************************************************************************
"                      Autocmd and Syntax Specific Rules
"*****************************************************************************


" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" file format always unix
set fileformat=unix

" Set auto reload file
set autoread


"" Test strategies
let test#strategy = {
    \ 'nearest': 'neovim',
    \ 'file': 'neovim',
    \ 'suite': 'neovim',
    \}
let test#python#runner = 'pytest'
let test#python#pytest#options = '-W ignore -s --cov-report term-missing'

" clear netrwhist file upon close
function! ClearNetrwhistFile() abort
    let l:path = $HOME."/.config/nvim/.netrwhist"
    if filereadable(l:path)
        call delete(l:path)
    endif
endfunction
au VimLeave * call ClearNetrwhistFile()

"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"
"" Mappings for vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Golang
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')


" Coc Mappings

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `\n` and `\p` to navigate diagnostics
nmap <silent> <leader>p <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>n <Plug>(coc-diagnostic-next)

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

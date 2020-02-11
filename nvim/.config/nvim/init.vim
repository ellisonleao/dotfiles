scriptencoding utf-8
so ~/.config/nvim/plugins.vim

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
set completeopt=menuone,noinsert,noselect,preview

" no swp/bkp files
set nobackup
set nowritebackup
set noswapfile

" some writing concerns
set autoindent smartindent

" neovim python modules
let g:python3_host_prog='~/.pyenv/versions/3.8.0/bin/python'
let g:python_host_prog='~/.pyenv/versions/2.7.16/bin/python'

" vint: -ProhibitAutocmdWithNoGroup
autocmd BufWritePre * %s/\s\+$//e

" Coc.nvim settings and mappings
so ~/.config/nvim/coc.vim


"*****************************************************************************
"                              Visual Settings
"*****************************************************************************

" colorscheme, fonts, menus and etc
let base16colorspace=256
set termguicolors

" This must happen before the syntax system is enabled
set mouse-=a
colorscheme base16-seti

" let the colors begin
syntax on

" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
" vint: -ProhibitAutocmdWithNoGroup
autocmd BufEnter * :syntax sync fromstart

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" color column 100 by default
set colorcolumn=100

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
source ~/.config/nvim/lightline.vim

" vim-test confs and mappings
let test#strategy = 'neovim'
let test#java#runner = 'gradletest'
let test#java#gradletest#executable = 'gradle test -i'
let test#go#gotest#executable = 'gotest -v'

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

if has('nvim')
    tmap <C-o> <C-\><C-n>
endif

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
endif

" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Set auto reload file
set autoread

" clear netrwhist file upon close
function! ClearNetrwhistFile() abort
    let l:path = expand('~/.config/nvim/.netrwhist')
    if filereadable(l:path)
        call delete(l:path)
    endif
endfunction
autocmd VimLeave * call ClearNetrwhistFile()


" ***************** PYTHON
let test#python#runner = 'pytest'
let test#python#pytest#options = '-W ignore -s --cov-report term-missing'

" ***************** GOLANG
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

augroup go
  autocmd!

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:polyglot_disabled = ['go']

" Ale configs
let g:ale_sign_warning = '►'
let g:ale_sign_error = '►'
let g:ale_linters = {
            \ 'vim': ['vint'],
            \ 'sh': ['shellcheck'],
            \}

nmap <silent> <leader>[ <Plug>(ale_next_wrap)
nmap <silent> <leader>] <Plug>(ale_previous_wrap)


"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"
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
noremap ,d :bd!<CR>

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

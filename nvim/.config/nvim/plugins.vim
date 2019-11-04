" auto install plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    " vint: -ProhibitAutocmdWithNoGroup
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Code languages
Plug 'sheerun/vim-polyglot'
Plug 'sebdah/vim-delve', {'for': 'go'}

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
Plug 'junegunn/vader.vim', {'for': 'vim'}
Plug 'janko-m/vim-test', {'on': ['TestNearest', 'TestLast', 'TestSuite', 'TestVisit', 'TestFile']}
Plug 'tpope/vim-dispatch', {'on': ['TestNearest', 'TestLast', 'TestSuite', 'TestVisit', 'TestFile']}

" linter , lsp completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'

" visual plugins
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'critiqjo/vim-bufferline'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'kristijanhusak/vim-carbon-now-sh', {'on': 'CarbonNowSh'}
Plug 'junegunn/goyo.vim', {'for': 'markdown'}

call plug#end()

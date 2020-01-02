scriptencoding utf-8
" Coc configs and mappings

" extensions
let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-prettier',
            \ 'coc-yaml',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-vimlsp',
            \ 'coc-snippets',
            \ 'coc-tsserver',
            \ 'coc-python',
            \ 'coc-go',
            \]

" Coc config (thumbs up to not have to use that coc-settings.json file)
let g:coc_user_config = {
            \ 'coc': {
            \     'preferences': {
            \         'formatOnSaveFiletypes': ['javascript', 'javascriptreact', 'scala', 'sh', 'java', 'python']
            \     }
            \ },
            \ 'diagnostic':  {
            \     'errorSign': 'x',
            \     'warningSign': '!',
            \     'infoSign': 'i',
            \     'hintSign': '?'
            \ },
            \ 'languageserver': {
            \     'dockerfile': {
            \         'command': 'docker-langserver',
            \         'filetypes': ['dockerfile'],
            \         'args': ['--stdio']
            \     },
            \     'bash': {
            \         'command': 'bash-language-server',
            \         'filetypes': ['sh'],
            \         'args': ['start'],
            \         'ignoredRootPaths': ['~'],
            \     },
            \ },
            \ 'python': {
            \     'venvPath': expand('~/.virtualenvs'),
            \     'formatting': {
            \         'provider': 'black',
            \         'blackPath': expand('~/.pyenv/shims/black'),
            \         'blackArgs': ['--line-length=100'],
            \     },
            \     'linting': {
            \         'pylintEnabled': 0,
            \         'flake8Enabled': 1,
            \         'flake8Args': ['--append-config='.expand('~/.config/flake8')]
            \     },
            \ },
            \ 'tsserver': {
            \     'npm': expand('~/.nvm/versions/node/v10.16.3/bin/npm'),
            \ },
            \ 'html': {
            \     'format': {
            \         'enable': 1,
            \     },
            \     'enable': 1
            \ },
            \ 'java': {
            \     'format': {
            \         'enabled': 1,
            \     },
            \ },
            \}


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
" vint: -ProhibitAutocmdWithNoGroup
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

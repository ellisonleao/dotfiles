" Lightline configs

" dont show default modes
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
            \   'right': [['lineinfo'], ['coc_error'], ['coc_warning'], ['coc_hint'], ['coc_info'], ['currentfunction']],
            \ },
            \ 'tabline': {'left': [['buffers']]},
            \ 'component_expand': {
            \   'buffers': 'lightline#bufferline#buffers',
            \   'coc_error'        : 'LightlineCocErrors',
            \   'coc_warning'      : 'LightlineCocWarnings',
            \   'coc_info'         : 'LightlineCocInfos',
            \   'coc_hint'         : 'LightlineCocHints',
            \   'coc_fix'          : 'LightlineCocFixes',
            \ },
            \ 'component_type': {
            \   'buffers'          : 'tabsel',
            \   'coc_error'        : 'error',
            \   'coc_warning'      : 'warning',
            \   'coc_info'         : 'warning',
            \   'coc_hint'         : 'middle',
            \   'coc_fix'          : 'middle',
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \   'currentfunction': 'CocCurrentFunction'
            \ }
            \ }

function! s:lightline_coc_diagnostic(kind, sign) abort
    if !get(g:, 'coc_enabled', 0)
        return ''
    endif
    let c = get(b:, 'coc_diagnostic_info', 0)
    if empty(c) || get(c, a:kind, 0) == 0
        return ''
    endif
    try
        let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
    catch
        let s = '!'
    endtry
    return printf('%s %d', s, c[a:kind])
endfunction

function! LightlineCocErrors() abort
    return s:lightline_coc_diagnostic('error', 'error')
endfunction

function! LightlineCocWarnings() abort
    return s:lightline_coc_diagnostic('warning', 'warning')
endfunction

function! LightlineCocInfos() abort
    return s:lightline_coc_diagnostic('information', 'info')
endfunction

function! LightlineCocHints() abort
    return s:lightline_coc_diagnostic('hints', 'hint')
endfunction

autocmd User CocDiagnosticChange call lightline#update()

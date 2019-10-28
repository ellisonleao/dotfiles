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
            \     [ 'cocstatus', 'currentfunction', 'gitbranch', 'readonly', 'modified' ]
            \   ],
            \   'right': [['lineinfo'], ['coc_error'], ['coc_warning'], ['coc_hint'],['coc_info'], ['coc_ok']],
            \ },
            \ 'tabline': {'left': [['buffers']]},
            \ 'component_expand': {
            \   'buffers': 'lightline#bufferline#buffers',
            \   'coc_error'        : 'LightlineCocErrors',
            \   'coc_warning'      : 'LightlineCocWarnings',
            \   'coc_info'         : 'LightlineCocInfos',
            \   'coc_hint'         : 'LightlineCocHints',
            \   'coc_ok'           : 'LightlineCocOk',
            \ },
            \ 'component_type': {
            \   'buffers'          : 'tabsel',
            \   'coc_error'        : 'error',
            \   'coc_warning'      : 'warning',
            \   'coc_info'         : 'warning',
            \   'coc_hint'         : 'middle',
            \   'coc_ok'           : 'left',
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \   'cocstatus': 'coc#status',
            \   'currentfunction': 'CocCurrentFunction'
            \ }
            \ }

function! s:lightline_show_diagnostic(kind, total) abort
    try
        let s = g:coc_user_config['diagnostic'][a:kind . 'Sign']
    catch
        let s = '!'
    endtry
    return printf('%s %d ', s, a:total)
endfunction

function! LightlineCocErrors() abort
    let l:total_errors = s:total_coc_diagnostics('error') + s:total_ale_errors()
    if l:total_errors == 0
        return ''
    endif
    return s:lightline_show_diagnostic('error', l:total_errors)
endfunction

function! LightlineCocWarnings() abort
    let l:total_warnings = s:total_coc_diagnostics('warning') + s:total_ale_warnings()
    if l:total_warnings == 0
        return ''
    endif
    return s:lightline_show_diagnostic('warning', l:total_warnings)
endfunction

function! LightlineCocInfos() abort
    if s:total_coc_diagnostics('info') == 0
        return ''
    endif
    return s:lightline_show_diagnostic('info', s:total_coc_diagnostics('info'))
endfunction

function! LightlineCocHints() abort
    if s:total_coc_diagnostics('hint') == 0
        return ''
    endif
    return s:lightline_show_diagnostic('hint', s:total_coc_diagnostics('hint'))
endfunction

function! LightlineCocOk() abort
    let l:ale_counts = ale#statusline#Count(bufnr(''))
    let l:total_coc_errors = s:total_coc_diagnostics('error') + s:total_coc_diagnostics('warning')
    let l:total_ale_errors = l:ale_counts.total

    if l:total_coc_errors + l:total_ale_errors == 0
        return printf("OK")
    endif

    return ''
endfunction

" Coc functions
function! s:total_coc_diagnostics(kind) abort
    if !get(g:, 'coc_enabled', 0)
        return 0
    endif
    let c = get(b:, 'coc_diagnostic_info', 0)
    if empty(c) || get(c, a:kind, 0) == 0
        return 0
    endif
    return c[a:kind]
endfunction


" Ale functions
function! s:total_ale_errors() abort
    if !AleLinted()
        return 0
    endif
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts.error + l:counts.style_error
endfunction

function! s:total_ale_warnings() abort
    if !AleLinted()
        return 0
    endif
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts.total - s:total_ale_errors()
endfunction

function! AleLinted() abort
  return get(g:, 'ale_enabled', 0) == 1
    \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
    \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction

autocmd User CocDiagnosticChange call lightline#update()
autocmd User ALEJobStarted call lightline#update()
autocmd User ALELintPost call lightline#update()
autocmd User ALEFixPost call lightline#update()

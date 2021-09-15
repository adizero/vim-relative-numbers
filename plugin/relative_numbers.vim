" ============================================================================
" File:        relative_numbers.vim
" Description: Toggles relative numbers display based on insert/normal mode
" Author:      Adrian Kocis <adrian.kocis@alcatel-lucent.com>
" Licence:     Vim licence
" Website:
" Version:     1.0
" Note:
" ============================================================================
"
if &compatible || !exists('+relativenumber') || exists('g:loaded_relative_numbers')
    finish
endif
let g:loaded_relative_numbers = 1

let g:relative_numbers_enabled = 0

function! s:is_relative_number_allowed() abort
    if !&number
        " skips buffers that never had numbers turned on
        return v:false
    endif
	" if &filetype =~# 'qf'
        " " skips for quickfix/location buffers
        " return v:false
	" endif
	return v:true
endfunction

function! s:set(value) abort
    if !s:is_relative_number_allowed()
        return
    endif
    if a:value
        set relativenumber
    else
        set norelativenumber
    endif
endfunction

function! s:reset() abort
    if !s:is_relative_number_allowed()
        return
    endif
    let l:mode = mode()
    if l:mode !~# 'i'
        set relativenumber
    else
        set norelativenumber
    endif
endfunction

function! s:relative_numbers_enable()
    if g:relative_numbers_enabled
        return
    endif
    let g:relative_numbers_enabled = 1
    call s:reset()
    augroup numbers
        autocmd!
        autocmd InsertEnter * call s:set(v:false)
        autocmd InsertLeave * call s:set(v:true)
        autocmd WinEnter * call s:reset()
        autocmd WinLeave * call s:reset()
    augroup END
endfunc

function! s:relative_numbers_disable()
    if !g:relative_numbers_enabled
        return
    endif
    let g:relative_numbers_enabled = 0
    autocmd! numbers
endfunc

function! s:relative_numbers_toggle()
    if (!g:relative_numbers_enabled)
        call s:relative_numbers_enable()
    else
        call s:relative_numbers_disable()
    endif
endfunc

command! -nargs=0 RelativeNumbersEnable call s:relative_numbers_enable()
command! -nargs=0 RelativeNumbersDisable call s:relative_numbers_disable()
command! -nargs=0 RelativeNumbersToggle call s:relative_numbers_toggle()

call s:relative_numbers_enable()

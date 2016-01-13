"--------------------------------------------------------------------------------
"     File Name           :     smartRename.vim
"     Created By          :     FuDesign2008<FuDesign2008@163.com>
"     Creation Date       :     [2014-01-28 12:24]
"     Last Modified       :     [2014-01-28 15:22]
"     Description         :     rename variables in a smart way.
"
"     inspired by:
"     http://stackoverflow.com/questions/597687/changing-variable-names-in-vim
"     https://gist.github.com/DelvarWorld/048616a2e3f5d1b5a9ad
"--------------------------------------------------------------------------------

if exists('g:smart_rename_loaded')
    finish
endif

let g:smart_rename_loaded = 1
let s:save_cpo = &cpo
set cpo&vim


" rename local variable that is search-matched
" @param {String} newName
" @param {Boolean} confirm
function! s:Rename(startLine, endLine, newName, confirm)
    let matched = @/
    let saved_cursor_pos = getpos('.')
    let range = a:startLine . ',' . a:endLine

    let cmd =  range . 's!' . matched . '!' . a:newName .'!g'
    if a:confirm
        let cmd = cmd . 'c'
    endif
    exec cmd

    "to highlight the new name
    let @/ = '\V\<' . escape(a:newName, '\') . '\>'
    " set cursor to the old position
    call setpos('.', saved_cursor_pos)

    echomsg 'Line <' . range . '>: rename ' . matched . ' to ' . a:newName ' completely!'
endfunction


"with confirm
function! s:RenameWithConfirm(startLine, endLine, newName)
    call s:Rename(a:startLine, a:endLine, a:newName, 1)
endfunction

"without confirm
function! s:RenameWithoutConfirm(startLine, endLine, newName)
    call s:Rename(a:startLine, a:endLine, a:newName, 0)
endfunction


command! -range=% -nargs=1 Re     call s:RenameWithConfirm(<line1>, <line2>, <q-args>)
command! -range=% -nargs=1 Rename call s:RenameWithoutConfirm(<line1>, <line2>, <q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

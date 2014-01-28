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
function! s:RenameSearch(newName, confirm)
    let matched = @/
    let saved_cursor_pos = getpos('.')
    if a:confirm
        exec ':%s!' . matched .'!' . a:newName .'!gc'
    else
        exec ':%s!' . matched .'!' . a:newName .'!g'
    endif
    "to highlight the new name
    let @/ = '\V\<' . escape(a:newName, '\') . '\>'
    " set cursor to the old position
    call setpos('.', saved_cursor_pos)
    echomsg 'Rename ' . matched . ' to ' . a:newName ' completely!'
endfunction

"with confirm
function! s:Rename(newName)
    call s:RenameSearch(a:newName, 1)
endfunction

"without confirm
function! s:RenameWithoutConfirm(newName)
    call s:RenameSearch(a:newName, 0)
endfunction

command! -nargs=1 Re call s:Rename(<f-args>)
command! -nargs=1 Rename call s:RenameWithoutConfirm(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

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
" let s:save_cpo = &cpo
let s:save_cpo = &cpoptions
set cpoptions&vim


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


" taken from https://raw.githubusercontent.com/vim-scripts/Rename2/master/plugin/Rename2.vim
function! s:RenameFile(name, bang)
    let l:curfile = expand('%:p')
    let l:curfilepath = expand('%:p:h')
    let l:newname = l:curfilepath . '/' . a:name
    let v:errmsg = ''
    silent! exe 'saveas' . a:bang . ' ' . l:newname
    if v:errmsg =~# '^$\|^E329'
        if expand('%:p') !=# l:curfile && filewritable(expand('%:p'))
            silent exe 'bwipe! ' . l:curfile
            if delete(l:curfile)
                echoerr 'Could not delete ' . l:curfile
            endif
        endif
    else
        echoerr v:errmsg
    endif
endfunction

function! s:RenameExtension(extension, bang)
    let fileName = expand('%:t:r')
    let newFileName = fileName . '.' . a:extension
    call s:RenameFile(newFileName, a:bang)
endfunction


command! -range=% -nargs=1 Re      :call s:RenameWithConfirm(<line1>, <line2>, <q-args>)
command! -range=% -nargs=1 Rename  :call s:RenameWithoutConfirm(<line1>, <line2>, <q-args>)

" :RenameFile[!] {newname}
command! -nargs=1 -complete=file -bang RenameFile :call s:RenameFile("<args>", "<bang>")

" :RenameExt[!] {newextension}
command! -nargs=1 -complete=filetype -bang RenameExt :call s:RenameExtension("<args>", "<bang>")

" let &cpo = s:save_cpo
let &cpoptions = s:save_cpo
unlet s:save_cpo

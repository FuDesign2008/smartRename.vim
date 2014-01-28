"--------------------------------------------------------------------------------
"     File Name           :     smartRename.vim
"     Created By          :     FuDesign2008<FuDesign2008@163.com>
"     Creation Date       :     [2014-01-28 12:24]
"     Last Modified       :     [2014-01-28 13:12]
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
function! s:RenameSearch(newName)
    let save_z = @z
    let @z = a:newName
    " Locally (local to block) rename a variable
    exec 'mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x'
    let @z = save_z
    "to highlight the new name
    let @/ = '\<' + newName + '\>'
endfunction


command! -nargs=1 Rename call s:RenameSearch(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

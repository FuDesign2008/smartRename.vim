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


"return 0 or 1
function! s:RenameFile(filePath, newFilePath, bang)
    if executable('mv') == 0
        echoerr 'Need the suppport of `mv` shell command'
        return 0
    endif

    if filereadable(a:filePath) == 0
        echoerr 'The file is not readable: ' . a:filePath
        return 0
    endif
    let prefix = a:bang ? 'mv -fv' : 'mv -nv'
    let command = prefix . ' "' . a:filePath . '" "' . a:newFilePath . '"'
    try
        call system(command)
    catch
        return 0
    endtry

    return 1
endfunction

function! s:RelativePathOfCwd(filePath)
    let cwd = getcwd() . '/'
    if stridx(a:filePath, cwd) == 0
        let len = strlen(cwd)
        let relative = strpart(a:filePath, len)
        return relative
    endif
    return a:filePath
endfunction

function! s:RenameCurrentFile(name, bang)
    let curfile = expand('%:p')
    let curfilepath = expand('%:p:h')
    let filePathNew = curfilepath . '/' . a:name
    let isRenameOk = s:RenameFile(curfile, filePathNew, a:bang)
    if isRenameOk
        let newPath = s:RelativePathOfCwd(filePathNew)
        execute ':e ' . newPath
    else
        echoerr 'Failed to rename current file -> ' . a:name
    endif
endfunction

function! s:RenameName(name, bang)
    let extension = expand('%:e')
    let newFileName = a:name . '.' . extension
    call s:RenameCurrentFile(newFileName, a:bang)
endfunction

function! s:RenameExtension(extension, bang)
    let fileName = expand('%:t:r')
    let newFileName = fileName . '.' . a:extension
    call s:RenameCurrentFile(newFileName, a:bang)
endfunction

function! s:ListFiles(path)
    let files = split(globpath(a:path, '**'), '\n')
    return files
endfunction

function! s:ListFilesOfCurrentFile()
    let path = expand('%:h')
    let files = s:ListFiles(path)
    let extensionList = []
    let nameList = []
    for item in files
        let extension = fnamemodify(item, ':e')
        let name = fnamemodify(item, ':t:r')
        if strlen(extension) && index(extensionList, extension) == -1
            call add(extensionList, extension)
        endif
        if strlen(name) && index(nameList, name) == -1
            call add(nameList, name)
        endif
    endfor
    return {
        \ 'extensions': extensionList,
        \ 'names': nameList
        \ }
endfunction


function RenameNameCompleter(A, L, P)
    let result = s:ListFilesOfCurrentFile()
    let names = get(result, 'names', [])
    let hint = trim(a:A)
    if strlen(hint) == 0
        call sort(names)
        return names
    endif
    let matchList = []
    for item in names
        if stridx(item, hint) > -1
            call add(matchList, item)
        endif
    endfor
    call sort(matchList)
    return matchList
endfunction

function RenameExtCompleter(A, L, P)
    let result = s:ListFilesOfCurrentFile()
    let extensions = get(result, 'extensions', [])
    let hint = trim(a:A)
    if strlen(hint) == 0
        call sort(extensions)
        return extensions
    endif
    let matchList = []
    for item in extensions
        if stridx(item, hint) > -1
            call add(matchList, item)
        endif
    endfor
    call sort(matchList)
    return matchList
endfunction

function RenameFileCompleter(A, L, P)
    let result = s:ListFilesOfCurrentFile()

    if stridx(a:A, '.') > -1
        let indexOfDot = strridx(a:A, '.')
        let hint = strpart(a:A, indexOfDot + 1)
        let extensionList = RenameExtCompleter(hint, a:L, a:P)
        return extensionList
    else
        let names = RenameNameCompleter(a:A, a:L, a:P)
        return names
    endif
endfunction


command! -range=% -nargs=1 Re      :call s:RenameWithConfirm(<line1>, <line2>, <q-args>)
command! -range=% -nargs=1 Rename  :call s:RenameWithoutConfirm(<line1>, <line2>, <q-args>)

" rename file with name and extension
" :RenameFile[!] {new-name-and-extension}
command! -nargs=1 -complete=customlist,RenameFileCompleter -bang RenameFile :call s:RenameCurrentFile("<args>", "<bang>")


" rename file name without extension
" :RenameName[!] {new-name}
command! -nargs=1 -complete=customlist,RenameNameCompleter -bang RenameName :call s:RenameName("<args>", "<bang>")


" rename file extension only
" :RenameExt[!] {new-extension}
command! -nargs=1 -complete=customlist,RenameExtCompleter -bang RenameExt :call s:RenameExtension("<args>", "<bang>")

" let &cpo = s:save_cpo
let &cpoptions = s:save_cpo
unlet s:save_cpo

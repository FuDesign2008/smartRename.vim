# smartRename.vim

Rename variables/file name in a smart way

## Usage

1. `:Re newName` Rename the search word which is highlighting to `newName` with confirm
1. `:Rename newName` Rename the search word to `newName` without confirm
1. `:RenameFile fileName` Rename current file
1. `:RenameFile! fileName` Rename current file to `fileName` with override
1. `:RenameExt extension` Rename the extension of current file
1. `:RenameExt! extension` Rename the extension of current file with override

## Tips

1. normal use
    - press `*` to search the word under cursor
    - `:Re newName` to replace
1. use with range
    - press `*` to search the word under cursor
    - `:.,+10Re newName` to replace
1. use in visual mode
    - press `*` to search the word under cursor
    - selecting texts in visual mode, eg. `vi}`
    - `:'<,'>Re newName` to replace

## change log

-   2019-04-16
    -   Add `:RenameFile`, `:RenameExt`
-   2016-01-13
    -   add range support

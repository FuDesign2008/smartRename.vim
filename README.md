smartRename.vim
===============

Rename vars in a smart way

## Usage

1. `:Re newName` Rename the search word which is highlighting to `newName` with confirm
1. `:Rename newName` Rename the search word to `newName` without confirm

## Tips

1. normal use
    * press `*` to search the word under cursor
    * `:Re newName` to replace
1. use with range
    * press `*` to search the word under cursor
    * `:.,+10Re newName` to replace
1. use in visual mode
    * press `*` to search the word under cursor
    * selecting texts in visual mode, eg. `vi}`
    * `:'<,'>Re newName` to replace




## change log

* 2016-01-13
    - add range support


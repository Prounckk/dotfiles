let g:undotree_WindowLayout= 2
let g:undotree_SplitWidth= 50
let g:undotree_SetFocusWhenToggle= 1

nnoremap <silent> <leader>u :silent! packadd undotree<cr> <BAR> :UndotreeToggle<CR>

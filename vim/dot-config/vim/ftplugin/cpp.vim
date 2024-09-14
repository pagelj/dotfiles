let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80,".join(range(400,999),",")
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
setlocal foldmethod=indent
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4

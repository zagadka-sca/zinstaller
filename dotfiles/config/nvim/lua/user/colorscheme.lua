vim.cmd [[
try
  let g:onedark_style = 'darker'
  colorscheme onedark
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

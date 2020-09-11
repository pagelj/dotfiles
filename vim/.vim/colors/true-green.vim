"" thanks to darkgreendarkgreen from themebow for a running start!
"" http://themebow.com/theme/313
"" find me online at:
"" https://github.com/ryanpcmcquen/true-monochrome_vim

"" clear out any previous highlighting
hi clear
"" if vim is v5.8 or greater, reset syntax
if version > 580
  if exists("syntax_on")
    syntax reset
  endif
endif

"" give it a name and set the background
let colors_name="true-green"
set background=dark

""
"" now, on to the good stuff!
""

"" black fg w/green bg
hi Cursor          guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi IncSearch       guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=ITALIC       cterm=NONE
hi Search          guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=ITALIC       cterm=NONE
hi Visual          guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=ITALIC       cterm=NONE
hi VisualNOS       guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=ITALIC       cterm=NONE
hi SpellBad        guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi SpellCap        guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi SpellLocal      guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi SpellRare       guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi DiffAdd         guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi DiffChange      guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE
hi DiffDelete      guifg=#00FF00    guibg=#FFFFFF    ctermfg=black    ctermbg=green    gui=NONE         cterm=NONE

"" darkgreen fg w/green bg
hi CursorColumn    guifg=#006400    guibg=#FFFFFF    ctermfg=darkgreen     ctermbg=green    gui=NONE         cterm=NONE
hi CursorLine      guifg=#006400    guibg=#FFFFFF    ctermfg=darkgreen     ctermbg=green    gui=NONE         cterm=NONE

"" darkgreen fg w/black bg
hi Comment         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=ITALIC       cterm=NONE
hi Directory       guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Error           guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Folded          guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Function        guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi Identifier      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Ignore          guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Label           guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi LineNr          guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi MatchParen      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi ModeMsg         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi MoreMsg         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi NonText         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Normal          guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi PmenuSbar       guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi PmenuSel        guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=ITALIC       cterm=NONE
hi PmenuThumb      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi PreProc         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi Special         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi SpecialKey      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=ITALIC       cterm=NONE
hi Statement       guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi StatusLine      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi StatusLineNC    guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=ITALIC       cterm=NONE
hi StorageClass    guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi Structure       guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi TabLine         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi TabLineFill     guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi TabLineSel      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi Title           guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi Todo            guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi Todo            guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=UNDERLINE    cterm=UNDERLINE
hi Type            guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi TypeDef         guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi Underlined      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=UNDERLINE    cterm=UNDERLINE
hi VertSplit       guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi WarningMsg      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi WildMenu        guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE
hi cucumberTags    guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi htmlTagN        guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=BOLD         cterm=BOLD
hi rubySymbol      guifg=#006400    guibg=#00FF00    ctermfg=darkgreen     ctermbg=black    gui=NONE         cterm=NONE

"" green fg w/black bg
hi Constant        guifg=#FFFFFF    guibg=#00FF00    ctermfg=green    ctermbg=black    gui=NONE         cterm=NONE
hi Number          guifg=#FFFFFF    guibg=#00FF00    ctermfg=green    ctermbg=black    gui=NONE         cterm=NONE
hi CursorLineNr    guifg=#FFFFFF    guibg=#00FF00    ctermfg=green    ctermbg=black    gui=NONE         cterm=NONE
hi Pmenu           guifg=#FFFFFF    guibg=#00FF00    ctermfg=green    ctermbg=black    gui=BOLD         cterm=BOLD
hi String          guifg=#FFFFFF    guibg=#00FF00    ctermfg=green    ctermbg=black    gui=NONE         cterm=NONE
hi DiffText        guifg=#FFFFFF    guibg=#00FF00    ctermfg=green    ctermbg=black    gui=NONE         cterm=NONE

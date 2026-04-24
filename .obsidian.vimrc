" Enable system clipboard integration
set clipboard=unnamed

" Set tab size to 2 spaces
set tabstop=2


" Map j and k to move by visual lines rather than logical ones
nmap j gj
nmap k gk

" Map H and L to beginning/end of line
nmap H ^
nmap L $

" Move to up or down to the center of the screen
" exmap scrollUpCenter jscommand { editor.exec("goPageUp"); editor.exec("scrollCursorToCenter"); }  
" exmap scrollDownCenter jscommand { editor.exec("goPageDown"); editor.exec("scrollCursorToCenter"); }  
" nmap <C-u> :scrollUpCenter<CR>  
" nmap <C-d> :scrollDownCenter<CR>

" Switch tabs as buffers in neovim
exmap nextpane obcommand workspace:next-tab
nmap ]b :nextpane<CR>
exmap prevpane obcommand workspace:previous-tab
nmap [b :prevpane<CR>
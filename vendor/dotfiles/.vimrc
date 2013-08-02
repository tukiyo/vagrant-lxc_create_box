sy on
set nonu
set nowrapscan
set laststatus=2
set statusline=%<[%n]%m%r\ %f%=\ %l,%c%V%6P%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y
set scrolloff=5
if exists("&ambiwidth")
    set ambiwidth=double
endif
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
filetype on
colorscheme desert
se nowrap

"" auto detect encoding
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set fileformats=unix,dos,mac

"" search
set incsearch
set hlsearch

au BufRead,BufNewFile *.md :set ft=markdown

" map
map <C-c> <Esc>
map ,c :cd %:h<cr>:pwd<cr>
map ,v :vimgrep // **/*.*\|cwin<C-b><Right><Right><Right><Right><Right><Right><Right><Right><Right>
map ,f :vimgrep // %\|cwin<C-b><Right><Right><Right><Right><Right><Right><Right><Right><Right>
map ,q :q<cr>
map _ :q<cr>
map ,, :marks<cr>
map ,. :e .<cr>
map ,S :mksession! ~/session.vim<cr>
map ,L :so ~/session.vim<cr>

let MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|[/\\]tags$\|^tags$'

" indent
set autoindent
set smarttab

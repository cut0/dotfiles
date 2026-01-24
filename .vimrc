" Vim Motions

" 対応するカッコに移動
nnoremap M %
vnoremap M %

" 表示行単位での移動
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" 行頭・行末への移動
nnoremap H g0
vnoremap H g0
nnoremap L g$
vnoremap L g$

" 削除系はレジスタに入れない
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap dd "_dd
nnoremap c "_c
vnoremap c "_c

" ビジュアルモードでのコピー時に位置を保持
xnoremap y mzy`z

" Redo を U に割り当て
nnoremap U <C-r>

" Insert mode: jj で Normal mode へ
inoremap jj <Esc>

" クリップボード連携
set clipboard=unnamed,unnamedplus

" 基本設定
set number
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase

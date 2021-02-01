# Leaderf-snippet
The Right Way to Use Snippet

## Installation

```VimL
" Leaderf-snippet
Plug 'Yggdroot/LeaderF'
Plug 'skywind3000/Leaderf-snippet'

" snipmate and requirements
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" vim-snippets
Plugin 'honza/vim-snippets'
```

## Configuration

```VimL
" maps
noremap <c-\><c-\> :Leaderf snippet<cr>
inoremap <c-\><c-\> <c-\><c-o>:Leaderf snippet<cr>

" optional: preview
let g:Lf_PreviewResult = get(g:, 'Lf_PreviewResult', {})
let g:Lf_PreviewResult.snippet = 1

```

## TODO

- [x] snipmate
- [ ] ultisnip


# Leaderf-snippet
The Right Way to Use Snippet

## Installation

```VimL
" Leaderf-snippet
Plug 'Yggdroot/LeaderF'
Plug 'skywind3000/Leaderf-snippet'
```

## Configuration

```VimL
" maps
inoremap <c-x><c-j> <c-\><c-o>:Leaderf snippet<cr>

" optional: preview
let g:Lf_PreviewResult = get(g:, 'Lf_PreviewResult', {})
let g:Lf_PreviewResult.snippet = 1

```

## TODO

- [x] snipmate
- [x] ultisnips
- [x] snipmate preview
- [ ] ultisnips preview


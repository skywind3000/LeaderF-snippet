# Leaderf-snippet

This plugin takes the advantage of the well-known fuzzy finder [Leaderf](https://github.com/Yggdroot/LeaderF) to provide a new way to input snippets:

![](https://github.com/skywind3000/images/raw/master/p/snippet/snippet1.gif)

Snippet names are hard to remember, therefore, I made a Leaderf extension to help input snippets.

## Feature

- Read snippets from SnipMate or UltiSnips
- Display snippet descriptions in the fuzzy finder.
- Work in both INSERT mode and NORMAL mode.
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

## Why Leaderf ?

Because it has a NORMAL mode which allows you browser the content like a normal vim window:

![](https://github.com/skywind3000/images/raw/master/p/snippet/snippet2.gif)

## TODO

- [x] snipmate
- [x] ultisnips
- [x] snipmate preview
- [ ] ultisnips preview


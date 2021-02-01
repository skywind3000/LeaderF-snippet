"----------------------------------------------------------------------
" Query SnipMate Database
"----------------------------------------------------------------------
function! SnipMateQuery(word, exact) abort
	let matches = snipMate#GetSnippetsForWordBelowCursor(a:word, a:exact)
	let result = []
	let size = 4
	for [trigger, dict] in matches
		let body = ''
		for key in keys(dict)
			let value = dict[key]
			if type(value) == v:t_list
				if len(value) > 0
					let body = value[0]
					break
				endif
			endif
		endfor
		if body != ''
			let size = max([size, len(trigger)])
			let result += [[trigger, body]]
		endif
	endfor
	for item in result
		let t = item[0] . repeat(' ', size - len(item[0]))
		call extend(item, [t])
	endfor
	call sort(result)
	return result
endfunc


"----------------------------------------------------------------------
" Simplify Snippet Body
"----------------------------------------------------------------------
function! SnipMateDescription(body, width) abort
	let text = join(split(a:body, '\n')[:4], ' ; ')
	let text = substitute(text, '^\s*\(.\{-}\)\s*$', '\1', '')
	let text = substitute(text, '\${[^{}]*}', '...', 'g')
	let text = substitute(text, '\${[^{}]*}', '...', 'g')
	let text = substitute(text, '\s\+', ' ', 'g')
	let text = strcharpart(text, 0, a:width)
	return text
endfunc


"----------------------------------------------------------------------
" Query Snippets
"----------------------------------------------------------------------
function! UltiSnipsQuery()
	call UltiSnips#SnippetsInCurrentScope(1)
	let list = []
	let size = 4
	for [key, info] in items(g:current_ulti_dict_info)
		let desc = info.description
		if desc == ''
			let desc = '...'
		endif
		let size = max([size, len(key)])
		let list += [[key, desc]]
	endfor
	call sort(list)
	for item in list
		let t = item[0] . repeat(' ', size - len(item[0]))
		call extend(item, [t])
	endfor
	return list
endfunc


"----------------------------------------------------------------------
" internal 
"----------------------------------------------------------------------
let s:bufid = -1
let s:filetype = ''
let s:accept = ''
let s:snips = {}
let s:is_snipmate = 0
let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})


function! s:lf_snippet_source(...)
	let source = []
	let s:is_snipmate = (exists(':UltiSnipsEdit') != 2)
	if s:is_snipmate
		let matches = SnipMateQuery('', 0)
	else
		let matches = UltiSnipsQuery()
	endif
	let snips = {}
	let width = 100
	for item in matches
		let trigger = item[0]
		if trigger =~ '^\u'
			continue
		endif
		if s:is_snipmate
			let desc = SnipMateDescription(item[1], width)
		else
			let desc = item[1]
		endif
		let text = item[2] . ' ' . ' : ' . desc
		let snips[trigger] = item[1]
		let source += [text]
	endfor
	let s:snips = snips
	return source
endfunc

" echo s:lf_snippet_source()

function! s:lf_snippet_accept(line, arg)
	let pos = stridx(a:line, ':')
	if pos < 0
		return
	endif
	let name = strpart(a:line, 0, pos)
	let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
	redraw
	if name != ''
		let s:accept = name . "\<Plug>snipMateTrigger"
		if s:is_snipmate
			if mode(1) =~ 'i'
				call feedkeys(name . "\<Plug>snipMateTrigger", '!')
				" call feedkeys(name . "\<c-r>=snipMate#TriggerSnippet(1)\<cr>", '!')
			else
				call feedkeys('a' . name . "\<Plug>snipMateTrigger", '!')
			endif
		else
			if mode(1) =~ 'i'
				call feedkeys("\<right>", '!')
				" call feedkeys("" .  name . "\<m-e>", '!')
				call feedkeys(name . "\<c-r>=UltiSnips#ExpandSnippet()\<cr>", '!')
				" unsilent echom "col: ". col('.')
			else
				call feedkeys('a' . name . "\<c-r>=UltiSnips#ExpandSnippet()\<cr>", '!')
			endif
		endif
	endif
endfunc


function! s:lf_snippet_preview(orig_buf_nr, orig_cursor, line, args)
	let text = a:line
	let pos = stridx(text, ':')
	if pos < 0 
		return []
	endif
	let name = strpart(text, 0, pos)
	let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
	let body = get(s:snips, name, '')
	if body == ''
		unsilent echom "SUCK"
		return []
	endif
	if s:bufid < 0
		let s:bufid = bufadd('')
		let bid = s:bufid
		call bufload(bid)
		call setbufvar(bid, '&buflisted', 0)
		call setbufvar(bid, '&bufhidden', 'hide')
		call setbufvar(bid, '&modifiable', 1)
		call deletebufline(bid, 1, '$')
		call setbufvar(bid, '&modified', 0)
		call setbufvar(bid, 'current_syntax', '')
		call setbufvar(bid, '&filetype', '')
	endif
	let bid = s:bufid
	let textlist = split(body, '\n')
	call setbufvar(bid, '&modifiable', 1)
	call setbufline(bid, 1, textlist)
	call setbufvar(bid, '&modified', 0)
	call setbufvar(bid, '&modifiable', 0)
	return [bid, 1, '']
endfunc

function! s:lf_win_init(...)
	setlocal nonumber nowrap
endfunc

let g:Lf_Extensions.snippet = {
			\ 'source': string(function('s:lf_snippet_source'))[10:-3],
			\ 'accept': string(function('s:lf_snippet_accept'))[10:-3],
			\ 'preview': string(function('s:lf_snippet_preview'))[10:-3],
			\ 'highlights_def': {
			\     'Lf_hl_funcScope': '^\S\+',
			\ },
			\ 'after_enter': string(function('s:lf_win_init'))[10:-3],
		\ }




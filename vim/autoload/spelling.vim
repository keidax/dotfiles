" Disable spell checking on items matching a pattern.

let s:no_spell_matches = {
    \ 'Url': '\w\+:\/\/[[:alnum:]./#?&=-]\+',
    \ 'Version': 'v\d\+\(\.\d\+\)*',
    \ 'Email': '[[:alnum:]_.+]\+@\w\+\(\.\w\+\)\+',
    \ }

" A filename signified by an extension, perhaps with a leading path
" E.g. longname/foo.yml
let s:no_spell_matches['Filename'] = '[[:alnum:]_./-]\+\.[[:alnum:]]\+'

" A filename signified by a path starting with ., ~, or /
" E.g. ~/asdf or ./docs/longname/foo
" NOTE: \zs is necessary to avoid capturing too much in the group
let s:no_spell_matches['Filepath'] = '\%(^\|[^[:alnum:]]\)\zs[.~]\?/[[:alnum:]_./-]\+'

" We DON'T want to match a simple slash-separated list, because that may be
" normal English text.

" Tests
" Do match:
"   https://vim.org
"   https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source
"   moz://a
"   v1.2.3
"   v8
"   my.name@mail.example.org
"   /foo/bar
"   ~/user/bin/asdf.sh
"   ./thingasd
"   foo.yml
"   docs/foo.yml
" Don't match:
"   asdf:/asdf
"   my_name@gmailcom
"   myname@mail@com
"   foo/ymlbin
"   thiis/oor/thaat.

" If a syntax file only contains @NoSpell and never @Spell, then spell
" checking is enabled everywhere without @NoSpell. We can avoid this by
" inserting a transparent group containing @Spell within the specific groups
" we want to be spell checked. Then, we further disable spell checking based
" on matches.
function! spelling#enable_inside_groups(...) abort
    exec 'syntax match SpellEnableInsideGroup ".*" contains=@Spell contained transparent containedin=' . join(a:000, ',')
    call spelling#disable_match_inside_groups('SpellEnableInsideGroup')
endfunction

" If the syntax file uses a group for spelling, call with that group here.
" E.g. for the ruby filetype:
"   Syntax group rubyComment contains @Spell.
"   So disable_match_inside_groups('rubyComment') will disable matching
"   patterns inside all comments.
function! spelling#disable_match_inside_groups(...) abort
    let l:group_list = join(a:000, ',')

    for [_, regex] in items(s:no_spell_matches)
        exec printf(
            \ 'syntax match SpellDisableMatch "%s" contains=@NoSpell contained transparent containedin=%s',
            \ regex, group_list)
    endfor
endfunction

" If the syntax file uses a cluster for spelling, call with that cluster here.
" E.g. for the vim filetype:
"   Syntax groups vimComment and vimCommentLine contain @vimCommentGroup.
"   Syntax cluster @vimCommentGroup contains vimTodo and @Spell.
"   So disable_match_inside_clusters('vimCommentGroup') will disable matching
"   patterns inside all comments.
function! spelling#disable_match_inside_clusters(...) abort
    for [_, regex] in items(s:no_spell_matches)
        exec printf(
            \ 'syntax match SpellDisableMatch "%s" contains=@NoSpell contained transparent',
            \ regex)
    endfor

    for clust in a:000
        exec 'syntax cluster '.clust.' add=SpellDisableMatch'
    endfor
endfunction

function! spelling#disable_match_top_level() abort
    for [_, regex] in items(s:no_spell_matches)
        exec printf(
            \ 'syntax match SpellDisableTop "%s" contains=@NoSpell',
            \ regex)
    endfor
endfunction

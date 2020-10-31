" NOTE: Spell checking is turned on for individual filetypes in ftplugin files.

" Don't complain about missing capitals (doesn't work well with code)
set spellcapcheck=
" Set up 2 spelling lists. The first file is actually a symlink to en.dic, in
" Myspell/Hunspell format. The .spl file is renamed so it's picked up by Vim
" without blocking the normal English wordlist.
" TODO: this setup breaks zg mappings, may need to remap those manually.
set spellfile=$DOTDIR/vim/spell/en.utf-8.add,$DOTDIR/vim/spell/local.utf-8.add

" Notes:
" - @Spell/@NoSpell clusters don't seem to have an effect on nested groups.
" - If _only_ @NoSpell clusters are used, then all other groups will
"   implicitly be spell checked. (see :h spell-syntax)
" - contains=TOP,@Spell breaks all spell checking?

" Regenerate spell files as needed. Do custom handling instead of using
" spellsync, since the dictionary setup is not standard.
let s:dict = $DOTDIR . '/vim/spell/en'
let s:dict_spl = s:dict . '.utf-8.add.spl'

func! AddToSpellingDictionary(count)
    if a:count == 1
        silent exec 'normal! ' . a:count . 'zg'
        silent exec 'mkspell! ' . fnameescape(s:dict_spl) . ' ' .fnameescape(s:dict)
    else
        " Add the word like normal
        exec 'normal! ' . a:count . 'zg'
    endif
endfunc

" NOTE: <C-u> erases the range added with a count, which would look something
" like `:.,.+1`
nnoremap <silent> zg :<C-u>call AddToSpellingDictionary(v:count1)<CR>

if getftime(s:dict . '.dic') > getftime(s:dict_spl) ||
    \ getftime(s:dict . '.aff') > getftime(s:dict_spl)
    silent exec 'mkspell! ' . fnameescape(s:dict_spl) . ' ' .fnameescape(s:dict)
endif

let s:local_wordlist = $DOTDIR . '/vim/spell/local.utf-8.add'
if getftime(s:local_wordlist) > getftime(s:local_wordlist . '.spl')
    silent exec 'mkspell! ' . fnameescape(s:local_wordlist)
endif

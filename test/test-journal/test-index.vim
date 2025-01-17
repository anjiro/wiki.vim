source ../init.vim

let g:wiki_root = g:testroot . '/wiki-basic'
runtime plugin/wiki.vim

silent call wiki#page#open('JournalIndex')
WikiJournalIndex
call assert_equal('## January', getline(4))
call assert_equal('## October', getline(76))
call assert_equal('[[journal:2019-01-03|2019-01-03]]', getline(6))


" Test without "journal:" scheme
silent %bwipeout!
let g:wiki_journal = {'index_use_journal_scheme': 0}
unlet g:wiki_loaded
runtime plugin/wiki.vim
silent call wiki#page#open('JournalIndex')
WikiJournalIndex
call assert_equal('[[/journal/2019-01-03|2019-01-03]]', getline(6))


" Test with link extension
silent %bwipeout!
let g:wiki_link_extension = '.wiki'
unlet g:wiki_journal
unlet g:wiki_loaded
runtime plugin/wiki.vim
silent call wiki#page#open('JournalIndex')
WikiJournalIndex

call assert_equal('[[journal:2019-01-03.wiki|2019-01-03]]', getline(6))


call wiki#test#finished()

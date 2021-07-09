-- TODO: we cannot store lua functions in vimscript variables. Leave it full vimscript for now
vim.cmd [[
" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! StartifyGitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! StartifyGitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [ { 'type': 'files',     'header': ['   MRU'] }, { 'type': 'dir',       'header': ['   MRU '. getcwd()] }, { 'type': 'sessions',  'header': ['   Sessions'] }, { 'type': 'bookmarks', 'header': ['   Bookmarks'] }, { 'type': function('StartifyGitModified'),  'header': ['   git modified'] }, { 'type': function('StartifyGitUntracked'), 'header': ['   git untracked'] }, { 'type': 'commands',  'header': ['   Commands'] }, ]
]]

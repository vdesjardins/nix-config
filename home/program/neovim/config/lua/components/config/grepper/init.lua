vim.cmd [[
aug Grepper
    au!
    au User Grepper call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': histget('/')}}}) | botright copen
aug END
]]

vim.g.grepper = { open = 0, quickfix = 1, searchreg = 1, highlight = 0 }

require("telescope").load_extension("harpoon")

local wk = require("which-key")
wk.register({
    m = {
        name = "harpoon (mark)",
        m = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "add-file" },
        q = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "quick-menu" },
        n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "next" },
        p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "previous" },
    },
}, { prefix = "<leader>" })

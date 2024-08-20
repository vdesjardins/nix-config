require("gp").setup({
    default_chat_agent = "ChatOllamaLlama3.1-8B",
    default_command_agent = "ChatOllamaLlama3.1-8B",

    providers = {
        openai = {
            endpoint = "https://api.openai.com/v1/chat/completions",
            secret = os.getenv("OPENAI_API_KEY"),
        },

        copilot = {
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
                "bash",
                "-c",
                "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
        },

        pplx = {
            endpoint = "https://api.perplexity.ai/chat/completions",
            secret = os.getenv("PPLX_API_KEY"),
        },

        ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
        },

        googleai = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
            secret = os.getenv("GOOGLEAI_API_KEY"),
        },

        anthropic = {
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("ANTHROPIC_API_KEY"),
        },
    },

    hooks = {
        UnitTests = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by writing table driven unit tests for the code above."
            local agent = gp.get_command_agent()
            gp.Prompt(params, gp.Target.vnew, agent, template)
        end,

        Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, agent, template)
        end,

        CodeReview = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please analyze for code smells and suggest improvements."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
        end,

        Translator = function(gp, params)
            local chat_system_prompt =
                "You are a Translator, please translate between English and French."
            gp.cmd.ChatNew(params, chat_system_prompt)
        end,
    },
})

require("which-key").add({
    -- VISUAL mode mappings
    -- s, x, v modes are handled the same way by which_key
    {
        mode = { "v" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
        { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
        { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split" },
        { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)" },
        { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" },
        { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew" },
        { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew" },
        { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup" },
        { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" },
        { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew" },
        { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" },
        { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" },
        { "<C-g>w", group = "Whisper" },
        { "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append" },
        { "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend" },
        { "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New" },
        { "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        { "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite" },
        { "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        { "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper" },
        { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext" },
    },

    -- NORMAL mode mappings
    {
        mode = { "n" },
        nowait = true,
        remap = false,
        { "<leader>c", group = "Chat", desc = "AI Chat" },
        { "<leader>c<C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
        { "<leader>c<C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
        { "<leader>c<C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
        { "<leader>ca", "<cmd>GpAppend<cr>", desc = "Append (after)" },
        { "<leader>cb", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
        { "<leader>cc", "<cmd>GpChatNew<cr>", desc = "New Chat" },
        { "<leader>cf", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
        { "<leader>cg", group = "generate into new .." },
        { "<leader>cge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
        { "<leader>cgn", "<cmd>GpNew<cr>", desc = "GpNew" },
        { "<leader>cgp", "<cmd>GpPopup<cr>", desc = "Popup" },
        { "<leader>cgt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
        { "<leader>cgv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
        { "<leader>cn", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<leader>cr", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<leader>cs", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<leader>ct", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
        { "<leader>cw", group = "Whisper" },
        { "<leader>cwa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
        { "<leader>cwb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
        { "<leader>cwe", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        { "<leader>cwn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
        { "<leader>cwp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        { "<leader>cwr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
        { "<leader>cwt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        { "<leader>cwv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        { "<leader>cww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
        { "<leader>cx", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
    },

    -- INSERT mode mappings
    {
        mode = { "i" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
        { "<C-g>w", group = "Whisper" },
        { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
        { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
        { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
        { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
        { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
    },
})

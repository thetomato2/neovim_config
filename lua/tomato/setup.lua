require("tomato.cmp")

-- set errorformat+=\\\ %#%f(%l\\\,%c):\ %m
-- set errorformat+=\\\ %#%f(%l\\,%c): %m
vim.api.nvim_create_user_command("MsvcErrFmt", "set errorformat+=\\\\\\ %#%f(%l\\\\\\,%c):\\ %m", {})

-- require("feline").setup()

config = function()
    require("Comment").setup()
end

-- require("colorizer").setup()

require("nvim-treesitter.install").compilers = { "clang", "gcc" }


require("nvim-treesitter.configs").setup({
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = {
            "#f56b3d",
            "#a35aaa",
            "#8297c0",
            "#ffdc7a",
        },
    },
})

require("todo-comments").setup({
    signs = false, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
        FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info", alt = { "IMPORTANT" } },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
        before = "", -- "fg" or "bg" or empty
        keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
    },
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
})

require("bqf").setup({
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        auto_preview = false;
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match("^fugitive://") then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end,
    },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
        tabc = "",
        ptogglemode = "z,",
    },
    filter = {
        fzf = {
            action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
    },
})

local mappings_utils = require("renamer.mappings.utils")
require("renamer").setup({
    -- The popup title, shown if `border` is true
    title = "Rename",
    -- The padding around the popup content
    padding = {
        top = 0,
        left = 0,
        bottom = 0,
        right = 0,
    },
    -- The minimum width of the popup
    min_width = 15,
    -- The maximum width of the popup
    max_width = 45,
    -- Whether or not to shown a border around the popup
    border = true,
    -- The characters which make up the border
    border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    -- Whether or not to highlight the current word references through LSP
    show_refs = true,
    -- Whether or not to add resulting changes to the quickfix list
    with_qf_list = true,
    -- Whether or not to enter the new name through the UI or Neovim's `input`
    -- prompt
    with_popup = true,
    -- The keymaps available while in the `renamer` buffer. The example below
    -- overrides the default values, but you can add others as well.
    mappings = {
        ["<c-i>"] = mappings_utils.set_cursor_to_start,
        ["<c-a>"] = mappings_utils.set_cursor_to_end,
        ["<c-e>"] = mappings_utils.set_cursor_to_word_end,
        ["<c-b>"] = mappings_utils.set_cursor_to_word_start,
        ["<c-c>"] = mappings_utils.clear_line,
        ["<c-u>"] = mappings_utils.undo,
        ["<c-r>"] = mappings_utils.redo,
    },
    -- Custom handler to be run after successfully renaming the word. Receives
    -- the LSP 'textDocument/rename' raw response as its parameter.
    handler = nil,
})



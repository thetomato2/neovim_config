if not pcall(require, "nvim-treesitter") then
  return
end

local ts_debugging = false
if ts_debugging then
  RELOAD "nvim-treesitter"
end

local list = require("nvim-treesitter.parsers").get_parser_configs()

list.sql = {
  install_info = {
    url = "https://github.com/DerekStride/tree-sitter-sql",
    files = { "src/parser.c" },
    branch = "main",
  },
}

list.rsx = {
  install_info = {
    url = "https://github.com/tjdevries/tree-sitter-rsx",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "master",
  },
}

-- list.lua = nil

-- -- :h nvim-treesitter-query-extensions
-- local custom_captures = {
--   ["function.call.lua"] = "LuaFunctionCall",
--   ["function.bracket"] = "Type",
--   ["namespace.type"] = "TSNamespaceType",
-- }

-- require("nvim-treesitter.highlight").set_custom_captures(custom_captures)

-- alt+<space>, alt+p -> swap next
-- alt+<backspace>, alt+p -> swap previous
-- swap_previous = {
--   ["<M-s><M-P>"] = "@parameter.inner",
--   ["<M-s><M-F>"] = "@function.outer",
-- -- },
-- local swap_next, swap_prev = (function()
--   local swap_objects = {
--     p = "@parameter.inner",
--     f = "@function.outer",
--     e = "@element",
--
--     -- Not ready, but I think it's my fault :)
--     -- v = "@variable",
--   }
--
--   local n, p = {}, {}
--   for key, obj in pairs(swap_objects) do
--     n[string.format("<M-Space><M-%s>", key)] = obj
--     p[string.format("<M-BS><M-%s>", key)] = obj
--   end
--
--   return n, p
-- end)()

local _ = require("nvim-treesitter.configs").setup {
  ensure_installed = {
      "c",
      "cpp",
      "lua",
  },

  highlight = {
    enable = true,
    -- use_languagetree = false,
    -- disable = { "json" },
    custom_captures = custom_captures,
    additional_vim_regex_highlighting = false,
  },

  context_commentstring = {
    enable = true,

    -- With Comment.nvim, we don't need to run this on the autocmd.
    -- Only run it in pre-hook
    enable_autocmd = false,

    config = {
      c = "// %s",
      lua = "-- %s",
    },
  },

    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    },
  playground = {
    enable = true,
    updatetime = 25,
    persist_queries = true,
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",

      -- This shows stuff like literal strings, commas, etc.
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
}


-- local read_query = function(filename)
--   return table.concat(vim.fn.readfile(vim.fn.expand(filename)), "\n")
-- end

-- Overrides any existing tree sitter query for a particular name
-- vim.treesitter.set_query("rust", "highlights", read_query "~/.config/nvim/queries/rust/highlights.scm")
-- vim.treesitter.set_query("sql", "highlights", read_query "~/.config/nvim/queries/sql/highlights.scm")

-- vim.cmd [[highlight IncludedC guibg=#373b41]]

-- vim.cmd [[nnoremap <space>tp :TSPlaygroundToggle<CR>]]
-- vim.cmd [[nnoremap <space>th :TSHighlightCapturesUnderCursor<CR>]]

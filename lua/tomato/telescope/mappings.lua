if not pcall(require, "telescope") then
    return
  end

  local vmap = require("tomato.keymap").vmap
  
  local sorters = require "telescope.sorters"
  
  TelescopeMapArgs = TelescopeMapArgs or {}
  
  local map_tele = function(key, f, options, buffer)
    local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  
    TelescopeMapArgs[map_key] = options or {}
  
    local mode = "n"
    local rhs = string.format("<cmd>lua R('tomato.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)
  
    local map_options = {
      noremap = true,
      silent = true,
    }
  
    if not buffer then
      vim.api.nvim_set_keymap(mode, key, rhs, map_options)
    else
      vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
    end
  end

  local vmap_tele = function(key, f, options, buffer)
    local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  
    TelescopeMapArgs[map_key] = options or {}
  
    local mode = "v"
    local rhs = string.format("<cmd>lua R('tomato.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)
  
    local map_options = {
      noremap = true,
      silent = true,
    }
  
    if not buffer then
      vim.api.nvim_set_keymap(mode, key, rhs, map_options)
    else
      vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
    end
  end
  
  vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })
  
  -- Dotfiles
  map_tele("<leader>en", "edit_neovim")
  map_tele("<leader>ez", "edit_zsh")
  map_tele("<space><space>d", "diagnostics")
 
  -- Search
  map_tele("<space>gw", "grep_string", {
    short_path = true,
    word_match = "-w",
    only_sort_text = true,
    layout_strategy = "vertical",
    sorter = sorters.get_fzy_sorter(),
  })

  map_tele("<space>f/", "grep_last_search", {
    layout_strategy = "vertical",
  })
  
  -- Files
  map_tele("<space>ft", "git_files")
  map_tele("<space>fg", "live_grep")
  -- map_tele("<space>fg", "multi_rg")
  -- map_tele("<space>fo", "oldfiles")
  map_tele("<space>ff", "find_files")
  map_tele("<space>fs", "fs")
  -- map_tele("<space>pp", "project_search")
  -- map_tele("<space>fv", "find_nvim_source")
  map_tele("<space>fe", "file_browser")
  map_tele("<space>fz", "search_only_certain_files")

  vmap_tele("<space>fg", "grep_string")

  
  
  -- -- Git
  -- map_tele("<space>gs", "git_status")
  -- map_tele("<space>gc", "git_commits")
  
  -- Nvim
  map_tele("<space>fb", "buffers")
  map_tele("<space>fa", "installed_plugins")
  map_tele("<space>fi", "search_all_files")
  map_tele("<space>fc", "curbuf")
  map_tele("<space>fh", "help_tags")
  map_tele("<space>bo", "vim_options")
  map_tele("<space>gp", "grep_prompt")
  map_tele("<space>wt", "treesitter")
  map_tele("<space>fr", "registers")
  
  -- Telescope Meta
  map_tele("<space>fB", "builtin")
  
  return map_tele
  

_ = vim.cmd([[packadd packer.nvim]])
_ = vim.cmd([[packadd vimball]])

local has = function(x)
    return vim.fn.has(x) == 1
end

local executable = function(x)
    return vim.fn.executable(x) == 1
end

local is_wsl = (function()
    local output = vim.fn.systemlist("uname -r")
    return not not string.find(output[1] or "", "WSL")
end)()

local is_mac = has("macunix")
local is_linux = not is_wsl and not is_mac

local max_jobs = nil
if is_mac then
    max_jobs = 32
end

return require("packer").startup({
    function(use)
        local local_use = function(first, second, opts)
            opts = opts or {}

            local plug_path, home
            if second == nil then
                plug_path = first
                home = "derrk"
            else
                plug_path = second
                home = first
            end

            if vim.fn.isdirectory(vim.fn.expand("~/plugins/" .. plug_path)) == 1 then
                opts[1] = "~/plugins/" .. plug_path
            else
                opts[1] = string.format("%s/%s", home, plug_path)
            end

            use(opts)
        end

        local py_use = function(opts)
            if not has("python3") then
                return
            end

            use(opts)
        end

        use("wbthomason/packer.nvim")
        use("ellisonleao/gruvbox.nvim")
        -- Alternative to impatient, uses sqlite. Faster ;)
        -- use https://github.com/tami5/impatient.nvim
        -- use "lewis6991/impatient.nvim"

        -- My Plugins
        -- local_use("ThePrimeagen", "refactoring.nvim")

        -- local_use "nlua.nvim"
        -- local_use "vim9jit"
        -- local_use "vimterface.nvim"
        -- local_use "colorbuddy.nvim"
        -- local_use "gruvbuddy.nvim"
        -- local_use "apyrori.nvim"
        -- local_use "manillua.nvim"
        -- local_use "cyclist.vim"
        -- local_use "express_line.nvim"
        -- local_use "overlength.vim"
        -- local_use "pastery.vim"
        -- local_use "complextras.nvim"
        -- local_use "lazy.nvim"
        -- local_use("tjdevries", "astronauta.nvim")
        -- local_use "diff-therapy.nvim"

        -- Contributor Plugins
        -- local_use("L3MON4D3", "LuaSnip")
        use("L3MON4D3/LuaSnip")

        -- When I have some extra time...
        -- local_use "train.vim"
        -- local_use "command_and_conquer.nvim"
        -- local_use "streamer.nvim"
        -- local_use "bandaid.nvim"

        -- LSP Plugins:

        -- use("theHamsta/nvim-semantic-tokens")
        -- NOTE: lspconfig ONLY has configs, for people reading this :)
        use("neovim/nvim-lspconfig")
        use("j-hui/fidget.nvim")
        use({
            "ericpubu/lsp_codelens_extensions.nvim",
            config = function()
                require("codelens_extensions").setup()
            end,
        })

        use("jose-elias-alvarez/null-ls.nvim")
        use("ray-x/lsp_signature.nvim")
        -- use" p00f/clangd_extensions.nvim"

        -- local_use "lsp_extensions.nvim"
        use("onsails/lspkind-nvim")
        -- use "glepnir/lspsaga.nvim"
        -- https://github.com/rmagatti/goto-preview

        -- use {
        --   "akinsho/flutter-tools.nvim",
        --   ft = { "flutter", "dart" },
        -- }

        -- use "/home/tjdevries/plugins/stackmap.nvim"
        -- Plug "/home/bash/plugins/stackmap.nvim"

        -- use "simrat39/rust-tools.nvim"
        -- use "ray-x/go.nvim"
        use("jose-elias-alvarez/nvim-lsp-ts-utils")

        -- use {
        --   "folke/noice.nvim",
        --   event = "VimEnter",
        --   config = function()
        --     require("noice").setup()
        --   end,
        --   requires = {
        --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        --     "MunifTanjim/nui.nvim",
        --     "rcarriga/nvim-notify",
        --   },
        -- }

        use({
            "folke/lsp-trouble.nvim",
            cmd = "Trouble",
            config = function()
                -- Can use P to toggle auto movement
                require("trouble").setup({
                    auto_preview = false,
                    auto_fold = true,
                })
            end,
        })

        use("rcarriga/nvim-notify")

        use("nvim-lua/plenary.nvim")
        use("nvim-telescope/telescope.nvim")
        use({
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        })
        use({ "nvim-telescope/telescope-rs.nvim" })
        use({ "nvim-telescope/telescope-fzf-writer.nvim" })
        use({ "nvim-telescope/telescope-packer.nvim" })
        use({ "nvim-telescope/telescope-github.nvim" })
        use({ "nvim-telescope/telescope-symbols.nvim" })
        use({ "nvim-telescope/telescope-hop.nvim" })
        use({ "nvim-telescope/telescope-file-browser.nvim" })
        use({ "nvim-telescope/telescope-ui-select.nvim" })

        use("chaoren/vim-wordmotion")
        use("derekwyatt/vim-fswitch")
        use("JoseConseco/vim-case-change")
        use("feline-nvim/feline.nvim")

        use("rktjmp/lush.nvim")
        use("p00f/nvim-ts-rainbow")

        use({
            "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end,
        })

        -- use("C:/dev/tomato_nvim_theme")
        use("C:/dev/neovim_tomato_theme")

        use({
            "AckslD/nvim-neoclip.lua",
            config = function()
                require("neoclip").setup()
            end,
        })

        -- For narrowing regions of text to look at them alone
        use({
            "chrisbra/NrrwRgn",
            cmd = { "NarrowRegion", "NarrowWindow" },
        })

        -- Pretty colors
        use("norcalli/nvim-colorizer.lua")
        use({
            "norcalli/nvim-terminal.lua",
            config = function()
                require("terminal").setup()
            end,
        })

        use("hrsh7th/nvim-cmp")
        -- use "hrsh7th/cmp-cmdline"
        use("hrsh7th/cmp-buffer")
        use("hrsh7th/cmp-path")
        use("hrsh7th/cmp-nvim-lua")
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-nvim-lsp-document-symbol")
        use("saadparwaiz1/cmp_luasnip")
        use("tamago324/cmp-zsh")
        use("rafamadriz/friendly-snippets")

        use({
            "windwp/nvim-autopairs",
            config = function()
                require("nvim-autopairs").setup({})
            end,
        })

        -- use({
        --     "kyazdani42/nvim-tree.lua",
        --     requires = {
        --         "kyazdani42/nvim-web-devicons", -- optional, for file icons
        --     },
        --     tag = "nightly", -- optional, updated every week. (see issue #1193)
        -- })

        use({
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
            },
            setup = function()
                vim.g.neo_tree_remove_legacy_commands = true
            end,
        })

        use({
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
        })

        use({
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup({
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                })
            end,
        })

        use({
            "kylechui/nvim-surround",
            tag = "*", -- Use for stability; omit to use `main` branch for the latest features
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end,
        })

        use({
            "nvim-treesitter/nvim-treesitter",
            run = function()
                require("nvim-treesitter.install").update({ with_sync = true })
            end,
        })
        use("nvim-treesitter/playground")
        -- use "vigoux/architext.nvim"

        use("nvim-treesitter/nvim-treesitter-textobjects")
        -- use "JoosepAlviste/nvim-ts-context-commentstring"
        -- use {
        --   "mfussenegger/nvim-ts-hint-textobject",
        --   config = function()
        --     vim.cmd [[omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>]]
        --     vim.cmd [[vnoremap <silent> m :lua require('tsht').nodes()<CR>]]
        --   end,
        -- }

        -- use "tamago324/lir.nvim"
        -- use "tamago324/lir-git-status.nvim"
        -- if executable "mmv" then
        --   use "tamago324/lir-mmv.nvim"
        -- end

        -- use "sindrets/diffview.nvim"

        -- -- Git worktree utility
        -- use {
        --   "ThePrimeagen/git-worktree.nvim",
        --   config = function()
        --     require("git-worktree").setup {}
        --   end,
        -- }

        -- use { "jackguo380/vim-lsp-cxx-highlight" }
        -- use { "mphe/grayout.vim" }

        -- use "ThePrimeagen/harpoon"
        -- use 'untitled-ai/jupyter_ascending.vim'

        use({ "kevinhwang91/nvim-bqf" })
        use({
            "junegunn/fzf",
            run = function()
                vim.fn["fzf#install"]()
            end,
        })

        use({
            "filipdutescu/renamer.nvim",
            branch = "master",
            requires = { { "nvim-lua/plenary.nvim" } },
        })

        use({
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig",
        })

        use("C:/dev/neovim_tomato")
    end,

    config = {
        max_jobs = max_jobs,
        luarocks = {
            python_cmd = "python3",
        },
        display = {
            -- open_fn = require('packer.util').float,
        },
    },
})

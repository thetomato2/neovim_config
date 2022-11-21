vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    use("nanotech/jellybeans.vim")
    use("bluz71/vim-moonfly-colors")
    use("rafamadriz/neon")
    -- use 'tpope/vim-surround'
    -- use 'tpope/vim-commentary'
    use("neovim/nvim-lspconfig")
    use("chaoren/vim-wordmotion")
    use("derekwyatt/vim-fswitch")
    use("JoseConseco/vim-case-change")
    use("feline-nvim/feline.nvim")
    use({ "williamboman/mason.nvim" })

    use("C:/dev/tomato_nvim_theme")
    use"C:/dev/neovim_tomato"
    -- use 'lukas-reineke/indent-blankline.nvim

    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })

    use({ "jose-elias-alvarez/null-ls.nvim", requires = { { "nvim-lua/plenary.nvim" } } })

    use("hrsh7th/nvim-cmp")

    -- use({
    -- 	"hrsh7th/nvim-cmp",
    -- 	requires = {
    -- 		{
    -- 			"quangnguyen30192/cmp-nvim-tags",
    -- 			-- if you want the sources is available for some file types
    -- 		},
    -- 	},
    -- 	config = function()
    -- 		require("cmp").setup({
    -- 			sources = {
    -- 				{ name = "tags" },
    -- 				-- more sources
    -- 			},
    -- 		})
    -- 	end,
    -- })

    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")

    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lsp")
    use("rafamadriz/friendly-snippets")
    use("norcalli/nvim-colorizer.lua")
    use("rktjmp/lush.nvim")
    use("p00f/nvim-ts-rainbow")

    use("akinsho/toggleterm.nvim")

    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
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

    -- use({
    -- 	"ludovicchabant/vim-gutentags",
    -- 	config = function()
    -- 		-- https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
    -- 		vim.g.gutentags_ctags_exclude = {
    -- 			"*.git",
    -- 			"*.svg",
    -- 			"*.hg",
    -- 			"*/tests/*",
    -- 			"build",
    -- 			"dist",
    -- 			"*sites/*/files/*",
    -- 			"bin",
    -- 			"node_modules",
    -- 			"bower_components",
    -- 			"cache",
    -- 			"compiled",
    -- 			"docs",
    -- 			"example",
    -- 			"bundle",
    -- 			"vendor",
    -- 			"*.md",
    -- 			"*-lock.json",
    -- 			"*.lock",
    -- 			"*bundle*.js",
    -- 			"*build*.js",
    -- 			".*rc*",
    -- 			"*.json",
    -- 			"*.min.*",
    -- 			"*.map",
    -- 			"*.bak",
    -- 			"*.zip",
    -- 			"*.pyc",
    -- 			"*.class",
    -- 			"*.sln",
    -- 			"*.Master",
    -- 			"*.csproj",
    -- 			"*.tmp",
    -- 			"*.csproj.user",
    -- 			"*.cache",
    -- 			"*.pdb",
    -- 			"tags*",
    -- 			"cscope.*",
    -- 			-- '*.css',
    -- 			-- '*.less',
    -- 			-- '*.scss',
    -- 			"*.exe",
    -- 			"*.dll",
    -- 			"*.mp3",
    -- 			"*.ogg",
    -- 			"*.flac",
    -- 			"*.swp",
    -- 			"*.swo",
    -- 			"*.bmp",
    -- 			"*.gif",
    -- 			"*.ico",
    -- 			"*.jpg",
    -- 			"*.png",
    -- 			"*.rar",
    -- 			"*.zip",
    -- 			"*.tar",
    -- 			"*.tar.gz",
    -- 			"*.tar.xz",
    -- 			"*.tar.bz2",
    -- 			"*.pdf",
    -- 			"*.doc",
    -- 			"*.docx",
    -- 			"*.ppt",
    -- 			"*.pptx",
    -- 		}
    --
    -- 		vim.g.gutentags_add_default_project_roots = false
    -- 		vim.g.gutentags_project_root = { "package.json", ".git" }
    -- 		vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/nvim/ctags/")
    -- 		vim.g.gutentags_generate_on_new = true
    -- 		vim.g.gutentags_generate_on_missing = true
    -- 		vim.g.gutentags_generate_on_write = true
    -- 		vim.g.gutentags_generate_on_empty_buffer = true
    -- 		vim.g.gutentags_modules = true
    -- 		-- vim.g.gutentags_trace = true
    -- 		vim.cmd([[command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')]])
    -- 		vim.g.gutentags_ctags_extra_args = { "--tag-relative=yes", "--fields=+ailmnS" }
    --
    -- 		-- custom
    -- 		vim.g.gutentags_modules = { "ctags" }
    -- 	end,
    -- })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    })

    -- use({ "nvim-treesitter/playground" })
    use {'kevinhwang91/nvim-bqf'}
    use({
        "junegunn/fzf",
        run = function()
            vim.fn["fzf#install"]()
        end,
    })
    -- use 'mfussenegger/nvim-dap'
    use({ "onsails/lspkind.nvim" })

    use({
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons", -- optional, for file icons
        },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
        view = {
            adaptive_size = false,
            preserve_window_proportions = true,
        },
    })

    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    })

    use({ "ray-x/lsp_signature.nvim" })
    use({ "p00f/clangd_extensions.nvim" })


    -- use("C:/dev/repos/neovim-cmake")
    -- use({ "Civitasv/cmake-tools.nvim" })
    --
    use ({ "Shatur/neovim-tasks" })
    -- use({ 'mfussenegger/nvim-dap' })

end)

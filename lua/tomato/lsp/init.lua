local lspconfig = vim.F.npcall(require, "lspconfig")
if not lspconfig then
	return
end

local imap = require("tomato.keymap").imap
local nmap = require("tomato.keymap").nmap
local vmap = require("tomato.keymap").vmap

local autocmd = require("tomato.auto").autocmd
local autocmd_clear = vim.api.nvim_clear_autocmds

local navic = require("nvim-navic")

local semantic = vim.F.npcall(require, "nvim-semantic-tokens")

local is_mac = vim.fn.has("macunix") == 1

local lspconfig_util = require("lspconfig.util")

local telescope_mapper = require("tomato.telescope.mappings")
local handlers = require("tomato.lsp.handlers")

local ts_util = require("nvim-lsp-ts-utils")

local custom_init = function(client)
	client.config.flags = client.config.flags or {}
	client.config.flags.allow_incremental_sync = true
end

local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })
local augroup_semantic = vim.api.nvim_create_augroup("custom-lsp-semantic", { clear = true })

local on_full = semantic.on_full
local on_full = require("nvim-semantic-tokens.semantic_tokens").on_full

function vim.lsp.buf.semantic_tokens_range(start_pos, end_pos)
	local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
	vim.lsp.buf_request(
		0,
		"textDocument/semanticTokens/range",
		params,
		vim.lsp.with(on_full, {
			on_token = function(ctx, token)
				vim.notify(token.type .. "." .. table.concat(token.modifiers .. "man"))
			end,
		})
	)
end

local autocmd_format = function(async, filter)
	vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = 0,
		callback = function()
			vim.lsp.buf.format({ async = async, filter = filter })
		end,
	})
end

local filetype_attach = setmetatable({
	go = function()
		autocmd_format(false)
	end,

	scss = function()
		autocmd_format(false)
	end,

	css = function()
		autocmd_format(false)
	end,

	rust = function()
		telescope_mapper("<space>fw", "lsp_workspace_symbols", {
			ignore_filename = true,
			query = "#",
		}, true)

		autocmd_format(false)
	end,

	racket = function()
		autocmd_format(false)
	end,

	typescript = function()
		autocmd_format(false, function(client)
			return client.name ~= "tsserver"
		end)
	end,
}, {
	__index = function()
		return function() end
	end,
})

local buf_nnoremap = function(opts)
	if opts[3] == nil then
		opts[3] = {}
	end
	opts[3].buffer = 0

	nmap(opts)
end

local buf_inoremap = function(opts)
	if opts[3] == nil then
		opts[3] = {}
	end
	opts[3].buffer = 0

	imap(opts)
end

local buf_vnoremap = function(opts)
	if opts[3] == nil then
		opts[3] = {}
	end
	opts[3].buffer = 0

	vmap(opts)
end

local custom_attach = function(client, bufnr)
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	print("buffer attached")

	-- buf_inoremap({ "K", vim.lsp.buf.signature_help })

	buf_nnoremap({ "<space>lr", vim.lsp.buf.rename })
	buf_nnoremap({ "<space>la", vim.lsp.buf.code_action })

	buf_nnoremap({ "gd", vim.lsp.buf.definition })
	buf_nnoremap({ "gD", vim.lsp.buf.declaration })
	buf_nnoremap({ "go", vim.lsp.buf.type_definition })
	buf_nnoremap({
		"<space>lk",
		function()
			vim.lsp.buf.format({ async = true })
		end,
	})

	buf_nnoremap({ "<space>gI", handlers.implementation })
	buf_nnoremap({ "<space>le", "<cmd>lua R('tomato.lsp.codelens').run()<CR>" })
	buf_nnoremap({ "<space>rr", "LspRestart" })

	telescope_mapper("gr", "lsp_references", nil, true)
	telescope_mapper("gI", "lsp_implementations", nil, true)
	telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
	telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)

	buf_nnoremap({ "gh", vim.lsp.buf.hover, { desc = "lsp:hover" } })

	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		autocmd_clear({ group = augroup_highlight, buffer = bufnr })
		autocmd({ "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, buffer = bufnr })
		autocmd({ "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, buffer = bufnr })
	end

	if false and client.server_capabilities.codeLensProvider then
		if filetype ~= "elm" then
			autocmd_clear({ group = augroup_codelens, buffer = bufnr })
			autocmd({ "BufEnter", augroup_codelens, vim.lsp.codelens.refresh, bufnr, once = true })
			autocmd({ { "BufWritePost", "CursorHold" }, augroup_codelens, vim.lsp.codelens.refresh, bufnr })
		end
	end

	local caps = client.server_capabilities
	if semantic and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
		autocmd_clear({ group = augroup_semantic, buffer = bufnr })
		autocmd({ "TextChanged", augroup_semantic, vim.lsp.buf.semantic_tokens_full, bufnr })
		buf_vnoremap({ "<leader>lo", vim.lsp.buf.semantic_tokens_range })
	end

	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end

	-- Attach any filetype specific options to the client
	filetype_attach[filetype](client)
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Completion configuration
require("cmp_nvim_lsp").default_capabilities(updated_capabilities)
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

-- Semantic token configuration
if semantic then
	semantic.setup({
		preset = "default",
		highlighters = { require("nvim-semantic-tokens.table-highlighter") },
	})

	semantic.extend_capabilities(updated_capabilities)
end

updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }

local rust_analyzer, rust_analyzer_cmd = nil, { "rustup", "run", "nightly", "rust-analyzer" }
local has_rt, rt = pcall(require, "rust-tools")
if has_rt then
	local extension_path = vim.fn.expand("~/.vscode/extensions/sadge-vscode/extension/")
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

	rt.setup({
		server = {
			cmd = rust_analyzer_cmd,
			capabilities = updated_capabilities,
			on_attach = custom_attach,
		},
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		},
		tools = {
			inlay_hints = {
				auto = false,
			},
		},
	})
else
	rust_analyzer = {
		cmd = rust_analyzer_cmd,
	}
end

local servers = {
	-- Also uses `shellcheck` and `explainshell`
	bashls = true,

	eslint = true,
	gdscript = true,
	-- graphql = true,
	html = true,
	pyright = true,
	vimls = true,
	yamlls = true,
	glslls = true,
	hlsl = {
		cmd = {
			"ShaderTools.LanguageServer",
		},
		filetypes = { "hlsl" },
	},

	cmake = (1 == vim.fn.executable("cmake-language-server")),
	dartls = pcall(require, "flutter-tools"),

	-- ccls = {
	-- 	init_options = {
	-- 		compilationDatabaseDirectory = "build",
	-- 		index = {
	-- 			threads = 0,
	-- 		},
	-- 		clang = {
	-- 			excludeArgs = { "-frounding-math" },
	-- 		},
	-- 		cache = { directory = ".ccls-cache" },
	-- 		highlight = {
	-- 			lsRanges = true,
	-- 		},
	-- 	},
	-- },

	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--suggest-missing-includes",
			"--clang-tidy",
			"--header-insertion=iwyu",
		},
		init_options = {
			clangdFileStatus = true,
		},
	},

	gopls = {
		-- root_dir = function(fname)
		--   local Path = require "plenary.path"
		--
		--   local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
		--   local absolute_fname = Path:new(fname):absolute()
		--
		--   if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
		--     return absolute_cwd
		--   end
		--
		--   return lspconfig_util.root_pattern("go.mod", ".git")(fname)
		-- end,

		settings = {
			gopls = {
				codelenses = { test = true },
			},
		},

		flags = {
			debounce_text_changes = 200,
		},
	},

	omnisharp = {
		cmd = { vim.fn.expand("~/build/omnisharp/run"), "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	},

	rust_analyzer = rust_analyzer,

	racket_langserver = true,

	elmls = true,
	cssls = true,
	tsserver = {
		init_options = ts_util.init_options,
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},

		on_attach = function(client)
			custom_attach(client)

			ts_util.setup({ auto_inlay_hints = false })
			ts_util.setup_client(client)
		end,
	},
	sumneko_lua = {
		settings = {
			Lua = {
				diagnostics = {
					globals = {
						-- vim
						"vim",

						-- Busted
						"describe",
						"it",
						"before_each",
						"after_each",
						"teardown",
						"pending",
						"clear",

						-- Colorbuddy
						"Color",
						"c",
						"Group",
						"g",
						"s",

						-- Custom
						"RELOAD",
					},
				},

				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		},
	},
}

local setup_server = function(server, config)
	if not config then
		return
	end

	if type(config) ~= "table" then
		config = {}
	end

	config = vim.tbl_deep_extend("force", {
		on_init = custom_init,
		on_attach = custom_attach,
		capabilities = updated_capabilities,
		flags = {
			debounce_text_changes = nil,
		},
	}, config)

	lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
	setup_server(server, config)
end

--[ An example of using functions...
-- 0. nil -> do default (could be enabled or disabled)
-- 1. false -> disable it
-- 2. true -> enable, use defaults
-- 3. table -> enable, with (some) overrides
-- 4. function -> can return any of above
--
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, method, params, client_id, bufnr, config)
--   local uri = params.uri
--
--   vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--       underline = true,
--       virtual_text = true,
--       signs = sign_decider,
--       update_in_insert = false,
--     }
--   )(err, method, params, client_id, bufnr, config)
--
--   bufnr = bufnr or vim.uri_to_bufnr(uri)
--
--   if bufnr == vim.api.nvim_get_current_buf() then
--     vim.lsp.diagnostic.set_loclist { open_loclist = false }
--   end
-- end
--]]

-- Set up null-ls
local use_null = true
if use_null then
	require("null-ls").setup({
		sources = {
			require("null-ls").builtins.formatting.stylua,
			-- require("null-ls").builtins.diagnostics.eslint,
			-- require("null-ls").builtins.completion.spell,
			-- require("null-ls").builtins.diagnostics.selene,
			require("null-ls").builtins.formatting.prettierd,
		},
	})
end

-- Can set this lower if needed.
-- require("vim.lsp.log").set_level "debug"
-- require("vim.lsp.log").set_level "trace"

return {
	on_init = custom_init,
	on_attach = custom_attach,
	capabilities = updated_capabilities,
}

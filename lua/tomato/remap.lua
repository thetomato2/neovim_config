local imap = require("tomato.keymap").imap
local nmap = require("tomato.keymap").nmap
local vmap = require("tomato.keymap").vmap

-- vim.api.nvim_set_keymap("n", "<leader>pv", "<cmd>Ex<CR>")

vim.api.nvim_set_keymap("n", "<leader>oH", "<cmd>FSSplitLeft<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>oL", "<cmd>FSSplitRight<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>oo", "<cmd>FSHere<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>oh", "<cmd>FSLeft<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ol", "<cmd>FSRight<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>set wrap!<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>qo", ":copen<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>qp", ":ccl<cr>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>el", "<cmd>lua vim.diagnostic.setloclist()<cr>", { noremap = true })

-- vim.api.nvim_set_keymap("v", "<leader>lo", "<cmd>lua vim.lsp.buf.semantic_tokens_range()<cr>", { noremap = true })

-- vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {noremap = true} )
-- vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>TroubleToggle document_diagnostics<cr>", {noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>TroubleToggle workspace_diagnostics<cr>", {noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {noremap = true})

vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>:NvimTreeToggle<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>th", "<cmd>:TSHighlightCapturesUnderCursor<cr>", { noremap = true })

vim.api.nvim_set_keymap("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>rn",
	'<cmd>lua require("renamer").rename()<cr>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>rn",
	'<cmd>lua require("renamer").rename()<cr>',
	{ noremap = true, silent = true }
)

-- vim.api.nvim_set_keymap("n", "<leader>t", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

vim.api.nvim_set_keymap("n", "<leader>cb", "<cmd>:CMake build<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>:CMake build_all<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>cn", "<cmd>:CMake build_and_run<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>cr", "<cmd>:CMake run<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ct", "<cmd>:CMake select_build_target<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>cu", "<cmd>:CMake select_build_type<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>cc", ":CMake configure", { noremap = true })

function switch_header()
	vim.cmd("ClangdSwitchSourceHeader")
end

vim.api.nvim_set_keymap("n", "<M-o>", "<cmd>lua switch_header()<cr>", { noremap = true })

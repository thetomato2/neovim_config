vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true

vim.g.mapleader = " "

vim.opt.foldlevelstart = 99

vim.o.guifont = "Hack NF:h11"
vim.o.neovide_fullscreen = 1

vim.opt.mouse = 'a'


vim.diagnostic.config({
    virtual_text = false,
    signs = false
})

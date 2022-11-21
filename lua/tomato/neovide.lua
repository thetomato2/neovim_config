vim.g.neovide_refresh_rate = 144
vim.g.neovide_remember_window_size = true
vim.g.neovide_cursor_trail_legnth = 0
vim.g.neovide_cursor_animation_length = 0
vim.o.guifont = "Hack NF:h11"

vim.api.nvim_set_keymap('n', '<F11>', ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})


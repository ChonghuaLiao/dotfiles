-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.api.nvim_create_autocmd(
  { "InsertLeave" },
  { pattern = "*", command = ":silent !im-select com.apple.keylayout.ABC" }
)
vim.api.nvim_create_autocmd(
  { "InsertEnter" },
  { pattern = "*", command = ":silent !im-select com.apple.keylayout.ABC" }
)
vim.g.python3_host_prog = "~/.miniforge3/bin/python"
vim.g.loaded_python3_provider = nil
vim.cmd "set foldenable foldlevel=100 foldnestmax=100 foldmethod=indent"
-- vim.opt.conceallevel = 2
-- vim.opt.concealcursor = 'nc'

-- vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "tabnew" }, {
--   callback = function()
--     vim.t.bufs = vim.tbl_filter(function(bufnr)
--       return vim.api.nvim_buf_get_option(bufnr, "modified")
--     end, vim.t.bufs)
--   end,
-- })

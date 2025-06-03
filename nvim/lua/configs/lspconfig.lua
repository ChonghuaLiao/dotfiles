local configs = require("nvchad.configs.lspconfig")
local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities
local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
-- local servers = { "pyright", "texlab", "bash-language-server" }
-- local servers = { "pyright", "texlab", }
local servers = {}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

--
-- lspconfig.pyright.setup { blabla}

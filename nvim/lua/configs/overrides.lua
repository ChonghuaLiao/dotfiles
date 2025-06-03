local M = {}

M.treesitter = {
  ensure_installed = {
    "python",
    -- "vim",
    -- "lua",
    -- "html",
    -- "css",
    -- "javascript",
    -- "c",
    -- "markdown",
    -- "markdown_inline",
  },
  indent = {
    enable = true,
    disable = {
      "python",
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    -- "css-lsp",
    -- "html-lsp",
    -- "typescript-language-server",
    -- "deno",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = false,
  },
  renderer = {
    highlight_git = false,
    icons = {
      show = {
        git = false,
      },
    },
  },
  view = {
    width = 40,
  },
}

return M

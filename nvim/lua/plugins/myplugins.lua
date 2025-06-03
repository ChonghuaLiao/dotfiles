local overrides = require "configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "neovim/nvim-lspconfig",
    opts = {
      format = { timeout_ms = 60000 },
    },
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "configs.null-ls"
        end,
      },
    },
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "lervag/vimtex",
    version = "2.13",
    config = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_quickfix_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.opt.conceallevel = 2
      vim.g.tex_conceal = "abdmg"
      vim.g.vimtex_toc_config = {
        name = "TOC",
        split_width = 30,
        todo_sorted = 0,
        show_help = 1,
        show_numbers = 1,
      }
      vim.g.vimtex_quickfix_mode = 0
    end,
    ft = "tex",
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    requires = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require("luasnip-latex-snippets").setup()
    end,
    ft = "tex",
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    opts = {
      enable_autosnippets = true,
      -- store_selction_keys = "<Tab>",
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    -- opts = {
    --   indent = { char = "│", highlight = "IblChar" },
    --   scope = { char = "│", highlight = "IblScopeChar" },
    -- },
    opts = {
      indent = { char = "┇", highlight = "IblChar" },
      scope = { char = "┇", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")
      -- local highlight = {
      --   "RainbowRed",
      --   "RainbowYellow",
      --   "RainbowBlue",
      --   "RainbowOrange",
      --   "RainbowGreen",
      --   "RainbowViolet",
      --   "RainbowCyan",
      -- }

      local hooks = require "ibl.hooks"
      -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      --   vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      --   vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      --   vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      --   vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      --   vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      --   vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      --   vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      -- end)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

      opts.scope = { enabled = true, show_start = false, show_end = false, highlight = { "Function", "Label" } }
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup {
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
        mappings = {
          org = {
            org_toggle_checkbox = "<C-Space>",
          },
        },
      }

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = 'all',
      --   ignore_install = { 'org' },
      -- })
    end,
  },
  {
    "folke/todo-comments.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    ft = "org",
  },
  {
    "dhruvasagar/vim-table-mode",
  },
  {
    "LintaoAmons/cd-project.nvim",
    -- Don't need call the setup function if you think you are good with the default configuration
    tag = "v0.6.1", -- Optional, You can also use tag to pin the plugin version for stability
    init = function() -- use init if you want enable auto_register_project, otherwise config is good
      require("cd-project").setup {
        -- this json file is acting like a database to update and read the projects in real time.
        -- So because it's just a json file, you can edit directly to add more paths you want manually
        projects_config_filepath = vim.fs.normalize(vim.fn.stdpath "config" .. "/cd-project.nvim.json"),
        -- this controls the behaviour of `CdProjectAdd` command about how to get the project directory
        project_dir_pattern = { ".git", ".gitignore", "Cargo.toml", "package.json", "go.mod" },
        choice_format = "both", -- optional, you can switch to "name" or "path"
        projects_picker = "vim-ui", -- optional, you can switch to `telescope`
        auto_register_project = false, -- optional, toggle on/off the auto add project behaviour
        -- do whatever you like by hooks
        hooks = {
          -- Run before cd to project, add a bookmark here, then can use `CdProjectBack` to switch back
          -- {
          --   trigger_point = "BEFORE_CD",
          --   callback = function(_)
          --     vim.print("before cd project")
          --     require("bookmarks").api.mark({name = "before cd project"})
          --   end,
          -- },
          -- Run after cd to project, find and open a file in the target project by smart-open
          -- {
          --   callback = function(_)
          --     require("telescope").extensions.smart_open.smart_open({
          --       cwd_only = true,
          --       filename_first = false,
          --     })
          --   end,
          -- },
        },
      }
    end,
  },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = true, -- or `opts = {}`
  --   ft = "org"
  -- },

  --
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- Uncomment if you want to re-enable which-key
  -- {
  --   "folke/which-key.nvim",
  --   enabled = true,
  -- },
}

return plugins

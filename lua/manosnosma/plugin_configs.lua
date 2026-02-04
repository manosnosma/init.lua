vim.cmd.colorscheme("rose-pine")

require("telescope").setup({
  defaults = {
    -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
  },
})

require("nvim-treesitter").setup({
  ensure_installed = vim.b.treesitter_langs,
  sync_install = false,
  auto_install = true,
  indent = { enable = true },
  highlight = {
    enable = true,
    additional_vim_regex_highlight = false,
  },
})

----------------------------------------------------------------------
-- LSP + CMP + LuaSnip + Conform + Neotest Configurations
----------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Apply to all LSP servers
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vim.fn.stdpath("data")
              .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "cssls",
    "elixirls",
    "emmet_ls",
    "laravel_ls",
    "pyright",
    "rust_analyzer",
    "lua_ls",
    "intelephense",
    "tailwindcss",
    "vtsls",
    "vue_ls",
  },
})

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),

    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "luasnip" },
    {
      name = "async_path",
      option = {},
    },
    {
      name = "spell",
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
      },
    },
    { name = "buffer" },
  }),
})

require("conform").setup({
  notify_on_error = true,
  format_on_save = function(bufnr)
    local disable_filetypes = {
      --php = true,
    }
    return {
      timeout_ms = 500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    lua = { "stylua" },
    go = { "gofmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    elixir = { "mix" },
    heex = { "mix" },
    php = { "pint", "php-cs-fixer" },
    blade = { "pint" },
    vue = { "pint", "prettier" },
  },
})

require("neotest").setup({
  adapters = {
    require("neotest-pest"),
    require("neotest-elixir"),
  },
})

----------------------------------------------------------------------
-- File Management
----------------------------------------------------------------------
require("mini.icons").setup({})
require("oil").setup({
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  columns = { "icon" },
  float = {
    max_width = 0.3,
    max_height = 0.6,
    border = "rounded",
  },
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
})
require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      require("quicker").collapse,
      desc = "Collapse quickfix context",
    },
  },
})

----------------------------------------------------------------------
-- Nice to have
----------------------------------------------------------------------
require("which-key").setup({})
require("remember").setup({})
require("numb").setup({})
require("nvim-toggler").setup({})
require("gitsigns").setup({
  current_line_blame = true,
})
require("marks").setup({
  builtin_marks = { "<", ">", "^" },
})

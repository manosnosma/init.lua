-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    if vim.b.bigfile then
      return
    end
    vim.highlight.on_yank()
  end,
})

-- Reload externally changed files
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
})

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Disable automatic commenting on newlines
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Auto trim trailing white-space when saving
autocmd("BufWritePre", {
  callback = function()
    if vim.b.bigfile then
      return
    end
    vim.cmd("%s/\\s\\+$//e")
    -- vim.cmd("%s/\\n\\+\\%$//e")
  end,
})

-- Color Column (Psagmenia)
vim.cmd([[
    highlight ColorColumn ctermbg=magenta
    call matchadd('ColorColumn', '\%80v', 80)
    " Bury the following somewhere deep inside someones vimrc:
    " highlight ColorColumn ctermbg=red ctermfg=blue
    " exec 'set colorcolumn='.join(range(2,80,3), ',')
]])

-- Calculate vim.b.bigfile
autocmd("BufReadPre", {
  callback = function(args)
    local ok, stat = pcall(vim.loop.fs_stat, args.file)
    vim.b.bigfile = ok and stat and stat.size > 1024
  end,
})

-- Which key
autocmd("VimEnter", {
  callback = function()
    require("which-key").setup({})
  end,
})

-- Enable Tree-sitter globally
autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.b.bigfile then
      return
    end
    pcall(vim.treesitter.start)
  end,
})

-- Lsp Binds
autocmd("LspAttach", {
  callback = function(args)
    local map = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf })
    end

    if vim.b.bigfile then
      vim.diagnostic.show(nil, args.buf)
    else
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    map("n", "gd", vim.lsp.buf.definition)
    map("n", "H", vim.lsp.buf.hover)
    map("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
    map("n", "<leader>vd", vim.diagnostic.open_float)
    map("n", "<leader>vca", vim.lsp.buf.code_action)
    map("n", "<leader>vrr", vim.lsp.buf.references)
    map("n", "<leader>vrn", vim.lsp.buf.rename)
    map("i", "<C-h>", vim.lsp.buf.signature_help)
    map("n", "[d", vim.diagnostic.goto_next)
    map("n", "]d", vim.diagnostic.goto_prev)
  end,
})

-- PHP Stuff
autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.api.nvim_create_user_command("Phpstan", function()
      local output = vim.fn.system({
        "vendor/bin/phpstan",
        "analyse",
        "--memory-limit=2G",
        "--error-format=raw",
        "--no-progress",
        "--no-interaction",
      })

      vim.fn.setqflist({}, "r", {
        title = "PHPStan",
        lines = vim.split(output, "\n", { trimempty = true }),
      })

      vim.cmd("copen")
    end, {})

    if vim.b.bigfile then
      return
    end
    vim.opt_local.iskeyword:append("$")
  end,
})

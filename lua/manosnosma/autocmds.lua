-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("FileType", {
  pattern = vim.b.treesitter_langs,
  callback = function()
    vim.treesitter.start()

    -- Enable Treesitter-based folding
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"

    -- Treesitter-based indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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

-- Run C files
autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.makeprg = "clang % -o %:r"

    vim.keymap.set("n", "<leader>R", function()
      vim.cmd("make")
      vim.cmd('echo "=== compiling and running: ' .. vim.fn.expand("%:r") .. '.c ==="')
      vim.cmd("!./%:r")
    end, { buffer = true, silent = true })
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

    vim.opt_local.iskeyword:append("$")
  end,
})

vim.b.bigfile = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.winborder = "rounded"
vim.opt.mouse = ""
vim.opt.termguicolors = not vim.b.bigfile

vim.opt.updatetime = 50
vim.opt.autoread = not vim.b.bigfile

-- Tabs
vim.opt.tabstop = 4 -- how '\t'abs are displayed
vim.opt.softtabstop = 0 -- 0 means use shiftwidth
vim.opt.shiftwidth = 4 -- the real identation size
vim.opt.expandtab = false -- convert tabs into spaces
vim.opt.breakindent = true -- Affects line wrapping only
vim.opt.smartindent = false -- tree-sitter handles it

if not vim.b.bigfile then
  vim.opt.isfname:append("@-@")
  vim.opt.path:append("**")
end

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undodir"
vim.opt.undofile = not vim.b.bigfile

vim.opt.cursorline = not vim.b.bigfile
vim.opt.scrolloff = 2

vim.opt.spell = not vim.b.bigfile
vim.opt.spelllang = { "en_us", "el" }

vim.diagnostic.config({
  update_in_insert = not vim.b.bigfile,
  severity_sort = true,
  virtual_text = not vim.b.bigfile,
  virtual_lines = false,
  signs = not vim.b.bigfile,
  underline = not vim.b.bigfile,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.opt.langmap = table.concat({
  "αa,ΑA",
  "βb,ΒB",
  "γg,ΓG",
  "δd,ΔD",
  "εe,ΕE",
  "ζz,ΖZ",
  "ηh,ΗH",
  "Θu,ΘU",
  "ιi,ΙI",
  "κk,ΚK",
  "λl,ΛL",
  "μm,ΜM",
  "νn,ΝN",
  "ξj,ΞJ",
  "οo,ΟO",
  "πp,ΠP",
  "ρr,ΡR",
  "σs,ΣS",
  "ςw",
  "τt,ΤT",
  "υy,ΥY",
  "φf,ΦF",
  "χx,ΧX",
  "ψc,ΨC",
  "ωv,ΩV",
}, ",")

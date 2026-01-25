local map = vim.keymap.set

-- Builtin Keymaps
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map({ 'v', 'x', 'n' }, '<C-y>', '"+y', { desc = 'System clipboard yank.' })
map('n', ';', ':', { desc = 'Greatest remap ever!!!' })
map('x', '<leader>p', [["_dP]], { desc = 'Next Greatest remap ever!!!' })
map(
  { 'n', 'v' },
  '<leader>y',
  [["+y]],
  { desc = 'next greatest remap ever : asbjornHaland' }
)
map('n', '<leader>Y', [["+Y]])
map({ 'n', 'v' }, '<leader>d', [["_d]])
map('n', '<C-k>', '<cmd>cnext<CR>zz')
map('n', '<C-j>', '<cmd>cprev<CR>zz')
map('n', '<leader>k', '<cmd>lnext<CR>zz')
map('n', '<leader>j', '<cmd>lprev<CR>zz')
map('n', 'S', [[:%s//g<Left><Left>]])
map('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map('n', '<leader>.', vim.cmd.so, { desc = 'Refresh configuration' })
map('n', '<leader>oc', function()
  local command = vim.fn.input 'Command: '
  if #command then
    vim.cmd(':r !' .. command)
  end
end, { desc = '[O]utput [c]ommand to current buffer' })
-- map('v', 'J', ":m '>+1<CR>gv=gv")
-- map('v', 'K', ":m '<-2<CR>gv=gv")
-- map('n', 'K', ':m .-2<CR>==')
-- map('n', 'J', ':m .+1<CR>==')

-- Plugin Keymaps
local builtin = require 'telescope.builtin'
map({ 'n' }, '_', function()
  require('oil').toggle_float()
end, { desc = 'Open parent directory' })
map(
  { 'n' },
  '<leader>u',
  vim.cmd.UndotreeToggle,
  { desc = 'Toggle Undotree view' }
)
map({ 'n' }, '<leader>fo', builtin.find_files, { desc = 'Telescope files' })
map({ 'n' }, '<leader>ff', builtin.live_grep, { desc = 'Telescope grep' })
map({ 'n' }, '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map({ 'n' }, '<leader>fr', builtin.registers, { desc = 'Telescope registers' })
map({ 'n' }, '<leader>fh', builtin.help_tags, { desc = 'Telescope help' })
map(
  { 'n' },
  '<leader>fg',
  builtin.git_status,
  { desc = 'Telescope git status files' }
)
map(
  { 'n' },
  '<leader>ft',
  vim.cmd.Telescope,
  { desc = 'Telescope the telescope' }
)
map({ 'n' }, '<leader>F', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Format buffer' })
map({ 'n' }, '<leader>t', function()
  require('neotest').run.run()
end, { desc = 'Run nearest test' })
map({ 'n' }, '<leader>T', function()
  require('neotest').run.run(vim.fn.expand '%')
end, { desc = 'Run all tests in file' })

-- Keymap setup
vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Movement enhancements
map('n', 'gg', 'gg0', opts)
map({'n','v'}, 'G', 'G$', opts)
map('n', 'E', '$', opts)
map({'n','v'}, 'B', '0', opts)
map({'n','v'}, 'j', 'gj', opts)
map({'n','v'}, 'k', 'gk', opts)
map({'n','v'}, 's', '}', opts)
map({'n','v'}, 'S', '{', opts)

-- Clipboard yank/paste
map({'n','v'}, '<leader>y', '"+y', opts)
map({'n','v'}, '<leader>p', '"+p', opts)

-- Better indent handling
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Better 'o' behavior in visual
map('x', 'o', 'ozz', opts)

-- Paste without overwriting register
map({'n','v'}, 'p', 'P', opts)

-- Delete without yanking
map({'n','v'}, 'x', '"_x', opts)

-- Clear search
map({'n','v'}, '<Esc>', ':nohlsearch<CR>', opts)
map('n', '<leader>n', ':nohlsearch<CR>', opts)

-- Disable Q
map('n', 'Q', '<nop>', opts)

-- Keep search centered
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Split navigation
map({ 'n', 'v' }, '<leader>ww', '<C-w>w', opts)
map({ 'n', 'v' }, '<C-H>', '<C-w>H', opts)
map({ 'n', 'v' }, '<C-J>', '<C-w>J', opts)
map({ 'n', 'v' }, '<C-K>', '<C-w>K', opts)
map({ 'n', 'v' }, '<C-L>', '<C-w>L', opts)
map({ 'n', 'v' }, '<C-h>h', '<C-w>h', opts)
map({ 'n', 'v' }, '<C-l>l', '<C-w>l', opts)

-- Tabs (simulated via buffers or plugins like barbar or telescope if needed)
map({ 'n', 'v' }, '<leader>to', ':enew<CR>', opts)
map({ 'n', 'v' }, '<leader>tx', ':bdelete<CR>', opts)
map({ 'n', 'v' }, '<leader>tn', ':bnext<CR>', opts)
map({ 'n', 'v' }, '<leader>tp', ':bprevious<CR>', opts)

-- Comment toggle using Comment.nvim
map({ 'n', 'v' }, '<leader>/', function()
  require('Comment.api').toggle.linewise.current()
end, opts)

-- Increment/decrement numbers using dial.nvim
map('n', '<C-a>', require("dial.map").inc_normal(), opts)
map('n', '<C-x>', require("dial.map").dec_normal(), opts)
map('v', '<C-a>', require("dial.map").inc_visual(), opts)
map('v', '<C-x>', require("dial.map").dec_visual(), opts)
map('v', 'g<C-a>', require("dial.map").inc_gvisual(), opts)
map('v', 'g<C-x>', require("dial.map").dec_gvisual(), opts)

-- Multi-cursor (vim-visual-multi)
-- Ctrl-n works by default for visual multi

-- Move lines up/down in visual mode
map('v', 'J', ":m .+1<CR>==", opts)
map('v', 'K', ":m .-2<CR>==", opts)
map('x', 'J', ":move '>+1<CR>gv-gv", opts)
map('x', 'K', ":move '<-2<CR>gv-gv", opts)

-- Custom home/end (if preferred)
map({ 'n', 'v' }, '<leader>h', '^', opts)
map({ 'n', 'v' }, '<leader>l', '$', opts)

-- Visual-mode A/I enhancements
map('x', 'A', function() vim.cmd('normal! A') end, opts)
map('x', 'I', function() vim.cmd('normal! I') end, opts)

-- Placeholder replacements for VSCode functions
map('n', 'u', '<cmd>undo<CR>', opts)
map('n', '<C-r>', '<cmd>redo<CR>', opts)
map({ 'n', 'x' }, '<leader>f', '<cmd>Telescope find_files<CR>', opts)
map({ 'n', 'x' }, '<leader>b', '<cmd>Telescope buffers<CR>', opts)
map({ 'n', 'x' }, '<leader>s', '<cmd>Telescope lsp_document_symbols<CR>', opts)
map({ 'n', 'x' }, '<leader>S', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
map({ 'n', 'x' }, '<leader>d', '<cmd>Telescope diagnostics<CR>', opts)
map({ 'n', 'x' }, '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
map({ 'n', 'x' }, '<leader>o', '<cmd>AerialToggle<CR>', opts)
map({ 'n', 'x' }, '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map({ 'n', 'x' }, '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map({ 'n', 'x' }, '<leader>v', '<cmd>Telescope commands<CR>', opts)
map({ 'n', 'x' }, 'gr', '<cmd>Telescope lsp_references<CR>', opts)
map({ 'n', 'x' }, 'gs', '<cmd>Telescope jumplist<CR>', opts)
map({ 'n', 'x' }, 'gl.', 'g;zz', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
map('n', 'zg', '<cmd>Telescope builtin<CR>', opts)
map('n', '<C-a>s', '<C-w>w', opts)

-- User commands for order manipulation
vim.api.nvim_create_user_command('ROrder', function()
  local i = 0
  local last_line = vim.api.nvim_buf_line_count(0)
  for l = 1, last_line do
    local lineText = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1]
    if lineText:match('^%s*order:') and not lineText:match('^%s*#') then
      local newLine = lineText:gsub('%d+', tostring(i))
      vim.api.nvim_buf_set_lines(0, l - 1, l, false, { newLine })
      i = i + 1
    end
  end
end, {})

vim.api.nvim_create_user_command('IOrder', function()
  vim.cmd([[g/^\s*order:/if getline('.') !~ '^\s*#' | s/\d\+/\=submatch(0) + 1/ | endif]])
end, {})

vim.api.nvim_create_user_command('DOrder', function()
  vim.cmd([[g/^\s*order:/if getline('.') !~ '^\s*#' | s/\d\+/\=submatch(0) - 1/ | endif]])
end, {})
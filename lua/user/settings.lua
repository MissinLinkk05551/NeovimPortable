vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Tabs & indentation
vim.opt.tabstop = 2       -- 2 spaces for tab (prettier default)
vim.opt.shiftwidth = 2    -- 2 spaces for indent width
vim.opt.expandtab = true  -- Expand tab to spaces
vim.opt.autoindent = true -- Copy indent from current line when starting new one
vim.opt.number = true

 -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Improve backspace behavior
vim.opt.backspace = 'indent,eol,start'

-- Show relative line numbers
vim.opt.relativenumber = true
vim.opt.scrolloff = 15 


-- Platform-specific shell configuration
if vim.fn.has("win32") then
  -- For Windows, prefer PowerShell Core (pwsh) if available
  if vim.fn.executable("pwsh") == 1 then
    vim.o.shell = "pwsh"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
  else
    vim.o.shell = "powershell"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command "
  end
  vim.o.shellquote = ""
  vim.o.shellpipe = "| Out-File -Encoding UTF8 %s"
  vim.o.shellredir = "| Out-File -Encoding UTF8 %s"
  -- Set shellxquote to an empty string for pwsh to avoid issues with cmd.exe quoting rules
  vim.o.shellxquote = "" -- Important for pwsh
else -- Unix-like (Linux, macOS)
  vim.o.shell = "bash" -- Or "zsh" or your preferred shell
  vim.o.shellcmdflag = "-c"
  vim.o.shellpipe = "| tee %s"
  vim.o.shellredir = "> %s 2>&1"
  vim.o.shellxquote = "" -- Usually not needed for bash/zsh
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1




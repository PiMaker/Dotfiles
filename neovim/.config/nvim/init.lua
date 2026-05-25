-- Pi's Neovim 0.12 config
-- Works in both VSCode (vscode-neovim) and standalone

local opt = vim.opt
local map = vim.keymap.set
local vscode = vim.g.vscode and require("vscode") or nil

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.backspace = { "indent", "eol", "start" }
opt.showtabline = 2
opt.cursorline = true
opt.autoread = true
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftround = true
opt.smartindent = true
opt.autoindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.scrolloff = 4
opt.sidescrolloff = 10
opt.sidescroll = 1
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.updatetime = 200
opt.visualbell = true
opt.clipboard = "unnamedplus"
opt.title = true
opt.history = 1000
opt.undolevels = 1000
opt.gdefault = true
opt.list = true
opt.fixendofline = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.shortmess:append("c")
opt.hlsearch = true
if vscode then
  opt.report = 9999 -- suppress "N substitutions on M lines" (noisy in VSCode output panel)
  vim.o.cmdheight=4
end

-------------------------------------------------------------------------------
-- vim-plug
-------------------------------------------------------------------------------
local plug = vim.fn["plug#"]
vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")
plug("tpope/vim-commentary")
plug("tpope/vim-surround")
plug("justinmk/vim-sneak")
plug("wellle/targets.vim")
plug("unblevable/quick-scope")
if not vscode then
  plug("tomasiser/vim-code-dark")
  plug("vim-airline/vim-airline")
  plug("vim-airline/vim-airline-themes")
end
vim.call("plug#end")

-- Sneak
vim.g["sneak#label"] = 1
vim.g["sneak#s_next"] = 0
vim.g["sneak#use_ic_scs"] = 1

if not vscode then
  -- Airline
  vim.g["airline#extensions#tabline#enabled"] = 1
  vim.g.airline_powerline_fonts = 1
  vim.g.airline_theme = "codedark"

  -- Quick-scope: only highlight on f/F/t/T
  vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

  -- Colorscheme
  vim.cmd.colorscheme("codedark")
end

-------------------------------------------------------------------------------
-- Autocmds
-------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("user", { clear = true })

-- Don't auto-insert comment on newline, don't auto-wrap
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
    vim.opt_local.formatoptions:append("l")
  end,
})

-- Delete netrw buffers when hidden
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "netrw",
  callback = function()
    vim.opt_local.bufhidden = "delete"
  end,
})

-- Trigger autoread on focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup,
  command = "silent! checktime",
})

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------
local function feed(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode or "n", false)
end

-------------------------------------------------------------------------------
-- Incbool: Ctrl+a / Ctrl+x toggle booleans (true/false, on/off, yes/no)
-------------------------------------------------------------------------------
local incbool_table = {}
for k, v in pairs({ ["false"] = "true", on = "off", yes = "no" }) do
  incbool_table[k] = v
  incbool_table[v] = k
end

local function swap_booleans(fallback_key)
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".") - 1
  local before = line:sub(1, col + 1)
  local word_start = before:find("%w+$")
  if not word_start then
    feed(vim.v.count1 .. fallback_key)
    return
  end
  local word_end = line:find("%W", word_start)
  local word = word_end and line:sub(word_start, word_end - 1) or line:sub(word_start)
  local replacement = incbool_table[word:lower()]
  if not replacement then
    feed(vim.v.count1 .. fallback_key)
    return
  end
  if word == word:upper() then
    replacement = replacement:upper()
  elseif word:sub(1, 1) == word:sub(1, 1):upper() then
    replacement = replacement:sub(1, 1):upper() .. replacement:sub(2)
  end
  local prefix = word_start > 1 and line:sub(1, word_start - 1) or ""
  local suffix = word_end and line:sub(word_end) or ""
  vim.api.nvim_set_current_line(prefix .. replacement .. suffix)
end

map("n", "<C-a>", function() swap_booleans("<C-a>") end, { silent = true, desc = "Increment / Toggle Boolean" })
map("n", "<C-x>", function() swap_booleans("<C-x>") end, { silent = true, desc = "Decrement / Toggle Boolean" })

-------------------------------------------------------------------------------
-- Star search: * searches word under cursor / visual selection without jumping
-------------------------------------------------------------------------------
local function search_cword()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.api.nvim_echo({ { "E348: No string under cursor", "ErrorMsg" } }, false, {})
    return
  end
  local pattern = word:match("^%w") and ("\\<" .. vim.fn.escape(word, "\\") .. "\\>") or vim.fn.escape(word, "\\")
  vim.fn.setreg("/", pattern)
  vim.o.hlsearch = true
  local saved_unnamed, saved_s = vim.fn.getreg('"'), vim.fn.getreg("s")
  vim.cmd([[normal! "syiw]])
  if word ~= vim.fn.getreg("s") then
    vim.cmd("normal! w")
  end
  vim.fn.setreg("s", saved_s)
  vim.fn.setreg('"', saved_unnamed)
end

local function search_visual()
  local saved_unnamed, saved_s = vim.fn.getreg('"'), vim.fn.getreg("s")
  vim.cmd([[normal! gv"sy]])
  local escaped = vim.fn.escape(vim.fn.getreg("s"), [[\]])
  vim.fn.setreg("/", [[\V]] .. escaped:gsub("\n", [[\n]]))
  vim.fn.setreg("s", saved_s)
  vim.fn.setreg('"', saved_unnamed)
  vim.o.hlsearch = true
end

map("n", "*", search_cword, { desc = "Search Word Under Cursor" })
map("x", "*", search_visual, { desc = "Search Visual Selection" })

-------------------------------------------------------------------------------
-- Keymaps: common (both VSCode and standalone)
-------------------------------------------------------------------------------

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlight" })

-- Paragraph movement
map({ "n", "x", "o" }, "<S-j>", "}", { desc = "Next Paragraph" })
map({ "n", "x", "o" }, "<S-k>", "{", { desc = "Previous Paragraph" })
map({ "n", "x", "o" }, "<S-Down>", "}", { desc = "Next Paragraph" })
map({ "n", "x", "o" }, "<S-Up>", "{", { desc = "Previous Paragraph" })

-- Very magic search
map("n", "/", [[/\v]], { desc = "Search (Very Magic)" })
map("x", "/", [[/\v]], { desc = "Search (Very Magic)" })

-- Disable accidental command window, remap macro
map("n", "q:", ":", { desc = "Command-line Mode" })
map("n", "Q", "q", { desc = "Macro Record" })

-- Substitute word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/]], { desc = "Substitute Word Under Cursor" })

-- Ctrl+c is Esc (triggers autocommands, unlike raw Ctrl+c)
map("i", "<C-c>", "<Esc>", { desc = "Escape" })

-- Delete to black hole
map({ "n", "x" }, "<Del>", [["_x]], { desc = "Delete to Black Hole" })

-- Word navigation (Ctrl+arrows)
map("n", "<C-Left>", "b", { desc = "Back Word" })
map("n", "<C-Right>", "w", { desc = "Next Word" })
map("i", "<C-Left>", "<C-o>b", { desc = "Back Word" })
map("i", "<C-Right>", "<C-o>w", { desc = "Next Word" })

-- Tab navigation
map("n", "gn", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "gb", "<cmd>tabprev<cr>", { desc = "Prev Tab" })
map("n", "<C-PageUp>", "<cmd>tabprev<cr>", { desc = "Prev Tab" })
map("n", "<C-PageDown>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("i", "<C-PageUp>", "<C-o>:tabprev<cr>", { desc = "Prev Tab" })
map("i", "<C-PageDown>", "<C-o>:tabnext<cr>", { desc = "Next Tab" })

-- Tabs
map("n", "<C-t>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<C-q>", function()
  if vim.fn.tabpagenr("$") > 1 then vim.cmd("tabclose") end
end, { desc = "Close Tab" })

-- PgUp/PgDown extend selection in visual mode
map("x", "<PageUp>", "<C-b>", { desc = "Page Up" })
map("x", "<PageDown>", "<C-f>", { desc = "Page Down" })

-- 0 goes to first non-blank
map("n", "0", "^", { desc = "First Non-Blank" })

-- Tab/S-Tab indent/outdent
map("n", "<Tab>", ">>", { desc = "Indent Line" })
map("n", "<S-Tab>", "<<", { desc = "Outdent Line" })
map("x", "<Tab>", ">gv", { desc = "Indent Selection" })
map("x", "<S-Tab>", "<gv", { desc = "Outdent Selection" })
map("n", "<", "<Nop>")
map("x", "<", "<Nop>")
map("n", ">", "<Nop>")
map("x", ">", "<Nop>")
map("i", "<S-Tab>", "<C-d>", { desc = "Outdent" })

-- Scroll without moving cursor
map("n", "<C-Up>", "<C-y>", { desc = "Scroll Up" })
map("i", "<C-Up>", "<C-o><C-y>", { desc = "Scroll Up" })
map("n", "<C-Down>", "<C-e>", { desc = "Scroll Down" })
map("i", "<C-Down>", "<C-o><C-e>", { desc = "Scroll Down" })
map("n", "<C-k>", "<C-y>", { desc = "Scroll Up" })
map("i", "<C-k>", "<C-o><C-y>", { desc = "Scroll Up" })
map("n", "<C-j>", "<C-e>", { desc = "Scroll Down" })
map("i", "<C-j>", "<C-o><C-e>", { desc = "Scroll Down" })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("x", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map("x", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-Up>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("x", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map("x", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- Better insert on empty lines (auto-indent)
map("n", "A", function()
  if vim.api.nvim_get_current_line() == "" then
    feed("ddO")
  else
    vim.cmd("startinsert!")
  end
end, { silent = true, desc = "Append / Auto-indent Empty Line" })

-- Auto brace block
map("i", "{<CR>", "{<CR>}<C-o>O", { desc = "Insert Brace Block" })

-- Diagnostic navigation
map("n", "dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
map("n", "dN", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })

-- Cutlass-style: c/s/x to black hole, d/y/p use clipboard (via unnamedplus)
map("n", "x", [["_d1<Right>]], { desc = "Delete Char (Black Hole)" })
map("n", "X", "dd", { desc = "Delete Line" })
map("x", "p", [["_dP]], { desc = "Paste Without Clobbering" })
map("n", "c", [["_c]], { desc = "Change (Black Hole)" })
map("n", "C", [["_C]], { desc = "Change to EOL (Black Hole)" })
map("n", "cc", [["_S]], { desc = "Change Line (Black Hole)" })
map("x", "c", [["_c]], { desc = "Change (Black Hole)" })
map("x", "C", [["_C]], { desc = "Change (Black Hole)" })
map("x", "x", [["_x]], { desc = "Delete (Black Hole)" })

-- Save with Ctrl+s
map({ "n", "x" }, "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })

-- DE keyboard: AltGr arrives as Alt in neovim TUI on Windows
local de_altgr = {
  ["7"] = "{", ["8"] = "[", ["9"] = "]", ["0"] = "}",
  ["q"] = "@", ["e"] = "\xe2\x82\xac", ["\xc3\x9f"] = "\\",
  ["+"] = "~", ["<"] = "|", ["m"] = "\xc2\xb5",
  ["2"] = "\xc2\xb2", ["3"] = "\xc2\xb3",
}
for key, char in pairs(de_altgr) do
  for _, mode in ipairs({ "i", "c", "n", "x", "o", "t" }) do
    map(mode, "<A-" .. key .. ">", char)
  end
end

-------------------------------------------------------------------------------
-- Comment toggle on Enter
-------------------------------------------------------------------------------
if vscode then
  map("n", "<CR>", function() vscode.call("editor.action.commentLine") end, { desc = "Toggle Comment" })
  map("x", "<CR>", function() vscode.call("editor.action.commentLine") end, { desc = "Toggle Comment" })
else
  map("n", "<CR>", "<cmd>Commentary<cr>", { desc = "Toggle Comment" })
  map("x", "<CR>", ":Commentary<cr>", { desc = "Toggle Comment" })
end

-------------------------------------------------------------------------------
-- :e opens files in a new tab
-------------------------------------------------------------------------------
vim.cmd([[cnoreabbrev <expr> e getcmdtype() == ':' && getcmdline() ==# 'e' ? 'tabe' : 'e']])
vim.cmd([[cnoreabbrev <expr> edit getcmdtype() == ':' && getcmdline() ==# 'edit' ? 'tabe' : 'edit']])

-------------------------------------------------------------------------------
-- Standalone-only
-------------------------------------------------------------------------------
if not vscode then
  -- FormatJSON command
  vim.api.nvim_create_user_command("FormatJSON", function()
    local view = vim.fn.winsaveview()
    local ok = pcall(vim.cmd, [[%!python -m json.tool]])
    vim.fn.winrestview(view)
    if not ok then
      vim.notify("FormatJSON failed. Ensure `python` is in PATH.", vim.log.levels.ERROR)
    end
  end, { desc = "Format buffer as JSON" })
end

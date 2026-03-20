
vim.wo.number           = true
vim.wo.relativenumber   = true


local opt               = vim.opt

opt.clipboard           = "unnamedplus"
opt.tabstop             = 4
opt.expandtab           = true
opt.shiftwidth          = 4
opt.softtabstop         = 4
opt.wrap                = false
opt.guicursor           = "n-v-i-c:block-Cursor"
opt.laststatus          = 3

vim.g.mapleader         = " "
vim.g.maplocalleader    = "\\"

local function map(mode, from, to, desc)
    vim.keymap.set(mode, from, to, { desc = desc })
end

local function mapn(from, to, desc) map('n', from, to, desc) end

mapn('<C-a>', '<C-y>', "Scroll down")
mapn('<C-k>', ':Explore .<CR>', "Open file explorer")
mapn('<C-b>', function() require("zen-mode").toggle() end, "Open Zen Mode")
mapn('<C-s>', ':wqall<CR>', "Open Zen Mode")

vim.api.nvim_create_user_command("ZenToggle", function()
  require("zen-mode").toggle()
end, {})

vim.api.nvim_create_user_command("Q", "qall", {})
vim.api.nvim_create_user_command("W", "wqa", {})


-- --------------------------------------- beg: lazy ---------------------------------------

local lazy_path     = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    local lazy_repo = "https://github.com/folke/lazy.nvim.git"
    local out       = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazy_path})
    if vim.v.shell_error ~= 0 then
       error("fuck you... little bitch:\n" .. out)
    end
    vim.fn.getchar()
    os.exit(1)
end
vim.opt.rtp:prepend(lazy_path)

local function setup_lualine(theme)
    require("lualine").setup({
        options = {
            theme = theme,
            globalstatus = true,
            icons_enabled = true,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    })
end

require("lazy").setup {
    {
        "folke/which-key.nvim",
        event   = "VimEnter",
        config  = function()
            require("which-key").setup()
            require("which-key").add {
                { "<leader>c", group = "[C]ode" },
                { "<leader>s", group = "[S]earch" },
            }
        end
    },
    {
        "folke/todo-comments.nvim", event = "VimEnter", 
        dependencies = { "nvim-lua/plenary.nvim" }, 
        opts = { signs = false } 
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            backdrop        = 0.95,
            width           = 0.85,
            height          = 1,
            -- signcolumn   = "no", -- disable signcolumn
            number          = false, -- disable number column
            relativenumber  = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
    },

    {
        "jesseleite/nvim-noirbuddy",
        dependencies = {
          "tjdevries/colorbuddy.nvim",
        },
        lazy = false,
        priority = 1000,
        config = function()
            require("noirbuddy").setup({
                preset = "minimal",
            })

            -- vim.cmd.colorscheme("noirbuddy")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "jesseleite/nvim-noirbuddy",
        },
        config = function()
            local nline = require("noirbuddy.plugins.lualine")
            setup_lualine(nline.theme)
        end,
    },

    {
        "zenbones-theme/zenbones.nvim",
        dependencies = { "rktjmp/lush.nvim" },
        lazy = false,
        priority = 1000,
	    --config = function()
	    --    vim.cmd("set background=light")
	    --    vim.cmd("colorscheme zenbones")
	    --end
    },
}

mapn('<leader>tl', function()
    vim.cmd("colorscheme zenbones")
    vim.cmd("set background=light")
    setup_lualine("auto")
end, "Toggle light mode")
mapn('<leader>td', function()
    vim.cmd("set background=dark")
    vim.cmd("colorscheme noirbuddy")
    local nline = require("noirbuddy.plugins.lualine")
    setup_lualine(nline.theme)
end, "Toggle light mode")

-- --------------------------------------- end: lazy ---------------------------------------

-- --------------------------------------- beg: open in browser ---------------------------------------
local function open_in_browser(url)
  if vim.fn.has("mac") == 1 then
    vim.fn.jobstart({ "open", url }, { detach = true })
  elseif vim.fn.has("win32") == 1 then
    vim.fn.jobstart({ "cmd", "/c", "start", url }, { detach = true })
  else
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  end
end

local function open_visual_selection_in_browser()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  if #lines == 0 then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  lines[1] = string.sub(lines[1], start_pos[3])

  local text = table.concat(lines, "\n")
  text = vim.trim(text)

  if text == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  open_in_browser(text)
end

vim.keymap.set("v", "<leader>ob", open_visual_selection_in_browser, {
  desc = "Open selection in browser",
})
-- --------------------------------------- end: open in browser ---------------------------------------


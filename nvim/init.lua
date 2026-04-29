
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
opt.signcolumn          = "no"

local function fillchars_with_pipe_split_separator(fillchars)
    local result      = {}
    local found_vert  = false

    for item in fillchars:gmatch("[^,]+") do
        if item:match("^vert:") then
            item       = "vert:│"
            found_vert = true
        end
        table.insert(result, item)
    end

    if not found_vert then
        table.insert(result, "vert:│")
    end

    return table.concat(result, ",")
end

local function use_pipe_split_separator()
    vim.o.fillchars = fillchars_with_pipe_split_separator(vim.o.fillchars)

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ok, fillchars = pcall(vim.api.nvim_get_option_value, "fillchars", { win = win })
        if ok then
            pcall(
                vim.api.nvim_set_option_value,
                "fillchars",
                fillchars_with_pipe_split_separator(fillchars),
                { win = win }
            )
        end
    end
end

use_pipe_split_separator()

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "WinNew" }, {
    callback = function()
        vim.schedule(use_pipe_split_separator)
    end,
})

vim.g.mapleader         = " "
vim.g.maplocalleader    = "\\"

local function map(mode, from, to, desc)
    vim.keymap.set(mode, from, to, { desc = desc })
end

local function mapn(from, to, desc) map('n', from, to, desc) end
local function mapt(from, to, desc) map('t', from, to, desc) end

mapt('<Esc>', '<C-\\><C-n>', "Exit terminal mode")

mapn('<C-a>', '<C-y>', "Scroll down")
mapn('<C-k>', function() require("oil").open() end, "Open file explorer")
mapn('<C-s>', ':wqall<CR>', "Close from Zen Mode")

local function toggle_zen_mode()
    zen_mode = require("zen-mode")
    zen_mode.setup({
        window = {
            backdrop = 0.95,
            width    = 0.60,
            height   = 1,
            options  = {
                signcolumn     = "no",
                number         = true, -- disable number column
                relativenumber = true, -- disable relative numbers
                cursorline     = false, -- disable cursorline
                cursorcolumn   = false, -- disable cursor column
                foldcolumn     = "0", -- disable fold column
                list           = false, -- disable whitespace characters
            },
        },
        on_open = function()
            use_pipe_split_separator()
        end,
    })
    zen_mode.toggle()
end

vim.api.nvim_create_user_command("ZenToggle", toggle_zen_mode, {})

vim.api.nvim_create_user_command("Q", "qall", {})
vim.api.nvim_create_user_command("W", "wqa", {})

vim.keymap.set("v", "<leader>u", function()
  vim.cmd('normal! "zy')
  local text = vim.fn.getreg("z")
  local titled = text:gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
  vim.fn.setreg("z", titled)
  vim.cmd('normal! gv"zp')
end, { noremap = true, silent = true, desc = "Title case selection" })

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
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>ff", function() require("fzf-lua").files() end, desc = "[fzf] find files" },
            { "<leader>fg", function() require("fzf-lua").live_grep_native() end, desc = "[fzf] live grep" },
            { "<leader>fo", function() require("fzf-lua").lsp_typedefs() end, desc = "[fzf] type definitions" },
            { "<leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "[fzf] diagnostics" },
            { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "[fzf] document symbols" },
            { "<leader>fS", function() require("fzf-lua").lsp_document_symbols({ regex_filter = "Function" }) end, desc = "[fzf] document functions" },
        },
        opts = {},
    },
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                columns = {
                    "icon",
                },
                keymaps = {
                    ["<CR>"] = "actions.select",
                    ["-"] = "actions.parent",
                    ["g?"] = "actions.show_help",
                    ["<C-s>"] = false,
                },
                view_options = {
                    show_hidden = true,
                },
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "oil_preview",
                callback = function(event)
                    vim.keymap.set("n", "<CR>", function()
                        vim.api.nvim_input("y")
                    end, { buffer = event.buf, silent = true, nowait = true, desc = "Confirm oil changes" })
                end,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            keymap = {
                preset = "default",
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        end
                        return cmp.select_and_accept()
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<C-f>"] = { "select_and_accept", "fallback" },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
        opts_extend = { "sources.default" },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, {
                        desc = "Show line diagnostic",
                    }))

                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, vim.tbl_extend("force", opts, {
                        desc = "Next diagnostic",
                    }))

                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, vim.tbl_extend("force", opts, {
                        desc = "Previous diagnostic",
                    }))

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, {
                        desc = "LSP hover",
                    }))

                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
                        desc = "Code action",
                    }))

                    vim.keymap.set("n", "<leader>A", function()
                        vim.lsp.buf.code_action({ apply = true })
                    end, vim.tbl_extend("force", opts, {
                        desc = "Apply code action",
                    }))

                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {
                        desc = "Rename symbol",
                    }))

                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, {
                        desc = "Go to definition",
                    }))
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            vim.lsp.config("*", {
                capabilities = capabilities,
            })
            vim.lsp.enable({ "clangd", "ruff", "basedpyright", "lua_ls" })
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            })

        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter').setup({
                ensure_installed={"c", "python", "lua"},
                highlight={enable=true},
            })
        end
    },

    -- THEMES
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 0.95,
                width    = 0.85,
                height   = 1,
                options  = {
                    signcolumn     = "no",
                    number         = false, -- disable number column
                    relativenumber = false, -- disable relative numbers
                  -- cursorline = false, -- disable cursorline
                  -- cursorcolumn = false, -- disable cursor column
                    foldcolumn     = "0", -- disable fold column
                  -- list = false, -- disable whitespace characters
                },
            },
            on_open = function()
                use_pipe_split_separator()
            end,
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
    { "savq/melange-nvim" },
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
    vim.cmd("colorscheme melange")
    vim.cmd("set background=light")
    setup_lualine("auto")
end, "Toggle light mode")
mapn('<leader>td', function()
    vim.cmd("set background=dark")
    vim.cmd("colorscheme noirbuddy")
    local nline = require("noirbuddy.plugins.lualine")
    setup_lualine(nline.theme)
end, "Toggle light mode")
mapn('<leader>tz', toggle_zen_mode, "Toggle Zen Mode")

local function open_terminal(direction)
    local cmds = { r = "rightbelow vsplit", l = "leftabove vsplit", u = "leftabove split", d = "rightbelow split" }
    local focus = { r = "wincmd l", l = "wincmd h", u = "wincmd k", d = "wincmd j" }
    vim.cmd(cmds[direction])
    vim.cmd(focus[direction])
    vim.cmd("terminal")
    vim.cmd("startinsert")
end
mapn('<leader>ttr', function() open_terminal('r') end, "Open terminal pane right")
mapn('<leader>ttl', function() open_terminal('l') end, "Open terminal pane left")
mapn('<leader>ttu', function() open_terminal('u') end, "Open terminal pane up")
mapn('<leader>ttd', function() open_terminal('d') end, "Open terminal pane down")

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

vim.keymap.set("v", "<leader>fb", open_visual_selection_in_browser, {
  desc = "Open selection in browser",
})

vim.keymap.set({ 'n', 't' }, '<leader>fe', function()
    local word = vim.fn.expand("<cfile>")
    if word == "" then word = vim.fn.expand("<cWORD>") end
    if word == "" then return end
    local path = word:gsub("^file://", "")
    vim.cmd("edit " .. vim.fn.fnameescape(path))
end, { desc = "Open file URI in neovim" })

vim.keymap.set({ 'n', 't' }, '<leader>fa', function()
    local word = vim.fn.expand("<cfile>")
    if word == "" then word = vim.fn.expand("<cWORD>") end
    if word == "" then return end
    local path = word:gsub("^file://", "")
    require("fzf-lua").files({ cwd = vim.fn.fnamemodify(path, ":h"), query = vim.fn.fnamemodify(path, ":t") })
    -- if vim.fn.isdirectory(path) == 1 then
    --     require("fzf-lua").files({ cwd = path })
    -- elseif vim.fn.filereadable(path) == 1 then
    --     require("fzf-lua").files({ cwd = vim.fn.fnamemodify(path, ":h"), query = vim.fn.fnamemodify(path, ":t") })
    -- else
    --     open_in_browser(word)
    -- end
end, { desc = "Open file URI via fzf-lua (or URL in browser)" })
-- --------------------------------------- end: open in browser ---------------------------------------

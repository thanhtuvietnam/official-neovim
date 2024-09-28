return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
    },
  },

  -- animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- filename
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = false,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
 _____                                                                          _____ 
( ___ )------------------------------------------------------------------------( ___ )
 |   |                                                                          |   | 
 |   | ████████╗██╗   ██╗██╗     ███████╗██████╗     ██╗     ██╗   ██╗██╗   ██╗ |   | 
 |   | ╚══██╔══╝╚██╗ ██╔╝██║     ██╔════╝██╔══██╗    ██║     ██║   ██║██║   ██║ |   | 
 |   |    ██║    ╚████╔╝ ██║     █████╗  ██████╔╝    ██║     ██║   ██║██║   ██║ |   | 
 |   |    ██║     ╚██╔╝  ██║     ██╔══╝  ██╔══██╗    ██║     ██║   ██║██║   ██║ |   | 
 |   |    ██║      ██║   ███████╗███████╗██║  ██║    ███████╗╚██████╔╝╚██████╔╝ |   | 
 |   |    ╚═╝      ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝  ╚═════╝  |   | 
 |___|                                                                          |___| 
(_____)------------------------------------------------------------------------(_____)
]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
  --cursorline
  {
    "yamatsum/nvim-cursorline",
    -- enabled = false,
    opts = {
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
      cursorline = {
        enable = true,
      },
    },
  },
  -- Visually display indent levels
  {
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
    dependencies = {
      "nmac427/guess-indent.nvim",
      "HiPhish/rainbow-delimiters.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    main = "ibl",
    event = "LazyFile",
    opts = function()
      LazyVim.toggle.map("<leader>ue", {
        name = "Indention Guides",
        get = function()
          return require("ibl.config").get_config(0).enabled
        end,
        set = function(state)
          require("ibl").setup_buffer(0, { enabled = state })
        end,
      })
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
        "CursorColumn",
        "Whitespace",
      }

      local hooks = require("ibl.hooks")

      -- Tạo nhóm highlight
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      return {
        indent = {
          -- See more characters at :h ibl.config.indent.char
          char = "│", -- ▏│
          tab_char = "│",
          -- char = "┊",
          -- tab_char = "┊",
          smart_indent_cap = true,
          -- highlight = highlight,
          -- char = "",
        },
        whitespace = {
          remove_blankline_trail = false,
          -- highlight = highlight,
        },

        scope = { show_exact_scope = true, highlight = highlight, show_start = true, show_end = true, enabled = true },
        exclude = {
          filetypes = {
            "alpha",
            "checkhealth",
            "dashboard",
            "git",
            "gitcommit",
            "help",
            "lazy",
            "lazyterm",
            "lspinfo",
            "man",
            "mason",
            "neo-tree",
            "notify",
            "Outline",
            "TelescopePrompt",
            "TelescopeResults",
            "terminal",
            "toggleterm",
            "Trouble",
          },
        },
      }
    end,
  },
  -- Visualize and operate on indent scope
  {
    "echasnovski/mini.indentscope",
    event = "LazyFile",
    opts = function(_, opts)
      opts.symbol = "│" -- ▏│
      opts.options = { try_as_border = false }
      opts.draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "lazyterm",
          "man",
          "mason",
          "neo-tree",
          "notify",
          "Outline",
          "toggleterm",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b["miniindentscope_disable"] = true
        end,
      })
    end,
  },
}

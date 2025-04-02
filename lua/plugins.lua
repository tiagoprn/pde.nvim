local function tbl_index(list, value)
  for k, v in pairs(list) do
    if v == value then
      return k
    end
  end
  return -1
end

local kind_priority = vim.tbl_map(function(i)
  return tbl_index(vim.lsp.protocol.CompletionItemKind, i)
end, {
  "Snippet",
  "Method",
  "Function",
  "Constructor",
  "Field",
  "Variable",
  "Class",
  "Interface",
  "Module",
  "Property",
  "Unit",
  "Value",
  "Enum",
  "Keyword",
  "Color",
  "Reference",
  "EnumMember",
  "Constant",
  "Struct",
  "Event",
  "Operator",
  "TypeParameter",
  "Folder",
  "File",
  "Text",
})

require("lazy").setup({
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },

  -- Install to improve performance of sorting on telescope
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },

  -- Buffer manager that has an UI similar to harpoon
  { "j-morano/buffer_manager.nvim" },

  -- quickfix persistance - save/load
  {
    "brunobmello25/persist-quickfix.nvim",
    opts = {
      storage_dir = vim.fn.stdpath("data") .. "/persist-quickfix",
      selector = function(items, callback)
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local previewers = require("telescope.previewers")

        -- Custom previewer using jq
        local jq_previewer = previewers.new_termopen_previewer({
          get_command = function(entry)
            -- You can customize the jq command here

            -- For example, to pretty-print the entire file:
            -- return { "jq", ".", entry.path }

            -- Or to extract specific fields:
            -- local jq_query = ".[] | {filepath: .filepath, lnum: .lnum, col: .col, text: .text}"
            local jq_query = '.[] | "\\(.filepath):\\(.lnum):\\(.col): \\(.text)"'
            return { "jq", jq_query, entry.path }
          end,
        })

        pickers
          .new({}, {
            prompt_title = "Quickfix Lists",
            finder = finders.new_table({
              results = items,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry,
                  ordinal = entry,
                  path = vim.fn.stdpath("data") .. "/persist-quickfix/" .. entry,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            previewer = jq_previewer,
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                callback(selection.value)
              end)
              return true
            end,
          })
          :find()
      end,
    },
  },

  -- Makes vim.ui.select and vim.ui.input prettier
  { "stevearc/dressing.nvim" },

  -- Useful to create custom telescope pickers
  { "axkirillov/easypick.nvim", dependencies = "nvim-telescope/telescope.nvim" },

  -- Sets vim.ui.select to telescope
  { "nvim-telescope/telescope-ui-select.nvim" },

  -- Imports on a project
  { "piersolenski/telescope-import.nvim" },

  -- Surround text with pairs of characters
  { "kylechui/nvim-surround" },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    -- Improved LuaSnip configuration with better error handling and debugging
    config = function()
      local ls = require("luasnip")

      -- LOAD SNIPPETS from ~/.config/nvim/lua/snippets/<filetype>/*.lua
      -- 1) We'll grab all .lua files under `lua/snippets/**` (including subfolders).
      local snippet_files = vim.fn.globpath(
        vim.fn.stdpath("config") .. "/lua/snippets",
        "**/*.lua", -- '**/*.lua' means "search subdirectories for .lua files"
        false,
        true
      )

      -- 2) Prepare a table to accumulate all snippets, grouped by filetype.
      local filetype_snippets = {}

      -- Debug: Print the number of snippet files found
      vim.notify("Found " .. #snippet_files .. " snippet files")

      for _, file in ipairs(snippet_files) do
        -- vim.notify("Processing file: " .. file)

        -- Safely load the snippet file
        local ok, snippet_data = pcall(dofile, file)

        if not ok then
          -- If there was an error loading the file, notify the user
          vim.notify("Error loading snippet file: " .. file .. "\nError: " .. snippet_data, vim.log.levels.ERROR)
        else
          -- Debug: Print the filetypes found in this file
          local filetypes = {}
          for ft, _ in pairs(snippet_data) do
            table.insert(filetypes, ft)
          end
          -- vim.notify("Found filetypes in " .. file .. ": " .. table.concat(filetypes, ", "))

          -- Add snippets from this file to their respective filetypes
          for ft, snippets_for_ft in pairs(snippet_data) do
            filetype_snippets[ft] = filetype_snippets[ft] or {}

            -- Debug: Print the number of snippets for this filetype
            -- vim.notify("Adding " .. #snippets_for_ft .. " snippets for filetype: " .. ft)

            vim.list_extend(filetype_snippets[ft], snippets_for_ft)
          end
        end
      end

      -- 3) Now load them into LuaSnip
      for ft, snippets in pairs(filetype_snippets) do
        ls.add_snippets(ft, snippets)
        vim.notify("Loaded " .. #snippets .. " snippets for filetype: " .. ft)
      end

      -- KEYBINDINGS
      -- -- jump in snippets
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump() -- Fixed: Was calling wrong function
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", true)
        end
      end, { silent = true })

      -- -- cycle through choices with Ctrl+e
      vim.keymap.set("i", "<C-e>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      -- Add command to reload snippets
      vim.api.nvim_create_user_command("SnippetsReload", function()
        require("luasnip").cleanup()
        vim.notify("Reloading snippets...")
        -- Call your snippet loading logic again
        -- This is a simplified version, you might need to adapt it
        for _, file in ipairs(snippet_files) do
          local ok, snippet_data = pcall(dofile, file)
          if ok then
            for ft, snippets_for_ft in pairs(snippet_data) do
              ls.add_snippets(ft, snippets_for_ft)
            end
          end
        end
        vim.notify("Snippets reloaded!")
      end, {})
    end,
  },

  -- Macros persistence
  { "chamindra/marvim" },

  -- Run commands asynchronously
  { "skywind3000/asyncrun.vim" },

  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("flow").setup({
        transparent = true, -- Set transparent background.
        fluo_color = "pink", --  Fluo color: pink, yellow, orange, or green.
        mode = "bright", -- Intensity of the palette: normal, bright, desaturate, or dark. Notice that dark is ugly!
        aggressive_spell = false, -- Display colors for spell check.
      })

      vim.cmd("colorscheme flow")
    end,
  },
  -- Icons
  { "kyazdani42/nvim-web-devicons" },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
  },

  -- -- Markdown syntax highlighting
  -- {
  --   "plasticboy/vim-markdown",
  --   dependencies = "godlygeek/tabular",
  -- },

  -- markdown editting and view support
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },

  -- obsidian
  {
    "obsidian-nvim/obsidian.nvim", -- community-maintained fork of "epwalsh/obsidian.nvim"
    -- version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- only want to load obsidian.nvim for markdown files in your vault:
    event = {
      "BufReadPre /storage/src/codex/*.md",
      "BufNewFile /storage/src/codex/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- UI component library
  { "MunifTanjim/nui.nvim" },

  -- File explorer
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = "kyazdani42/nvim-web-devicons",
  },

  -- Alternative file explorer (oil)
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },

  -- Beautiful and customizable indentation
  { "Yggdroot/indentLine" },

  -- Commenting utility
  { "numToStr/Comment.nvim" },

  -- Show contents of vim registers on a sidebar (removed, this plugin causes bugs when dealing with normal windows)
  -- { "junegunn/vim-peekaboo" },

  -- Auto pairs
  { "windwp/nvim-autopairs" },

  -- Session manager
  {
    "jedrzejboczar/possession.nvim",
    -- commit = "46dd09d9d4bf95665eb05286f8fccc0093b10035", -- NOTE: froze because this plugin broke after update on 2024-06-11
    event = "BufReadPre",
    cmd = { "PossessionLoad", "PossessionList" },
    keys = {
      {
        "<leader>Sl",
        function()
          require("telescope").extensions.possession.list()
        end,
        desc = "List Sessions",
      },
      {
        "<leader>Ss",
        function()
          -- Get the current working directory
          local cwd = vim.fn.getcwd()
          -- Extract the root directory from the CWD
          local root_dir = cwd:match("([^/]+)$")
          -- Get the current timestamp
          local timestamp = os.date("%Y%m%d-%H%M%S")
          -- Get user input for the session name
          local input = vim.fn.input("Enter the session name: ")
          -- Check if the user provided an input
          if input ~= "" then
            -- Concatenate root directory with timestamp and user input as the session name
            local session_name = root_dir .. "." .. timestamp .. "." .. input

            -- Save the session with the new name
            require("possession.session").save(session_name)
          else
            print("No input provided.")
          end
        end,
        desc = "Save Session",
      },
    },
    opts = {
      telescope = {
        list = {
          default_action = "load",
          mappings = {
            delete = { n = "d", i = "<c-d>" },
            rename = { n = "r", i = "<c-r>" },
          },
        },
      },
    },
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim" },

  -- Support for Hugo template language (Go)
  { "fatih/vim-go" },

  -- Highlight colors
  -- (highlight colors in neovim with the real color)
  { "brenoprata10/nvim-highlight-colors" },

  -- Zen mode (allows zooming on a buffer)
  { "folke/zen-mode.nvim" },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },

  -- -- Create custom commands to be triggered on telescope
  -- { "arjunmahishi/flow.nvim" },

  -- Fancy cursor to show current line
  { "gen740/SmoothCursor.nvim" },

  -- Mind mapping
  { "phaazon/mind.nvim", branch = "master" },

  -- Enhanced UI notifications
  { "folke/noice.nvim" },

  -- Keybindings helper
  { "folke/which-key.nvim" },

  -- Git blame
  { "FabijanZulj/blame.nvim" },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
      { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  },

  -- ChatGPT
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt-conf").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- AI: clause, chatgpt
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- set this if you want to always pull the latest change
  --   opts = {
  --     mappings = {
  --       ask = "<leader>aia", -- ask
  --       edit = "<leader>aie", -- edit
  --       refresh = "<leader>air", -- refresh
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --   },
  -- },

  {
    "olimorris/codecompanion.nvim",
    -- version = "v12.13.3", -- pinning previous stable version here until a new release fixes https://github.com/olimorris/codecompanion.nvim/issues/1046
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- Custom hooks for this plugin (they are here because they only work after the plugin is loaded)
      -- reference: <https://codecompanion.olimorris.dev/usage/events>

      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionInline*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionInlineFinished" then
            -- Format the buffer after the inline request has completed
            -- require("conform").format({ bufnr = request.buf })
            print("CodeCompanion: Inline request has completed")
          end
        end,
      })

      -- Create a global table to store conversation IDs if it doesn't exist
      if not _G.codecompanion_conversations then
        _G.codecompanion_conversations = {}
      end

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            print("Sending request to AI...")
          end
          if request.match == "CodeCompanionRequestFinished" then
            print("AI responded.")

            -- This implementation:
            --
            -- 1. Creates a global table to track conversation IDs across buffer numbers
            -- 2. When a new conversation starts in a buffer, it generates a unique ID using:
            --    - Buffer number
            --    - Process ID (to distinguish between different Vim instances)
            --    - Timestamp (for additional uniqueness)
            -- 3. Reuses the same conversation ID for subsequent responses in the same buffer
            -- 4. Saves all interactions from the same conversation to the same file
            -- 5. Checks `request.data.strategy` and skips saving if it's not a full "chat" (e.g. inline mode)
            -- 6. Adds an additional check to see if the buffer has meaningful content:
            --    - Skips empty buffers
            --    - Skips buffers that only contain metadata without actual conversation
            -- 7. Only proceeds with saving if there's a real chat conversation to save
            --
            -- This approach ensures:
            -- - Each conversation has a truly unique ID even across different Vim sessions
            -- - All interactions within the same conversation are saved to the same file
            -- - The file is updated with each new response

            -- Skip inline chats - only process full chat conversations
            if request.data.strategy ~= "chat" then
              print("Skipping save for inline chat")
              return
            end

            -- Check if the buffer has content before saving
            local current_buf = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
            local content = table.concat(lines, "\n")

            -- Skip if the buffer is empty or only contains metadata
            if content:match("^%s*$") or (content:match("^# CodeCompanion Chat") and not content:match("Human:")) then
              print("Skipping save for empty chat")
              return
            end

            -- Create the directory if it doesn't exist
            local save_dir = vim.fn.expand("$HOME/.local/share/nvim/code-companion-chat-history")
            if vim.fn.isdirectory(save_dir) == 0 then
              vim.fn.mkdir(save_dir, "p")
            end

            local bufnr = request.data.bufnr

            -- Check if we already have a conversation ID for this buffer
            if not _G.codecompanion_conversations[bufnr] then
              -- Generate a new conversation ID using buffer number and process ID
              local pid = vim.fn.getpid()
              -- Add formatted date timestamp as requested (YYYYMMDD-HHMMSS)
              local formatted_date = os.date("%Y%m%d-%H%M%S")
              _G.codecompanion_conversations[bufnr] = string.format("%s.buf%d.pid%d", formatted_date, bufnr, pid)
            end

            local conversation_id = _G.codecompanion_conversations[bufnr]

            -- Construct the filename
            local filename = save_dir .. "/codecompanion." .. conversation_id .. ".txt"

            -- Add metadata at the top of the file
            local metadata = string.format(
              "# CodeCompanion Chat\n# Date: %s\n# Model: %s\n# Buffer: %d\n# Conversation ID: %s\n\n",
              os.date("%Y-%m-%d %H:%M:%S"),
              request.data.adapter.model,
              bufnr,
              conversation_id
            )
            content = metadata .. content

            -- Write to file
            local file = io.open(filename, "w")
            if file then
              file:write(content)
              file:close()
              print("Chat saved to: " .. filename)
            else
              print("Error: Could not save chat history")
            end
          end
        end,
      })
    end,
  },

  -- LANGUAGE SERVERS - begin
  -- Handles automatically launching and initializing language servers installed on your system
  { "neovim/nvim-lspconfig", dependencies = { "saghen/blink.cmp" } },

  -- Nice UIs for LSP functions
  { "glepnir/lspsaga.nvim", after = "nvim-lspconfig" },

  -- LSP diagnostics and code actions
  { -- originally "jose-elias-alvarez/null-ls.nvim"
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Treesitter playground
  { "nvim-treesitter/playground" },

  -- Treesitter context
  { "nvim-treesitter/nvim-treesitter-context" },

  -- Text Objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Completion
  -- {
  --   -- "hrsh7th/nvim-cmp",
  --   "iguanacucumber/magazine.nvim", -- this is a more supported "fork of nvim-cmp"
  --   name = "nvim-cmp", -- Otherwise highlighting gets messed up
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-nvim-lsp-signature-help",
  --     "dcampos/cmp-snippy",
  --   },
  -- },
  --
  -- -- CMP source to complete filesystem paths
  -- { "hrsh7th/cmp-path" },
  {
    "saghen/blink.cmp",
    dependencies = {
      "onsails/lspkind.nvim",
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "default" },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = {
          auto_show = true,
          window = {
            border = "double",
            max_width = math.floor(vim.o.columns * 0.7),
            max_height = math.floor(vim.o.lines * 0.7),
          },
        },
        menu = { -- https://cmp.saghen.dev/recipes#nvim-web-devicons-lspkind
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local lspkind = require("lspkind")
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = {
          "lazydev",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "obsidian",
          "obsidian_new",
          "obsidian_tags",
          "cmdline",
          "codecompanion",
          "omni",
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },

      snippets = { preset = "luasnip" },

      signature = {
        enabled = true,
        window = {
          border = "double",
          max_width = math.floor(vim.o.columns * 0.7),
          max_height = math.floor(vim.o.lines * 0.7),
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function()
          return 0
        end,
        sorts = {
          "exact",
          "score",
          function(a, b)
            return tbl_index(kind_priority, a.kind) < tbl_index(kind_priority, b.kind)
          end,
          function(a, b)
            return #a.label < #b.label
          end,
          "sort_text",
        },
      },
    },
    opts_extend = { "sources.default" },
  },

  -- Code navigation through classes, methods and functions
  { "stevearc/aerial.nvim" },

  -- Automatically creates missing LSP diagnostics highlight groups for
  -- color schemes that don't yet support the builtin LSP client
  { "folke/lsp-colors.nvim" },

  -- Go to definition on floating window
  { "rmagatti/goto-preview" },

  -- Lua development environment
  { "justinsgithub/wezterm-types" },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Include the Neovim runtime APIs
        "luvit-meta/library",
        -- Include these standard libraries
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- Include your installed plugins
        "lazy.nvim",
        "nvim-dap-ui",
        -- Automatically load any plugin you're developing
        -- vim.fn.expand("~/projects/my-plugin"),
      },
      -- These integrations are important
      integrations = {
        -- Make sure lspconfig integration is enabled
        lspconfig = true,
        -- Enable blink.cmp integration if you're using it
        ["blink.cmp"] = true,
      },
      -- This ensures lazydev is always active for Lua files
      enabled = true,
    },
  },

  -- DEBUGGING
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
  },

  -- REPL
  { "rafcamlet/nvim-luapad" },
  -- LANGUAGE SERVERS - end
})

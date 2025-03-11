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
  { "dcampos/nvim-snippy" },

  -- Macros persistence
  { "chamindra/marvim" },

  -- Run commands asynchronously
  { "skywind3000/asyncrun.vim" },

  -- Color schemes
  -- {
  -- 	"catppuccin/nvim",
  -- 	name = "catppuccin",
  -- },
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

  -- bookmarks (use instead of marks, better UX and supports annotating on the lines)
  {
    "EvWilson/spelunk.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- For window drawing utilities
      "nvim-telescope/telescope.nvim", -- Optional: for fuzzy search capabilities
    },
  },

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
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
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
  { "neovim/nvim-lspconfig" },

  -- Nice UIs for LSP functions
  { "glepnir/lspsaga.nvim", after = "nvim-lspconfig" },

  -- LSP diagnostics and code actions
  { "nvimtools/none-ls.nvim" }, -- originally "jose-elias-alvarez/null-ls.nvim"

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
  {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim", -- this is a more supported "fork of nvim-cmp"
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "dcampos/cmp-snippy",
    },
  },

  -- CMP source to complete filesystem paths
  { "hrsh7th/cmp-path" },

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
    -- The plugin below was changed because folke/neodev.nvim is now
    -- deprecated.
    -- I still have that old plugin's configuration on "lua-lsp.lua",
    -- case I need to get any config from there
    -- (e.g. lua-language-server full path)
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Library paths can be absolute
        -- "~/projects/my-awesome-lib",
        -- Or relative, which means they will be resolved from the plugin dir.
        "lazy.nvim",
        "luvit-meta/library",
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        -- always load the LazyVim library
        "LazyVim",
        -- Only load the lazyvim library when the `LazyVim` global is found
        { path = "LazyVim", words = { "LazyVim" } },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `justinsgithub/wezterm-types` to be installed
        { path = "wezterm-types", mods = { "wezterm" } },
      },
      -- always enable unless `vim.g.lazydev_enabled = false`
      -- This is the default
      enabled = function(root_dir)
        return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
      end,
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  },

  -- REPL
  { "rafcamlet/nvim-luapad" },
  -- LANGUAGE SERVERS - end
})

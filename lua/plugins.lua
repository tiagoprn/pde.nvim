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
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},

	-- Icons
	{ "kyazdani42/nvim-web-devicons" },

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
	},

	-- Markdown syntax highlighting
	{
		"plasticboy/vim-markdown",
		dependencies = "godlygeek/tabular",
	},

	-- Notifications
	{ "rcarriga/nvim-notify" },

	-- UI component library
	{ "MunifTanjim/nui.nvim" },

	-- File explorer
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = "kyazdani42/nvim-web-devicons",
	},

	-- Beautiful and customizable indentation
	{ "Yggdroot/indentLine" },

	-- Commenting utility
	{ "numToStr/Comment.nvim" },

	-- Show contents of vim registers on a sidebar
	{ "junegunn/vim-peekaboo" },

	-- Auto pairs
	{ "windwp/nvim-autopairs" },

	-- Session manager
	{ "Shatur/neovim-session-manager" },

	-- Git signs
	{ "lewis6991/gitsigns.nvim" },

	-- Support for Hugo template language (Go)
	{ "fatih/vim-go" },

	-- Highlight colors
	{ "brenoprata10/nvim-highlight-colors" },

	-- Zen mode (allows zooming on a buffer)
	{ "folke/zen-mode.nvim" },

	-- TODO comments
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
	},

	-- Create custom commands to be triggered on telescope
	{ "arjunmahishi/flow.nvim" },

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

	-- AI
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
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
		"hrsh7th/nvim-cmp",
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
	{ "folke/neodev.nvim" },

	-- REPL
	{ "rafcamlet/nvim-luapad" },
	-- LANGUAGE SERVERS - end
})

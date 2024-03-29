-- To more advanced package configuration: https://github.com/wbthomason/packer.nvim#quickstart
-- (on this link there also information on how to install lua rocks (packages))

return require("packer").startup(function(use)
	-- Packer can manage itself
	use({ "wbthomason/packer.nvim" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
	})

	-- Install to improve performance of sorting on telescope
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	-- bookmark files on project and navigate quickly between them. Also run
	-- commands on tmux pane without leaving nvim.
	use({ "ThePrimeagen/harpoon" })

	-- Buffer manager that has an UI similar to harpoon
	use({ "j-morano/buffer_manager.nvim" })

	-- Makes vim.ui.select and vim.ui.input prettier
	use({ "stevearc/dressing.nvim" })

	-- useful to create custom telescope pickers
	use({ "axkirillov/easypick.nvim", requires = "nvim-telescope/telescope.nvim" })

	-- sets vim.ui.select to telescope
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	-- imports on a project
	use({ "piersolenski/telescope-import.nvim" })

	use({ "kylechui/nvim-surround" })

	-- snippets
	use({ "dcampos/nvim-snippy" })

	-- macros persistance
	use({ "chamindra/marvim" })

	-- run commands asynchronously
	use({ "skywind3000/asyncrun.vim" })

	-- color schemes
	-- the one below support the treesitter markdown plugin with its highlight group colors:
	-- https://www.reddit.com/r/neovim/comments/rg97j4/treesitter_for_markdown/hoktehq/?utm_medium=android_app&utm_source=share&context=3
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})

	use({ "kyazdani42/nvim-web-devicons" })

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- markdown syntax highlighting
	use({
		"plasticboy/vim-markdown",
		requires = { "godlygeek/tabular" },
	})

	-- vim-notify
	use({ "rcarriga/nvim-notify" })

	-- nui
	use({ "MunifTanjim/nui.nvim" })

	-- A tree project view
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Beautiful and customizable indentation
	use({ "Yggdroot/indentLine" })

	-- Comment
	use({ "numToStr/Comment.nvim" })

	-- show contents of vim registers on a sidebar
	use({ "junegunn/vim-peekaboo" })

	-- auto pairs
	use({ "windwp/nvim-autopairs" })

	-- session manager
	use({ "Shatur/neovim-session-manager" })

	-- gitsigns
	use({ "lewis6991/gitsigns.nvim" })

	-- support for hugo template language (go)
	use({ "fatih/vim-go" })

	-- highlight colors
	use({ "brenoprata10/nvim-highlight-colors" })

	-- zen mode (allows zooming on a buffer)
	use({ "folke/zen-mode.nvim" })

	use({
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	})

	-- create custom commands to be triggered on telescope
	use({ "arjunmahishi/flow.nvim" })

	-- fancy cursor to show current line
	use({ "gen740/SmoothCursor.nvim" })

	use({ "anuvyklack/hydra.nvim" })

	use({ "phaazon/mind.nvim", branch = "master" })

	use({ "folke/noice.nvim" })

	use({ "folke/which-key.nvim" })

	-- # AI

	use({
		"CamdenClark/flyboy",
	})

	use({
		"jackMort/ChatGPT.nvim",
		requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	})

	use({
		"olimorris/codecompanion.nvim",
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
	})

	-- # LANGUAGE SERVERS - begin

	-- --  handles automatically launching and initializing language servers installed on your system
	use({ "neovim/nvim-lspconfig" })

	-- -- nice UIs for LSP functions
	-- unsupported
	use({ "glepnir/lspsaga.nvim", after = "nvim-lspconfig" })

	use({ "nvimtools/none-ls.nvim" }) -- originally "jose-elias-alvarez/null-ls.nvim"

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use({
		"nvim-treesitter/playground",
		-- run = ":TSInstall query",
	})

	use({ "nvim-treesitter/nvim-treesitter-context" })

	-- Text Objects (to do operations like select/change/delete inside/around functions, classes, etc...)
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	-- -- enable LSP completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"dcampos/cmp-snippy",
		},
	})

	-- -- -- cmp source to complete filesystem paths
	use({ "hrsh7th/cmp-path" })

	-- -- code navigation through classes, methods and functions
	use({ "stevearc/aerial.nvim" })

	-- -- Automatically creates missing LSP diagnostics highlight groups for
	-- -- color schemes that don't yet support the builtin LSP client
	use({ "folke/lsp-colors.nvim" })

	-- -- go to definition on floating window
	use({ "rmagatti/goto-preview" })

	-- -- on insert mode, pressing tab on the first column
	-- -- will put the cursor on the right indentation.
	use({ "VidocqH/auto-indent.nvim" })

	-- -- lua development environment
	use({ "folke/neodev.nvim" })

	-- -- -- repl
	use({ "rafcamlet/nvim-luapad" })

	-- # LANGUAGE SERVERS - end
end)

-- This plugin was originally "jose-elias-alvarez/null-ls.nvim"
-- It was then forked to "nvimtools/none-ls.nvim", but preserving the previous namespaces to not break existing configs.

-- buitin sources:
--   <https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md>

-- Documentation on how to setup the builtin sources (formatters, linters, completion), like the ones below:
--   <https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md>

-- How to configure "formatting on save":
--   <https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save>

local null_ls = require("null-ls")

local helpers = require("tiagoprn.helpers")

local project_root = vim.fn.getcwd()

local my_custom_source_handler_02 = function(params)
  -- reference: https://www.youtube.com/watch?v=q-oBU1fO1H4
  local out = {}

  -- get current line where it has the string "amazing" - the params var has many other
  -- things like current column, cursor position, etc
  -- (https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md#params):

  if params.content[params.row]:match("amazing") then
    table.insert(out, {
      title = "test",
      action = function()
        print("hello")
      end,
    })
  end

  return out
end

local my_custom_source_02 = {
  name = "my-custom-source",
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "txt", "md" },
  generator_opts = { handler = my_custom_source_handler_02 },
  generator = { fn = my_custom_source_handler_02 },
}

null_ls.register(my_custom_source_02)

local my_custom_source_handler_01 = function(params)
  -- reference: https://www.youtube.com/watch?v=q-oBU1fO1H4
  local out = {}

  -- get current line where it has the string "amazing" - the params var has many other
  -- things like current column, cursor position, etc
  -- (https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md#params):

  table.insert(out, {
    title = "test",
    action = function()
      print("hello")
    end,
  })

  return out
end

local my_custom_source_01 = {
  name = "my-custom-source-01",
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "txt", "md" },
  generator_opts = { handler = my_custom_source_handler_01 },
  generator = { fn = my_custom_source_handler_01 },
}

null_ls.register(my_custom_source_01)

local sources = {
  my_custom_source_01,

  -- DIAGNOSTICS (LINTERS)

  null_ls.builtins.diagnostics.pylint.with({
    condition = function(utils)
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

      local filetype = vim.bo.filetype
      if filetype ~= "python" then
        return false
      end

      local trigg_pylint_file = project_root .. "/" .. "trigg-pylint"
      local trigg_pylint_file_exists = helpers.get_file_exists(trigg_pylint_file)
      if trigg_pylint_file_exists == false then
        vim.cmd('echomsg "trigg-pylint file NOT found on project root, pylint will be disabled for this file."')
        return false
      else
        vim.cmd('echomsg "trigg-pylint file found on project root, so pylint will be enabled for this file."')
        return true
      end
    end,
    command = function()
      local default_venv = "~/.pyenv/versions/neovim"

      local current_venv = vim.env.VIRTUAL_ENV

      local venv = ""

      if current_venv then
        venv = current_venv
        vim.cmd('echomsg "Current VENV defined as ' .. current_venv .. '"')
      else
        venv = default_venv
        vim.cmd('echomsg "Current VENV NOT defined, using default (' .. default_venv .. ')"')
      end

      local path = vim.fn.expand(venv .. "/bin/pylint")
      -- print("Current virtualenv is " .. venv)
      -- print("Current path is " .. path)

      return path
    end,
    extra_args = function()
      local pylintrc_file = ".pylintrc"
      local default_pylintrc = "/storage/src/devops/python/default_configs/.pylintrc"
      local project_root = vim.fn.getcwd()
      local pylintrc_full_path = project_root .. "/" .. pylintrc_file

      file_exists = helpers.get_file_exists(pylintrc_full_path)

      if file_exists == false then
        vim.cmd('echomsg "Could not find .pylintrc, using default one."')
        pylintrc_full_path = default_pylintrc
      end

      vim.cmd('echomsg "Using .pylintrc from: ' .. pylintrc_full_path .. '"')

      return {
        "--rcfile",
        pylintrc_full_path,
        "--score",
        "no",
        "--msg-template",
        "{path}:{line}:{column}:{C}:{msg}",
      }
    end,
  }),

  -- FORMATTERS

  null_ls.builtins.formatting.black.with({
    condition = function(utils)
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

      local filetype = vim.bo.filetype
      if filetype ~= "python" then
        return false
      end

      local trigg_black_file = project_root .. "/" .. "trigg-black"
      local trigg_black_file_exists = helpers.get_file_exists(trigg_black_file)
      if trigg_black_file_exists == false then
        vim.cmd('echomsg "trigg-black file found NOT on project root, black will be disabled for this file."')
        return false
      else
        vim.cmd('echomsg "trigg-black file found on project root, so black will be enabled for this file."')
        return true
      end
    end,
    command = function()
      local default_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/black")
      return default_path
    end,
    args = function()
      return { "--quiet", "-" }
    end,
    extra_args = function()
      return { "--line-length", "79", "--skip-string-normalization" }
    end,
  }),

  null_ls.builtins.formatting.isort.with({
    condition = function(utils)
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

      local filetype = vim.bo.filetype
      if filetype ~= "python" then
        return false
      end

      local trigg_isort_file = project_root .. "/" .. "trigg-isort"
      local trigg_isort_file_exists = helpers.get_file_exists(trigg_isort_file)
      if trigg_isort_file_exists == false then
        vim.cmd('echomsg "trigg-isort file NOT found on project root, isort will be disabled for this file."')
        return false
      else
        vim.cmd('echomsg "trigg-isort file found on project root, so isort will be enabled for this file."')
        return true
      end
    end,
    command = function()
      local default_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/isort")
      return default_path
    end,
    args = function()
      return { "--quiet", "-" }
    end,
    extra_args = function()
      return { "-m", "3", "--trailing-comma", "--use-parentheses", "honor-noqa" }
    end,
  }),

  -- null_ls.builtins.diagnostics.flake8.with({
  -- 	condition = function(utils)
  -- 		-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition
  --
  -- 		local filetype = vim.bo.filetype
  -- 		if filetype ~= "python" then
  -- 			return false
  -- 		end
  --
  -- 		local enable_flake8_file = project_root .. "/" .. "enable-flake8"
  -- 		local enable_flake8_file_exists = helpers.get_file_exists(enable_flake8_file)
  -- 		if enable_flake8_file_exists == true then
  -- 			vim.api.nvim_echo({{ "enable-flake8 file found on project root, so flake8 will be enabled for this file.", "WarningMsg" }}, true, {})
  -- 			return true
  -- 		else
  -- 			vim.api.nvim_echo({{ "enable-flake8 file NOT found on project root, so flake8 will be disabled for this file.", "WarningMsg" }}, true, {})
  -- 			return false
  -- 		end
  -- 	end,
  -- 	args = function()
  -- 		return { "--max-line-length", "160", "--format", "default", "--stdin-display-name", "$FILENAME", "-" }
  -- 	end,
  -- }),
  -- null_ls.builtins.diagnostics.shellcheck.with({
  --   command = "shellcheck",
  --   extra_args = { "-f", "gcc", "-x" },
  -- }),

  null_ls.builtins.formatting.shfmt.with({
    command = "shfmt",
    extra_args = { "-ci", "-s", "-bn", "-i", "4" },
  }),

  null_ls.builtins.formatting.stylua.with({
    command = vim.fn.expand("~/.cargo/bin/stylua"),
    extra_args = {
      "--column-width",
      "120",
      "--indent-type",
      "Spaces",
      "--indent-width",
      "2",
      "--quote-style",
      "AutoPreferDouble",
    },
  }),
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = sources,
  debug = false, -- "false" when finished debugging, "true" to inspect logs
  diagnostics_format = "[#{c}] #{m} (#{s})",
  update_in_insert = false,
  debounce = 3000, -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md#debounce-number

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 20000 })
        end,
      })
    end
  end,
})

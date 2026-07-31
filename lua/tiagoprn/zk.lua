-- zk notebook helpers.

local M = {}

local function close_window(buf, win)
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

function M.sync()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- same as goto-preview
  })

  -- Esc leaves terminal mode, q closes the float.
  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buf })
  vim.keymap.set("n", "q", function()
    close_window(buf, win)
  end, { buffer = buf, nowait = true })

  vim.fn.termopen({ "bash", "-lc", "zk f && zk w" }, {
    cwd = vim.fn.getcwd(-1), -- mirror :! window-local directory semantics
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("zk sync OK", vim.log.levels.INFO)
        else
          vim.notify("zk sync failed (exit " .. code .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
  vim.cmd("startinsert")
end

return M

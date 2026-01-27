local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local NuiTable = require("nui.table")
local Text = require("nui.text")

local M = {}

function M.sample_nui_form()
  local bufnr = 1
  local table_example = NuiTable({
    ns_id = "example_form",
    bufnr = bufnr,
    columns = {
      {
        align = "center",
        header = "Name",
        columns = {
          { accessor_key = "firstName", header = "First" },
          {
            id = "lastName",
            accessor_fn = function(row)
              return row.lastName
            end,
            header = "Last",
          },
        },
      },
      {
        align = "right",
        accessor_key = "age",
        cell = function(cell)
          return Text(tostring(cell.get_value()), "DiagnosticInfo")
        end,
        header = "Age",
      },
    },
    data = {
      { firstName = "John", lastName = "Doe", age = 42 },
      { firstName = "Jane", lastName = "Doe", age = 27 },
    },
  })

  table_example:render()
end

function M.popup_example()
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
  })

  -- mount/open the component
  popup:mount()

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  popup:on(event.InsertEnter, function()
    -- close current buffer
    vim.api.nvim_input("<ESC>:bd!<cr>")
  end)

  -- set the popup's content
  local text = [[
    Hello there!

    ---
    Press <i> to close this buffer.
  ]]

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, vim.split(text, "\n"))
end

function M.codecompanion_help()
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "30%",
      height = "30%",
    },
  })

  -- mount/open the component
  popup:mount()

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  popup:on(event.InsertEnter, function()
    -- close current buffer
    vim.api.nvim_input("<ESC>:bd!<cr>")
  end)

  -- set the popup's content
  local text = [[

    Save the buffer and trigger a response from the generative AI service.....: <C-s>
    Close the buffer..........................................................: <C-c>
    Cancel the stream from the API............................................: q
    Clear the buffer's contents...............................................: gc
    Add a codeblock...........................................................: ga
    Save the chat to disk.....................................................: gs
    Move to the next header...................................................: ]
    Move to the previous header...............................................: ]

    ---
    Press <i> to close this popup window.
  ]]

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, vim.split(text, "\n"))
end

return M

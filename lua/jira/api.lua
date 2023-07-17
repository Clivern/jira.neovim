--- Jira Module
local M = {}

local http = require("plenary.http")
local popup = require("plenary.popup")

function M.get_jira_tickets(token, domain)
  local headers = {
    ["Authorization"] = "Bearer " .. token,
    ["Content-Type"] = "application/json",
  }

  local url = "https://" .. domain .. "/rest/api/3/search"
  local params = {
    fields = "summary,description,issuetype",
    maxResults = 100,
  }

  local response = http.request({
    url = url,
    method = "GET",
    headers = headers,
    params = params,
  })

  if response.status == 200 then
    return vim.json.decode(response.body)
  else
    vim.notify("Failed to fetch Jira tickets", vim.log.levels.ERROR)
    return {}
  end
end

function M.show_tickets(tickets)
  local lines = {}
  for _, ticket in ipairs(tickets.issues) do
    table.insert(lines, ticket.fields.summary)
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  local winnr, bufnr = popup.create(bufnr, {
    title = "Jira Tickets",
    highlight = "Normal",
    border = "rounded",
    width = 60,
    height = 20,
    row = 5,
    col = 5,
  })

  -- Add mappings to close the window
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", { silent = true, nowait = true, noremap = true })
end

return M

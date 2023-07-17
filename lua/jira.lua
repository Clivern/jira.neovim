-- Jira Module
local curl = require("plenary.curl")
local popup = require("plenary.popup")

local M = {}

local config = {
  token = "",
  domain = "",
}

M.config = config

-- This function gets Jira tickets
local function get_jira_tickets(token, domain)
  local headers = {
    ["Authorization"] = "Bearer " .. token,
    ["Content-Type"] = "application/json",
  }

  local url = "https://" .. domain .. "/rest/api/3/search"
  local params = {
    fields = "summary,description,issuetype",
    maxResults = 100,
  }

  local response = curl.get(url, {
    headers = headers,
    query = params,
  })

  if response.status == 200 then
    return vim.json.decode(response.body)
  else
    vim.notify("Failed to fetch Jira tickets: " .. response.body, vim.log.levels.ERROR)
    return {}
  end
end

-- This function shows tickets
local function show_tickets(tickets)
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

-- Execute the plugin
local function execute(config)
  vim.api.nvim_create_user_command("Jira", function(opts)
    local token = config.token
    local domain = config.domain

    if not token or not domain then
      vim.notify("Please set Jira token and domain in your Neovim config", vim.log.levels.ERROR)
      return
    end

    local tickets = get_jira_tickets(token, domain)

    if next(tickets) ~= nil then
      show_tickets(tickets)
    end
  end, {})

  vim.notify("Jira plugin loaded")
end

M.setup = function(params)
  M.config = vim.tbl_extend("force", {}, M.config, params or {})
  execute(M.config)
end

return M

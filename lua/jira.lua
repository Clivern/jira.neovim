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

-- Mock function to simulate getting Jira tickets
local function mock_get_jira_tickets(token, domain)
  -- Mock data
  local mock_data = {
    issues = {
      {
        key = "PROJ-1",
        fields = {
          summary = "Implement new feature",
          description = "As a user, I want to be able to sort my tasks by priority",
          issuetype = { name = "Story" }
        }
      },
      {
        key = "PROJ-2",
        fields = {
          summary = "Fix login bug",
          description = "Users are unable to log in using social media accounts",
          issuetype = { name = "Bug" }
        }
      },
      {
        key = "PROJ-3",
        fields = {
          summary = "Update documentation",
          description = "Update the API documentation with the latest endpoints",
          issuetype = { name = "Task" }
        }
      }
    },
    total = 3
  }

  -- Simulate successful response
  if token ~= "" and domain ~= "" then
    return mock_data
  else
    -- Simulate error response
    vim.notify("Failed to fetch Jira tickets: Invalid token or domain", vim.log.levels.ERROR)
    return {}
  end
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

    local tickets = mock_get_jira_tickets(token, domain)

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

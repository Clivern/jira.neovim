local jira = require("jira")

vim.api.nvim_create_user_command("JiraTickets", function(opts)
  local token = vim.g.jira_token
  local domain = vim.g.jira_domain

  if not token or not domain then
    vim.notify("Please set jira_token and jira_domain in your Neovim config", vim.log.levels.ERROR)
    return
  end

  local tickets = jira.get_jira_tickets(token, domain)

  if next(tickets) ~= nil then
    jira.show_tickets(tickets)
  end
end, {})


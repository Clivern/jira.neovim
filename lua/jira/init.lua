local api = require("jira.api")

return {
  get_jira_tickets = api.get_jira_tickets,
  show_tickets = api.show_tickets,
}


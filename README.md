## Jira Neovim Plugin

A Neovim plugin to interact with Jira, allowing you to fetch and display Jira tickets directly within your editor.

### Features

- **Fetch Jira Tickets**: Easily retrieve a list of Jira tickets using your API token.
- **Display Tickets**: View ticket summaries in a popup window.
- **Customizable**: Configure your Jira API token and domain in your Neovim settings.

### Installation

#### Using Lazy.nvim

Add the following to your `init.lua`:

```lua
{
    "clivern/jira.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
}
```

### Configuration

To use this plugin, you need to set your Jira API token and domain in your Neovim configuration file (`init.lua`):

```lua
require("jira").setup({
    token = "your_jira_api_token"
    domain = "your_jira_domain.atlassian.net"
})
```

### Contributing

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

### License

This plugin is licensed under the MIT License.

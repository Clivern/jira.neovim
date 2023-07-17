## Jira Neovim Plugin

A Neovim plugin to interact with Jira, allowing you to fetch and display Jira tickets directly within your editor.

### Features

- **Fetch Jira Tickets**: Easily retrieve a list of Jira tickets using your API token.
- **Display Tickets**: View ticket summaries in a popup window.
- **Customizable**: Configure your Jira API token and domain in your Neovim settings.

### Installation

#### Using Packer

Add the following to your `init.lua`:

```lua
use {
  path = "/path/to/nvim-jira",
}
```

#### Using Lazy.nvim

Add the following to your `init.lua`:

```lua
{ path = "/path/to/nvim-jira" },
```

### Configuration

To use this plugin, you need to set your Jira API token and domain in your Neovim configuration file (`init.lua`):

```lua
vim.g.jira_token = "your_jira_api_token"
vim.g.jira_domain = "your_jira_domain.atlassian.net"
```

### Usage

1. Open Neovim.
2. Press `jt` to fetch and display your Jira tickets in a popup window.
3. You can close the popup by pressing `q`.

### Requirements

- Neovim
- `plenary.nvim` (automatically installed if using a plugin manager)

### Contributing

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

### License

This plugin is licensed under the MIT License.

## Tuk Neovim Plugin

A Set of Neovim modules to speed up development.

### Installation

#### Using Lazy.nvim

Add the following to your `init.lua`:

```lua
{
    "clivern/tuk.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "grapp-dev/nui-components.nvim",
            dependencies = {
                "MunifTanjim/nui.nvim"
            }
        }
    }
}
```

### Configuration

To enable workspaces module:

```lua
require("tspace").setup({
    config = "~/.tuk.json"
})
```

### Contributing

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

### License

This plugin is licensed under the MIT License.

# TestCover NeoVim Plugin
This plugin automatically runs the tests and shows the coverage in the gutter. If tests fail, the errors are shown.

## Installation
Use your favorite plugin manager to install this plugin. For example, with packer.nvim:
```lua
use "MatthijsSchuurman/testcover.nvim"
```

## Usage
To run the tests and show the coverage, use the command `:TestCover`. This will run the tests and show the coverage in the gutter.

### Configuration
The plugin can be configured by setting the following options:
```lua
require("packer").use({
  "~/.config/nvim/lua/testcover",
  config = function()
    require("testcover").setup({
      keymap = "<leader>tc", -- Keymap to run the tests
      display_coverage = true, -- Display the coverage in the gutter
      auto_run = true, -- Automatically run the tests when saving a file
    })
  end
})
```


## Language support
| Language | Test | Coverage |
|----------|------|----------|
| C        | No   | No       |
| Go       | Yes  | Yes      |
| Javascript| No   | No       |
| Lua      | No   | No       |
| Python   | No   | No       |

## License
This project is licensed under the terms of the [MIT license](LICENSE.md).

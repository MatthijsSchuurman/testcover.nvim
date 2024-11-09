local Config = {}

Config.defaults = {
    keymap = "<leader>tc",
    covered = {
        highlight = "Comment",
        sign = "✓"
    },
    uncovered = {
        highlight = "Error",
        sign = "✗"
    },
    display_coverage = true,
    auto_run = false,
}

Config.settings = {}

function Config.setup(user_config)
  Config.settings = vim.tbl_extend("force", Config.settings, Config.defaults, user_config or {})
end

return Config

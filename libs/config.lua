local Config = {}

Config.defaults = {
    keymap = "<leader>tc",
    display_coverage = true,
    auto_run = false,
}

Config.settings = {}

function Config.setup(userConfig)
  Config.settings = vim.tbl_extend("force", Config.settings, Config.defaults, userConfig or {})
end

return Config

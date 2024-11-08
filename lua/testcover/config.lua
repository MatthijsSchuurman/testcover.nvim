local Config = {}

Config.settings = { keymap = "<leader>rc" }

function Config.setup(user_config)
  Config.settings = vim.tbl_extend("force", Config.settings, user_config or {})
end

return Config

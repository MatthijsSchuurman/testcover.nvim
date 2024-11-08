local config = require("lua/testcover/config")
local test = require("lua/testcover/test")
local coverage = require("lua/testcover/coverage")
local visualiser = require("lua/testcover/visualiser")

local M = {}

function M.run()
  local test_results = test.run()
  local coverage_results = coverage.run(test_results)
  visualiser.gutter(coverage_results)
end

function M.setup(user_config)
  config.setup(user_config)
  vim.api.nvim_create_user_command("TestCover", M.run, { nargs = 0 })
  vim.api.nvim_set_keymap("n", config.settings.keymap, ":RunCoverage<CR>", { noremap = true, silent = true })
end

return M

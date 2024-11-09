local config = require("testcover.libs.config")
local test = require("testcover.libs/test")
local coverage = require("testcover.libs/coverage")
local visualiser = require("testcover.libs/visualiser")

local M = {}

function M.run()
  local test_results = test.run()
  local coverage_results = coverage.parse(test_results)

  if config.settings.display_coverage then
    visualiser.gutter(coverage_results)
  end
end

function M.setup(user_config)
  config.setup(user_config)

  vim.api.nvim_create_user_command("TestCover", M.run, { nargs = 0 })
  vim.api.nvim_set_keymap("n", config.settings.keymap, ":TestCover<CR>", { noremap = true, silent = true })

  if config.settings.auto_run then
    vim.cmd("autocmd BufWritePost * TestCover")
  end
end

return M

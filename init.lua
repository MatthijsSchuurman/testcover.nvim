local config = require("libs/config")
local test = require("libs/test")
local coverage = require("libs/coverage")
local visualiser = require("libs/visualiser")

local M = {}

function M.run()
  local test_results = test.run()
  local coverage_results = coverage.parse(test_results)

  if config.settings.display_coverage then
    visualiser.gutter(coverage_results)
  end
end

function M._test()
  require("plenary.test_harness").test_directory("libs/tests")
end

function M.setup(user_config)
  config.setup(user_config)

  vim.api.nvim_create_user_command("TestCover", M.run, { nargs = 0 })
  vim.api.nvim_set_keymap("n", config.settings.keymap, ":TestCover<CR>", { noremap = true, silent = true })

  if config.settings.auto_run then
    vim.cmd("autocmd BufWritePost * TestCover")
  end

  if config.settings._test_mode then -- This is a test mode of the plugin, so not the test mode of the user"s project
    vim.api.nvim_create_user_command("TestCoverTest", M._test, { nargs = 0 })
    vim.api.nvim_set_keymap("n", config.settings._test_keymap, ":TestCoverTest<CR>", { noremap = true, silent = true })
  end
end

M.setup({
  _test_mode = true,
})

return M

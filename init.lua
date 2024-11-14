local config = require("testcover.libs.config")
local test = require("testcover.libs.test")
local coverage = require("testcover.libs.coverage")
local visualiser = require("testcover.libs.visualiser")

local M = {}

function M.run()
  if vim.b.TestCoverFailed then -- skip if previous run failed
    return
  end

  local testResults, error = test.run()
  if error then
    vim.notify("TestCover failed: " .. error.message, "error")
    vim.b.TestCoverFailed = true
    return
  end

  visualiser.results(testResults.results, testResults.success)

  if config.settings.display_coverage then
    local coverageResults = coverage.parse(testResults.coverageFilename)
    visualiser.gutter(coverageResults)
  end
end

function M.loadCoverage()
  local coverageFilename = coverage.findCoverageFile()
  if coverageFilename then
    local coverageResults = coverage.parse(coverageFilename)
    visualiser.gutter(coverageResults)
  end
end

function M.setup(userConfig)
  config.setup(userConfig)
  visualiser.setup()

  vim.api.nvim_create_user_command("TestCover", M.run, { nargs = 0 })
  vim.api.nvim_set_keymap("n", config.settings.keymap, ":TestCover<CR>", { noremap = true, silent = true })

  if config.settings.auto_run then
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = test.getSupportedPattern(),
      callback = vim.schedule_wrap(M.run),
    })
  end

  if config.settings.display_coverage then
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = test.getSupportedPattern(),
      command = "lua require('testcover').loadCoverage()",
    })
  end



  -- Temporary test runner for plugin development
  vim.api.nvim_create_user_command("TestCoverTest", function()
    local currentFile = vim.api.nvim_buf_get_name(0)
    vim.cmd("PlenaryBustedFile " .. currentFile)
  end
  , { nargs = 0 })
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*_test.lua",
    command = "TestCoverTest",
  })




end

return M

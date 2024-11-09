local Test = {}

function Test.run()
  local file = vim.api.nvim_buf_get_name(0)
  local type = vim.api.nvim_buf_get_option(0, "filetype")
  local coverageFile = "coverage.out"

  if type == "go" then
    vim.api.nvim_command("!go test -coverprofile=" .. coverageFile)

    vim.notify("TestCover: Running tests for " .. file)
  else
    vim.notify("TestCover does not support filetype: " .. type)
  end

  return coverageFile
end

return Test

local Test = {}

function Test.run(filename)
  local coverageFile

  if type == "go" then
    coverageFile = "coverage.out"
    vim.api.nvim_command("!go test -coverprofile=" .. coverageFile)

    vim.notify("TestCover: Running tests for " .. file)
  else
    vim.notify("TestCover does not support filetype: " .. type)
  end

  return coverageFile
end

return Test

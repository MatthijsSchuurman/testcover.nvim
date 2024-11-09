local Test = {}

function Test.getFileType(filename)
  local ext = vim.fn.fnamemodify(filename, ":e")
  return string.lower(ext)
end

function Test.run(filename)
  local output, coverageFilename
  local type = Test.getFileType(filename)

  if type == "go" then
    coverageFilename = "coverage.out"

    local basedir = vim.fn.fnamemodify(filename, ":h")
    output = vim.fn.system("cd " .. basedir .. " && go test -v -coverprofile=" .. coverageFilename .. " .")
    coverageFilename = basedir .. "/" .. coverageFilename -- prepend basedir to get actual coverage file path

    if vim.v.shell_error ~= 0 then
      vim.notify("TestCover: Tests failed\n" .. output, "error")
    else
      vim.notify("TestCover: Tests passed")
    end
  else
    vim.notify("TestCover does not support filetype: " .. type)
  end

  return {
    type = type,
    output = output,
    coverageFilename = coverageFilename
  }
end

return Test

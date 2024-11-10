local Test = {}

function Test.getFileType(filename)
  local ext = vim.fn.fnamemodify(filename, ":e")
  return string.lower(ext)
end

function Test.run(filename)
  local r = {
    type,
    results,
    success,
    coverageFilename,
  }

  if not filename then -- if no filename is provided, use the current buffer
    filename = vim.fn.expand("%")
  end

  r.type = Test.getFileType(filename)
  if r.type == "go" then
    r.coverageFilename = vim.fn.getcwd() .. "/coverage.out"

    local basedir = vim.fn.fnamemodify(filename, ":h")
    r.results = vim.fn.system("cd " .. basedir .. " && go test -v -coverprofile=" .. r.coverageFilename .. " .")

    if vim.v.shell_error ~= 0 then
      r.success = false
    else
      r.success = true
    end
  else
    return nil, {
      type = "error",
      section = "Test.run",
      message = "Unsupported filetype",
      data = {
        filename = filename,
        type = r.type,
      }
    }
  end

  return r
end

return Test

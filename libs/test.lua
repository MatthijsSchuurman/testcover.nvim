local Test = {}

function Test.getSupportedPattern()
  return {"*.go"}
end

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

  if not string.match(filename, "_test") then -- code file, find test file
    local testFilename = string.gsub(filename, "%.(%w+)$", "_test.%1")
    if vim.fn.filereadable(testFilename) == 0 then
      local integrationTestFilename = string.gsub(filename, "%.(%w+)$", "_integration_test.%1")
      if vim.fn.filereadable(testFilename) == 0 then
        return nil, {
          type = "error",
          section = "Test.run",
          message = "Test file not found",
          data = {
            filename = filename,
            testFilename = testFilename,
            integrationTestFilename = integrationTestFilename,
          }
        }
      end
    end
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

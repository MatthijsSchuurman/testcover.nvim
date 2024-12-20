local Test = {}

function Test.getSupportedPattern()
  return {"*.go", "*.lua"}
end

function Test.getFileType(filename)
  local ext = vim.fn.fnamemodify(filename, ":e")
  return string.lower(ext)
end


function Test.getResultsFromPopup(marker, ms)
  local results = nil
  local start = vim.loop.now()

  while vim.loop.now() - start < ms do
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        local buf = vim.api.nvim_win_get_buf(win)
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local content = table.concat(lines, "\n")
        if content:find(marker) then
          results = content
          vim.api.nvim_win_close(win, true)
          break
        end
      end
    end

    if results then break end
    vim.wait(10)
  end

  return results
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

  local testFilename = filename
  if not string.match(testFilename, "_test") then -- code file, find test file
    testFilename = string.gsub(filename, "%.(%w+)$", "_test.%1")
    if(r.type == "lua") then -- replace filename_test.lua with tests/filename_test.lua
      testFilename = testFilename:gsub("([^/]+)$", "tests/%1")
    end

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

  if r.type == "go" then
    local basedir = vim.fn.fnamemodify(filename, ":h")
    r.coverageFilename = basedir .. "/coverage.out"

    r.results = vim.fn.system("cd " .. basedir .. " && go test -v -coverprofile=coverage.out .")

    if vim.v.shell_error ~= 0 then
      r.success = false
    else
      r.success = true
    end
  elseif r.type == "lua" then
    local test_harness = require("plenary.test_harness")
    test_harness.test_file(testFilename)

    r.results = Test.getResultsFromPopup("Testing:", 1000)

    if r.results:find("Fail  ") then
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

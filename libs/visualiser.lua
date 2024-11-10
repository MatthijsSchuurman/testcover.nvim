local Visualiser = {}

function Visualiser.gutter(coverageData)
  local currentFilename = vim.fn.expand("%")
  currentFilename = currentFilename:gsub("_test", "")
  -- Find file in coverage data
  local coverageFile
  for k, _ in pairs(coverageData) do
    if k:find(currentFilename) then
      coverageFile = k
      break
    end
  end

  if not coverageFile then
    return
  end

  vim.api.nvim_set_hl(0, "TestCoverTested", { fg = "green" })
  vim.api.nvim_set_hl(0, "TestCoverNotTested", { fg = "red" })
  vim.fn.sign_define("TestCoverTested", { text = "|", texthl = "TestCoverTested" })
  vim.fn.sign_define("TestCoverNotTested", { text = "|", texthl = "TestCoverNotTested" })

  for _, coverage in pairs(coverageData[coverageFile]) do
    for line = coverage.start.line, coverage.finish.line, 1 do
      local sign = coverage.tests > 0 and "TestCoverTested" or "TestCoverNotTested"
      vim.fn.sign_place(0, "TestCoverGutter", sign, currentFilename, { lnum = line })
    end
  end


end

function Visualiser.results(results, success)
  if success then
    vim.notify("TestCover: Tests passed", "info")
  else
    vim.notify("TestCover: Tests failed\n\n\n" .. results, "error")
  end
end

return Visualiser

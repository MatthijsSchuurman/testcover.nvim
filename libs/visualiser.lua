local Visualiser = {}

function Visualiser.gutter(coverageData)

end

function Visualiser.results(results, success)
  if success then
    vim.notify("TestCover: Tests passed", "info")
  else
    vim.notify("TestCover: Tests failed\n\n\n" .. results, "error")
  end
end

return Visualiser

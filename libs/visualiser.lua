local Visualiser = {}

function Visualiser.setup()
  vim.api.nvim_set_hl(0, "TestCoverCovered", { fg = "green" })
  vim.api.nvim_set_hl(0, "TestCoverNotCovered", { fg = "red" })
  vim.fn.sign_define("TestCoverCovered", { text = "▒", texthl = "TestCoverCovered" })
  vim.fn.sign_define("TestCoverNotCovered", { text = "▒", texthl = "TestCoverNotCovered" })
end

function Visualiser.findKey(hash, key)
  if hash[key] then
    return key
  end

  for k, _ in pairs(hash) do
    if k:find(key) then
      return k
    end
  end
end

function Visualiser.gutter(coverageData)
  local currentFilename = vim.fn.expand("%"):gsub("_sub", "")

  local coverageFile = Visualiser.findKey(coverageData, currentFilename)
  if not coverageFile then
    return
  end

  for _, coverage in pairs(coverageData[coverageFile]) do
    for line = coverage.start.line, coverage.finish.line, 1 do
      local sign = coverage.tests > 0 and "TestCoverCovered" or "TestCoverNotCovered"
      vim.fn.sign_place(0, "TestCoverGutter", sign, currentFilename, { lnum = line })
    end
  end
end

function Visualiser.results(results, success)
  if success then
    vim.notify("TestCover: Tests passed", "info")
  else
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = math.floor(vim.o.columns * 1.0),
      height = math.floor(vim.o.lines * 0.5),
      col = math.floor((vim.o.columns - math.floor(vim.o.columns * 1.0)) / 2),
      row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.5)) / 1),
      style = "minimal",
    })
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    local tmpfile = vim.fn.tempname()
    local file = io.open(tmpfile, "w")
    file:write(results)
    file:close()
    vim.fn.termopen("cat " .. tmpfile) --
  end
end

return Visualiser

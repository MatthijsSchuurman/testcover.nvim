local visualiser = require("testcover.libs.visualiser")

describe("Visualiser", function()
  it("should setup visualiser", function()
    -- Given

    -- When
    visualiser.setup()

    -- Then
    local value = vim.api.nvim_get_hl(0, { name = "TestCoverCovered" })
    assert.same({ fg = 32768 }, value)
    value = vim.api.nvim_get_hl(0, { name = "TestCoverNotCovered" })
    assert.same({ fg = 16711680 }, value)

    value = vim.fn.sign_getdefined("TestCoverCovered")
    assert.same("TestCoverCovered", value[1].texthl)
    value = vim.fn.sign_getdefined("TestCoverNotCovered")
    assert.same("TestCoverNotCovered", value[1].texthl)
  end)

  it("should find key in table", function()
    -- Given
    local table = {
      ["file.txt"] = "value1",
      ["sub/file.txt"] = "value2",
      ["sub/dir/file.txt"] = "value2",
    }

    -- When
    local result = visualiser.findKey(table, "file.txt")

    -- Then
    assert.equal("file.txt", result)

    -- When
    result = visualiser.findKey(table, "dir/file.txt")

    -- Then
    assert.equal("sub/dir/file.txt", result)

    -- When
    result = visualiser.findKey(table, "notfound.txt")

    -- Then
    assert.is_nil(result)
  end)

  it("should visualise coverage", function()
    -- Given
    local currentFile = vim.fn.expand("%")
    local coverageData = {
      [currentFile] = {
        {
          tests = 1,
          start = {
            line = 1,
          },
          finish = {
            line = 2,
          },
        },
        {
          tests = 0,
          start = {
            line = 3,
          },
          finish = {
            line = 5,
          },
        },
      },
    }

    -- When
    visualiser.gutter(coverageData)

    -- Then
    local value = vim.fn.sign_getplaced("%", { group = "TestCoverGutter" })
    assert.equal(5, #value[1].signs)
  end)

  it("should visualise test results", function()
    -- Given
    local testResults = {
      results = "PASS",
      success = true
    }

    -- When
    visualiser.results(testResults.results, testResults.success)

    -- Then
    -- Just check that the function does not throw an error
  end)

  it("should visualise test results with failure", function()
    -- Given
    local testResults = {
      results = "FAIL",
      success = false
    }

    -- When
    visualiser.results(testResults.results, testResults.success)

    -- Then
    -- Just check that the function does not throw an error
  end)

  it("should format test results", function()
    -- Given
    local testResults = "[0;32mPASS[0m"

    -- When
    local result = visualiser.formatResults(testResults)

    -- Then
    assert.equal("PASS", result)
  end)

end)

local test = require("testcover.libs.test")

fileExists = function(filename)
  local file = io.open(filename, "r")
  if file then
    file:close()
    return true
  end
  return false
end

stringContains = function(haystack, needle)
  return string.find(haystack, needle, 1, true) ~= nil
end

describe("Test", function()
  it("should get supported patterns", function()
    -- Given

    -- When
    local patterns = test.getSupportedPattern()

    -- Then
    assert.same({"*.go", "*.zig", "*.feature", "*.lua"}, patterns)
  end)

  it("should get file type", function()
    -- Given
    local filename = "libs/tests/example/example.go"

    -- When
    local type = test.getFileType(filename)

    -- Then
    assert.equal("go", type)
  end)

  it("should get results from popup", function()
    -- Given
    local ms = 100

    local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = 30,
      height = 10,
      col = 10,
      row = 5,
      style = "minimal",
    })

    -- When
    local results = test.getResultsFromPopup("TEST MARKER SHOULD NOT EXIST", ms)

    -- Then
    assert.is_nil(results)

    -- Given
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"TEST MARKER SHOULD EXIST"})

    -- When
    results = test.getResultsFromPopup("TEST MARKER", ms)

    -- Then
    assert.equal("TEST MARKER SHOULD EXIST", results)
  end)

  it("should run Go tests", function()
    -- Given
    local filename = "libs/tests/example/example.go"

    -- When
    local testResults, error = test.run(filename)

    -- Then
    assert.is_nil(error)
    assert.equal("go", testResults.type)
    assert.is_true(stringContains(testResults.results, "PASS"))
    assert.is_true(fileExists(testResults.coverageFilename))
    os.remove(testResults.coverageFilename)
  end)

  it("should run feature tests", function()
    -- Given
    local filename = "libs/tests/example/features/test.feature"

    -- When
    local testResults, error = test.run(filename)
    print(testResults.results)

    -- Then
    assert.is_nil(error)
    assert.equal("feature", testResults.type)
    assert.is_true(stringContains(testResults.results, "PASS"))
    assert.is_nil(testResults.coverageFilename)
  end)

  it("should not run unknown type", function()
    -- Given
    local filename = "libs/tests/example/example_test.unknown" -- nasty workaround to not trigger: "Test file not found"

    -- When
    local testResults, error = test.run(filename)

    -- Then
    assert.is_nil(testResults)
    assert.is_not_nil(error)
    assert.same({
      type = "error",
      section = "Test.run",
      message = "Unsupported filetype",
      data = {
        filename = "libs/tests/example/example_test.unknown",
        type = "unknown"
      }
    }, error)
  end)

  it("should not run without _test file", function()
    -- Given
    local filename = "libs/tests/example/doesntexist.go"

    -- When
    local testResults, error = test.run(filename)

    -- Then
    assert.is_nil(testResults)
    assert.is_not_nil(error)
    assert.same({
      type = "error",
      section = "Test.run",
      message = "Test file not found",
      data = {
        filename = "libs/tests/example/doesntexist.go",
        testFilename = "libs/tests/example/doesntexist_test.go",
        integrationTestFilename = "libs/tests/example/doesntexist_integration_test.go"
      }
    }, error)
  end)
end)

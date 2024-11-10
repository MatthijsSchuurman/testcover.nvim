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
  it("should get file type", function()
    -- Given
    local filename = "libs/tests/data/example.go"

    -- When
    local type = test.getFileType(filename)

    -- Then
    assert.are.equal("go", type)
  end)

  it("should run Go tests", function()
    -- Given
    local filename = "libs/tests/data/example.go"

    -- When
    local testResults = test.run(filename)

    -- Then
    assert.equal("go", testResults.type)
    assert.is_true(stringContains(testResults.results, "PASS"))
    assert.is_true(fileExists(testResults.coverageFilename))
    os.remove(testResults.coverageFilename)
  end)

  it("should not run unknown type", function()
    -- Given
    local filename = "libs/tests/data/example.unknown"

    -- When
    local testResults = test.run(filename)

    -- Then
    assert.is_nil(testResults)
  end)
end)

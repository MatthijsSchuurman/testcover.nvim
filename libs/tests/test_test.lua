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
    local result = test.getFileType(filename)

    -- Then
    assert.are.equal("go", result)
  end)

  it("should run Go tests", function()
    -- Given
    local filename = "libs/tests/data/example.go"

    -- When
    local result = test.run(filename)

    -- Then
    assert.equal("go", result.type)
    assert.is_true(stringContains(result.output, "PASS"))
    assert.is_true(fileExists(result.coverageFilename))
    os.remove(result.coverageFilename)
  end)
end)

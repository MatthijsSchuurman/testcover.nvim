local coverage = require("testcover.libs.coverage")

describe("Coverage", function()
  it("should parse coverage file", function()
    -- Given
    local coverageFile = "libs/tests/example/coverage.out"
    local expectedCoverage = {["example/example.go"] = {} }

    table.insert(expectedCoverage["example/example.go"], {
      tests = 1,
      start = {
        line = 3,
        column = 21
      },
      finish = {
        line = 4,
        column = 11
      },
    })
    table.insert(expectedCoverage["example/example.go"], {
      tests = 1,
      start = {
        line = 4,
        column = 11
      },
      finish = {
        line = 6,
        column = 4
      },
    })

    table.insert(expectedCoverage["example/example.go"], {
      tests = 0,
      start = {
        line = 6,
        column = 9
      },
      finish = {
        line = 8,
        column = 4
      },
    })

    -- When
    local coverageResults, error = coverage.parse(coverageFile)

    -- Then
    assert.is_nil(error)
    assert.same(expectedCoverage, coverageResults)
  end)

  it("should error on file issue", function()
    -- Given
    local coverageFile = "doesntexist/coverage.out"

    -- When
    local coverageResults, error = coverage.parse(coverageFile)

    -- Then
    assert.is_nil(coverageResults)
    assert.is_not_nil(error)
    assert.same({
      type = "error",
      section = "Coverage.parse_gcov",
      message = "Could not open file",
      data = {
        filename = coverageFile
      }
    }, error)
  end)

  it("should error on unsupported file", function()
    -- Given
    local coverageFile = "libs/tests/data/unsupported.out"

    -- When
    local coverageResults, error = coverage.parse(coverageFile)

    -- Then
    assert.is_nil(coverageResults)
    assert.is_not_nil(error)
    assert.same({
      type = "error",
      section = "Coverage.parse",
      message = "Unsupported coverage file type",
      data = {
        filename = coverageFile,
        type = "unsupported.out"
      }
    }, error)
  end)
end)

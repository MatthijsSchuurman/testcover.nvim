local test = require("testcover.libs.test")

describe("Test", function()
  it("should run tests", function()
    -- Given
    local file = "test.lua"

    -- When
    local result = test.run(file)

    -- Then
    assert.are.same("coverage.out", result)
  end)
end)

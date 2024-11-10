local visualiser = require("testcover.libs.visualiser")

describe("Visualiser", function()
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

end)

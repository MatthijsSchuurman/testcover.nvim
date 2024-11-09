local Config = require("libs/config")

describe("Config setup", function()

  it("should have default settings", function()
    -- Given

    -- When

    -- Then
    assert.are.same({ keymap = "<leader>rc" }, Config.defaults)
  end)

end)

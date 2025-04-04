local config = require("testcover.libs.config")

describe("config setup", function()

  it("should have default settings", function()
    -- Given

    -- When
    config.setup()

    -- Then
    assert.equal(config.defaults.keymap, config.settings.keymap)
    assert.equal(config.defaults.display_coverage, config.settings.display_coverage)
    assert.equal(config.defaults.auto_run, config.settings.auto_run)
  end)

  it("should have custom settings", function()
    -- Given
    local custom_settings = {
      keymap = "c",
      covered = {
        highlight = "Covered",
        sign = "CoveredSign"
      },
      display_coverage = true,
      auto_run = true
    }

    -- When
    config.setup(custom_settings)

    -- Then
    assert.equal(custom_settings.keymap, config.settings.keymap)
    assert.equal(custom_settings.display_coverage, config.settings.display_coverage)
    assert.equal(custom_settings.auto_run, config.settings.auto_run)
  end)


end)










































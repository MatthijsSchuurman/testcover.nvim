local Config = require("testcover.libs.config")

describe("Config setup", function()

  it("should have default settings", function()
    -- Given

    -- When
    Config.setup()

    -- Then
    assert.equal(Config.defaults.keymap, Config.settings.keymap)
    assert.equal(Config.defaults.covered.highlight, Config.settings.covered.highlight)
    assert.equal(Config.defaults.covered.sign, Config.settings.covered.sign)
    assert.equal(Config.defaults.uncovered.highlight, Config.settings.uncovered.highlight)
    assert.equal(Config.defaults.uncovered.sign, Config.settings.uncovered.sign)
    assert.equal(Config.defaults.display_coverage, Config.settings.display_coverage)
    assert.equal(Config.defaults.auto_run, Config.settings.auto_run)
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
    Config.setup(custom_settings)

    -- Then
    assert.equal(custom_settings.keymap, Config.settings.keymap)
    assert.equal(custom_settings.covered.highlight, Config.settings.covered.highlight)
    assert.equal(custom_settings.covered.sign, Config.settings.covered.sign)

    assert.equal(Config.defaults.uncovered.highlight, Config.settings.uncovered.highlight)
    assert.equal(Config.defaults.uncovered.sign, Config.settings.uncovered.sign)

    assert.equal(custom_settings.display_coverage, Config.settings.display_coverage)
    assert.equal(custom_settings.auto_run, Config.settings.auto_run)
  end)


end)










































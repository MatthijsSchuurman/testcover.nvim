local Coverage = {}

function Coverage.parse(filename)
  local r, error
  local type = string.match(filename, ".*[/\\](.*)")

  if type == "coverage.out" then
    r, error = Coverage.parse_gcov(filename)
  else
    return nil, {
      type = "error",
      section = "Coverage.parse",
      message = "Unsupported coverage file type",
      data = {
        filename = filename,
        type = type,
      }
    }
  end


  return r, error
end

function Coverage.parse_gcov(filename)
  local r = {}

  local file = io.open(filename, "r")
  if not file then
    return nil, {
      type = "error",
      section = "Coverage.parse_gcov",
      message = "Could not open file",
      data = {
        filename = filename,
      }
    }
  end

  for line in file:lines() do
    if string.match(line, "^mode:") then
      if not string.match(line, "set") then
        return nil, {
          type = "error",
          section = "Coverage.parse_gcov",
          message = "Only mode: set is supported",
          data = {
            filename = filename,
            line = line,
          }
        }
      end
    else
      local coveredFilename, startLine, startColumn, endLine, endColumn, covered, count = string.match(line, "(.*):(%d+)%.(%d+),(%d+)%.(%d+) (%d+) (%d+)")
      if coveredFilename then
        if not r[coveredFilename] then
          r[coveredFilename] = {}
        end

        table.insert(r[coveredFilename], {
          start = {
            line = tonumber(startLine),
            column = tonumber(startColumn),
          },
          finish = {
            line = tonumber(endLine),
            column = tonumber(endColumn),
          },
          covered = (tonumber(covered) > 0),
          count = tonumber(count),
        })
      end
    end
  end

  file:close()
  return r
end

return Coverage

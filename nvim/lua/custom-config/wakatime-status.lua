local M = {}

M.cached_time = ""
M.last_update = 0

local function parse_wakatime_output(output)
  if not output or output == "" then
    return ""
  end
  local hrs, mins = output:match("(%d+)%s+hrs?%s+(%d+)%s+mins?")
  if hrs and mins then
    local h = tonumber(hrs)
    local m = tonumber(mins)
    if h > 0 then
      return string.format("%dh%02dm", h, m)
    else
      return string.format("%dm", m)
    end
  end
  return ""
end

local function fetch_wakatime()
  local cmd = vim.fn.expand("~/.wakatime/wakatime-cli") .. " --today"
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        local output = table.concat(data, "")
        M.cached_time = parse_wakatime_output(output)
        M.last_update = vim.loop.now()
        vim.cmd("redrawstatus")
      end
    end,
    on_stderr = function(_, _) end,
  })
end

function M.get_status()
  local now = vim.loop.now()
  if now - M.last_update > 180000 then
    fetch_wakatime()
  end
  if M.cached_time ~= "" then
    return M.cached_time .. " "
  end
  return ""
end

return M

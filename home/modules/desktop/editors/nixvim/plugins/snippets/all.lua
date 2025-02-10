--example:
--inc 20250209T133000Z - 20250209T140000Z # personal test
---@return string
local function get_timestamp()
  local line_number = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
  local line = vim.fn.getline(line_number - 1)
  return vim.split(line, " ")[4]
end

---@return string
local function get_date()
  local timestamp = get_timestamp()
  return vim.split(timestamp, "T")[1]
end

return {
  s(
    {
      trig = "tw-continue",
      name = "Timewarior Continue From Previous Line",
      desc = { "Start a new time tracking with end time from previous line." },
    },
    fmt(
      [[
      inc {} - {}T{}00Z # {} {}
      ]],
      {
        f(get_timestamp),
        f(get_date),
        i(1),
        c(2, { t("work"), t("meeting"), t("other") }),
        i(3),
      }
    )
  ),
}

--- @class ErrorInfo
--- @field message string
--- @field compilation_error_line integer|nil
--- @field error_line_seen boolean
--- @field last_empty_line integer
local ErrorInfo = {
    message = "",
    compilation_error_line = nil,
    error_line_seen = false,
    last_empty_line = -1,
}
ErrorInfo.__index = ErrorInfo

--- @return boolean
function ErrorInfo:should_notify()
    return self.compilation_error_line ~= nil and self.error_line_seen and
        self.last_empty_line > self.compilation_error_line
end

--- @param lines table[string]
function ErrorInfo:notify(lines)
    vim.schedule(function()
        vim.notify(self.message ..
            table.concat(
                vim.list_slice(lines, self.compilation_error_line + 1, self.last_empty_line - 1), "\n"))
    end)
end

return ErrorInfo

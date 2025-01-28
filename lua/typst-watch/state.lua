--- @class TypstWatchState
--- @field main_file string
--- @field output string
--- @field process vim.SystemObj?
--- @field preview_process vim.SystemObj?
local state = {
    output = "",
    main_file = "",
}

function state:reset()
    if self.process then
        if self.process:kill("sigterm") == "fail" then
            vim.print("Failed to kill watch process", "pid: " .. self.process.pid)
        end
        self.process = nil
    end
    if self.preview_process then
        if self.preview_process:kill("sigterm") == "fail" then
            vim.print("Failed to kill preview process", "pid: " .. self.preview_process.pid)
        end
        self.preview_process = nil
    end

    self.output = ""
    self.main_file = ""
end

return state

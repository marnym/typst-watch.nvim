--- @class TypstWatch
--- @field _state TypstWatchState
--- @field _config TypstWatchConfig
local M = {}

--- @class TypstWatchConfig
--- @field preview_cmd string
M._config = {}

local ErrorInfo = require("typst-watch.error_info")
local state = require("typst-watch.state")

--- @param opts TypstWatchConfig
function M.setup(opts)
    M._config = vim.tbl_deep_extend('force', M._config, opts)

    if not M._config.preview_cmd then
        local uname = vim.uv.os_uname().sysname
        if uname == "Linux" then
            M._config.preview_cmd = "xdg-open"
        elseif uname == "Darwin" then
            M._config.preview_cmd = "open"
        else
            return vim.print("Unsupported OS")
        end
    end
end

---@param err string
---@param data string
local function on_stderr(err, data)
    assert(not err, err)

    -- when the process is killed `data` can be `nil`
    if not data then
        return
    end

    state.output = state.output .. data

    local error_info = setmetatable({}, ErrorInfo)

    local lines = vim.split(state.output, "\n")
    for i, line in ipairs(lines) do
        local compiled_match = line:match("compiled.*")
        if compiled_match then
            if compiled_match:match("successfully") then
                vim.schedule(function() vim.notify("typst: " .. compiled_match) end)
                state.output = ""
                break
            else
                error_info.compilation_error_line = i
                error_info.message = "typst: " .. compiled_match
            end
        end

        if error_info.compilation_error_line and not error_info.error_line_seen and vim.startswith(line, "error:") then
            error_info.error_line_seen = true
        end

        if error_info.error_line_seen and line == "" then
            error_info.last_empty_line = i
        end
    end

    if error_info:should_notify() then
        error_info:notify(lines)
        state.output = ""
    end
end

--- @param file string
function M.watch(file)
    if file == state.main_file then
        return
    end

    state:reset()
    state.main_file = file
    state.process = vim.system({ "typst", "watch", file },
        { text = true, stderr = on_stderr })
end

---@param _cmd string?
---@param _file string?
function M.open_preview(_cmd, _file)
    local cmd = _cmd or M._config.preview_cmd
    local pdf = _file
    if not pdf then
        pdf = state.main_file:match("(.*)%.typ") .. ".pdf"
    end
    -- todo: support array for preview cmd and merge
    vim.system({ cmd, pdf }, { detach = true })
end

return M

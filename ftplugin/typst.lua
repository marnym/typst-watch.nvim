local typst_watch = require("typst-watch")

vim.api.nvim_buf_create_user_command(0, "TypstPreview", function(opts) typst_watch.open_preview(nil, opts.fargs[1]) end,
    { nargs = "?", complete = "file", desc = "Open compiled typst document", })

vim.api.nvim_buf_create_user_command(0, "TypstWatch",
    function(opts) typst_watch.watch(opts.fargs[1] or vim.fn.expand("%:p")) end,
    { nargs = "?", complete = "file", desc = "Start typst watch process", })

vim.api.nvim_buf_create_user_command(0, "TypstWatchStop", function() typst_watch.stop() end,
    { desc = "Stop typst watch process", })

if not vim.g.did_typst_watch_initialize then
    local main = vim.fn.findfile("main.typ", ".;")
    if main ~= "" then
        typst_watch.watch(main)
    else
        vim.print("Did not find main.typ file", "You can specify the file to compile with :TypstWatch filename")
    end
end

vim.g.did_typst_watch_initialize = true

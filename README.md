# typst-watch.nvim

**typst-watch.nvim** is a plugin that makes your [typst](https://typst.app/) workflow easier.

## Requirements

- Neovim >= `0.10.0`

## Features

- Searches for `main.typ`, and starts `typst watch main.typ`

- If a different main file is used, the compilation process can be launched with: `:TypstWatch filename` or `:TypstWatch` for the current file

- The compiled document can be opened with `:TypstPreview`

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "marnym/typst-watch.nvim",
    opts = {}, -- specify options here
    ft = "typst", -- for lazy loading
}
```

## Configuration

The following options are available in **typst-watch.nvim**:

``` lua
{
    -- Command that opens the compiled document.
    preview_cmd = "xdg-open", -- or open on macOS
}
```

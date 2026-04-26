return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.maplocalleader = ","

    vim.g.vimtex_quickfix_method = "latexlog"

    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull",
      "Overfull",
    }

    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdflatex",
        "-interaction=nonstopmode",
        "-synctex=1",
      },
    }

    vim.g.vimtex_view_method = "zathura"
  end,
}

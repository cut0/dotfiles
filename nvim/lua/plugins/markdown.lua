return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      heading = {
        enabled = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        style = "full",
      },
      checkbox = {
        enabled = true,
      },
    },
  },
}

return {
  {
    "MagicDuck/grug-far.nvim",
    commit = "c69859c1d5427ab5fc7ed12380ab521b4e336691",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>tr",
        function()
          require("grug-far").open()
        end,
        desc = "Search and replace (grug-far)",
      },
    },
    opts = {
      -- 右側の縦分割ペインで開く
      windowCreationCommand = "botright vsplit",
      keymaps = {
        -- ノーマルモードの q で閉じる
        close = { n = "q" },
      },
    },
  },
}

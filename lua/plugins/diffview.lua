return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        default = {
          winbar_info = true,
        },
        merge_tool = {
          winbar_info = true,
        },
        file_history = {
          winbar_info = true,
        },
      },
    })
  end,
}

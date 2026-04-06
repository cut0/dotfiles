return {
  cmd = { "oxc_language_server" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "oxlintrc.json", ".oxlintrc.json", "package.json" },
  workspace_required = true,
  settings = {
    oxlint = {
      run = "onType",
    },
  },
}

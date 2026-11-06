unlink(dir(
  file.path(dirname(dirname(normalizePath(test_path()))), "src"),
  pattern = "[.]gcda$",
  full.names = TRUE
))
withr::defer(.Call(clic__gcov_flush), teardown_env())

# Don't let LLM agent detection change progress bar output in tests
withr::local_options(posit_assistant = NULL, .local_envir = teardown_env())
withr::local_envvar(
  AGENT = NA,
  CLAUDECODE = NA,
  GEMINI_CLI = NA,
  CURSOR_AGENT = NA,
  CODEX_CI = NA,
  .local_envir = teardown_env()
)

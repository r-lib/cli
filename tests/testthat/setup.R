unlink(dir(
  file.path(dirname(dirname(normalizePath(test_path()))), "src"),
  pattern = "[.]gcda$",
  full.names = TRUE
))
withr::defer(.Call(clic__gcov_flush), teardown_env())

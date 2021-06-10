
#include <cpp11/R.hpp>
#include <cpp11/integers.hpp>
#include <cpp11/sexp.hpp>

#include <cli/progress.h>

[[cpp11::register]]
int test_baseline_() {
  int res = 0;
  for (int i = 0; i < 2000000000; i++) {
    res += i % 2;
  }
  return res;
}

[[cpp11::register]]
int test_cli_() {
  int res = 0;
  cpp11::sexp bar = cli_progress_bar(2000000000, NULL);
  for (int i = 0; i < 2000000000; i++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
    res += i % 2;
  }
  return res;
}

[[cpp11::register]]
int test_template_() {
  int res = 0;
  cpp11::sexp bar = cli_progress_bar(2000000000, NULL);
  cli_progress_set_format(
     bar,
     "{%d} package{?s} {cli::pb_bar} | {cli::pb_elapsed}",
     4
  );
  for (int i = 0; i < 2000000000; i++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
    res += i % 2;
  }
  return res;
}

test_that("win10_build works for different osVersion", {
    mockery::stub(
        win10_build, "utils::sessionInfo",
        list(running = NULL)
    )
    expect_identical(win10_build(), 0L)

    mockery::stub(
        win10_build, "utils::sessionInfo",
        list(running = "Debian GNU/Linux 11 (bullseye)")
    )
    expect_identical(win10_build(), 0L)

    mockery::stub(
        win10_build, "utils::sessionInfo",
        list(running = "Windows 10 x64 (build 16299)")
    )
    expect_identical(win10_build(), 16299L)
})

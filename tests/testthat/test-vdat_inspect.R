test_that("vdat_inspect outputs to console", {
  skip_on_cran()

  # HR vdat
  expect_output(
    vdat_inspect(
      grep(
        "HR.*\\.vdat$",
        testfiles,
        value = TRUE
      )
    )
  )

  # VR2AR vrl
  # use to error related to issue #18 -
  # pr vdat_inspect-patch-vr2ar-vrl fixes
  # BH - 20 - aug -2025
  expect_output(
    vdat_inspect(
      grep(
        "VR2AR.*\\.vrl",
        testfiles,
        value = TRUE
      )
    )
  )

  # VR2Tx vrl
  expect_output(
    vdat_inspect(
      grep(
        "VR2Tx.*\\.vrl",
        testfiles,
        value = TRUE
      )
    )
  )

  # VR2W 69k vrl
  expect_output(
    vdat_inspect(
      grep(
        "VR2W_.*\\.vrl",
        testfiles,
        value = TRUE
      )
    )
  )

  # VR2W 180k vrl
  expect_output(
    vdat_inspect(
      grep(
        "VR2W180.*\\.vrl",
        testfiles,
        value = TRUE
      )
    )
  )
})

test_that("vdat_inspect invisibly returns a data frame", {
  skip_on_cran()

  # HR vdat
  hr <- expect_invisible(
    vdat_inspect(
      grep(
        "HR.*\\.vdat$",
        testfiles,
        value = TRUE
      ),
      print = FALSE
    )
  )

  expect_s3_class(hr, "data.frame")

  # VR2AR vrl
  # use to error related to issue #18 -
  # pr vdat_inspect-patch-vr2ar-vrl fixes
  # BH - 20 - aug -2025
  vr2ar <- expect_invisible(
    vdat_inspect(
      grep(
        "VR2AR.*\\.vrl",
        testfiles,
        value = TRUE
      ),
      print = FALSE
    )
  )

  expect_s3_class(vr2ar, "data.frame")

  # VR2Tx vrl
  vr2tx <- expect_invisible(
    vdat_inspect(
      grep(
        "VR2Tx.*\\.vrl",
        testfiles,
        value = TRUE
      ),
      print = FALSE
    )
  )

  expect_s3_class(vr2tx, "data.frame")

  # VR2W 69k vrl
  vr2w69 <- expect_invisible(
    vdat_inspect(
      grep(
        "VR2W_.*\\.vrl",
        testfiles,
        value = TRUE
      ),
      print = FALSE
    )
  )

  expect_s3_class(vr2w69, "data.frame")

  # VR2W 180k vrl
  vr2w180 <- expect_invisible(
    vdat_inspect(
      grep(
        "VR2W180.*\\.vrl",
        testfiles,
        value = TRUE
      ),
      print = FALSE
    )
  )

  expect_s3_class(vr2w180, "data.frame")
})

test_that("errors appropriately", {
  skip_on_cran()

  expect_error(
    vdat_inspect("gibberish"),
    "Is the location of gibberish correct"
  )
})

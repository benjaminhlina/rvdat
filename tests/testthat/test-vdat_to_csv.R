# source('tests/testthat/setup-testfiles.R')

# HR vdat
hr <- grep(
  "HR.*\\.vdat$",
  testfiles,
  value = TRUE
)

# VR2AR vrl
vr2ar <- grep(
  "VR2AR.*\\.vrl",
  testfiles,
  value = TRUE
)

# VR2Tx vrl
vr2tx <- grep(
  "VR2Tx.*\\.vrl",
  testfiles,
  value = TRUE
)

# VR2W 69k vrl
vr2w69 <- grep(
  "VR2W_.*\\.vrl",
  testfiles,
  value = TRUE
)

# VR2W 180k vrl
vr2w180 <- grep(
  "VR2W180.*\\.vrl",
  testfiles,
  value = TRUE
)


test_that("creates correct messages", {
  skip_on_cran()

  td <- tempdir()

  # HR vdat
  ## First file's message
  expect_message(
    vdat_to_csv(hr, outdir = td),
    "\\d\\.csv"
  )

  ## Second file's message
  expect_message(
    vdat_to_csv(hr, outdir = td),
    "\\]\\.csv"
  )


  # VR2AR vrl
  ## First
  expect_message(
    vdat_to_csv(vr2ar, outdir = td),
    "\\d\\.csv"
  )
  ## Second
  expect_message(
    vdat_to_csv(vr2ar, outdir = td),
    "\\]\\.csv"
  )


  # VR2Tx vrl
  ## First
  expect_message(
    vdat_to_csv(vr2tx, outdir = td),
    "\\d\\.csv"
  )
  ## Second
  expect_message(
    vdat_to_csv(vr2tx, outdir = td),
    "\\]\\.csv"
  )


  # VR2W 69k vrl
  ## First
  expect_message(
    vdat_to_csv(vr2w69, outdir = td),
    "\\d\\.csv"
  )
  ## Second
  expect_message(
    vdat_to_csv(vr2w69, outdir = td),
    "\\]\\.csv"
  )


  # VR2W 180k vrl
  ## First
  expect_message(
    vdat_to_csv(vr2w180, outdir = td),
    "\\d\\.csv"
  )
  ## Second
  expect_message(
    vdat_to_csv(vr2w180, outdir = td),
    "\\]\\.csv"
  )


  # Clean up
  unlink(
    list.files(td, pattern = "\\.csv$", full.names = TRUE)
  )
})


test_that("errors if multiple files are provided", {
  expect_error(
    vdat_to_csv(
      grep(
        "VR2W.*\\.vrl",
        testfiles,
        value = TRUE
      )
    ),
    "Only one file is allowed at a time\\."
  )

  expect_error(
    vdat_to_csv(
      grep(
        "VR2W.*\\.vrl",
        testfiles,
        value = TRUE
      )
    ),
    "Consider using lapply\\(vdata_files, vdat_to_csv\\)\\."
  )
})


test_that("errors if file can't be found", {
  skip_on_cran()

  expect_error(
    vdat_to_csv("mising_file"),
    "Is the location of mising_file correct"
  )
})


test_that("warns if filter is provided", {
  skip_on_cran()

  td <- tempdir()

  warn_should_be <-
    "The \"filter\" argument is currently unsupported and has been ignored\\."

  # HR vdat
  expect_warning(
    vdat_to_csv(hr,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2AR vrl
  expect_warning(
    vdat_to_csv(vr2ar,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2Tx vrl
  expect_warning(
    vdat_to_csv(vr2tx,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2W 69k vrl
  expect_warning(
    vdat_to_csv(vr2w69,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2W 180k vrl
  expect_warning(
    vdat_to_csv(vr2w180,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )

  # Clean up
  unlink(
    list.files(td, pattern = "\\.csv$", full.names = TRUE)
  )
})

test_that("time is corrected", {
  skip_on_cran()


  read_in <- function(x) {
    x <- gsub("(vrl|vdat)$", "csv", x)
    read.csv(x,
      header = FALSE,
      skip = 100
    )
  }


  # HR VDAT ####
  vdat_to_csv(hr, outdir = td, time_corrected = TRUE)
  corrected <- read_in(hr)

  # Make sure time offset column (V3) has values
  expect_false(
    is.logical(corrected$V3)
  )
  expect_type(
    corrected$V3, "character"
  )

  # Make sure time offset column (V3) is approximately equal to record time (V2)
  #   plus the offset (V5)
  expect_equal(
    as.numeric(
      strptime(corrected$V2, format = "%Y-%m-%d %H:%M:%OS") + corrected$V5
    ),
    as.numeric(strptime(corrected$V3, format = "%Y-%m-%d %H:%M:%OS")),
    tolerance = 1e-6
  )


  # VR2AR vrl ####
  vdat_to_csv(vr2ar, outdir = td, time_corrected = TRUE)
  corrected <- read_in(vr2ar)

  # Make sure time offset column (V3) has values
  expect_false(
    is.logical(corrected$V3)
  )
  expect_type(
    corrected$V3, "character"
  )

  # Make sure time offset column (V3) is approximately equal to record time (V2)
  #   plus the offset (V5)
  expect_equal(
    as.numeric(
      strptime(corrected$V2, format = "%Y-%m-%d %H:%M:%OS") + corrected$V5
    ),
    as.numeric(strptime(corrected$V3, format = "%Y-%m-%d %H:%M:%OS")),
    tolerance = 1e-6
  )


  # VR2Tx vrl ####
  vdat_to_csv(vr2tx, outdir = td, time_corrected = TRUE)
  corrected <- read_in(vr2tx)

  # Make sure time offset column (V3) has values
  expect_false(
    is.logical(corrected$V3)
  )
  expect_type(
    corrected$V3, "character"
  )

  # Make sure time offset column (V3) is approximately equal to record time (V2)
  #   plus the offset (V5)
  expect_equal(
    as.numeric(
      strptime(corrected$V2, format = "%Y-%m-%d %H:%M:%OS") + corrected$V5
    ),
    as.numeric(strptime(corrected$V3, format = "%Y-%m-%d %H:%M:%OS")),
    tolerance = 1e-6
  )


  # VR2W 69k vrl ####
  vdat_to_csv(vr2w69, outdir = td, time_corrected = TRUE)
  corrected <- read_in(vr2w69)

  # Make sure time offset column (V3) has values
  expect_false(
    is.logical(corrected$V3)
  )
  expect_type(
    corrected$V3, "character"
  )

  # Make sure time offset column (V3) is approximately equal to record time (V2)
  #   plus the offset (V5)
  expect_equal(
    as.numeric(
      strptime(corrected$V2, format = "%Y-%m-%d %H:%M:%OS") + corrected$V5
    ),
    as.numeric(strptime(corrected$V3, format = "%Y-%m-%d %H:%M:%OS")),
    tolerance = 1e-6
  )


  # VR2W 180k vrl ####
  vdat_to_csv(vr2w180, outdir = td, time_corrected = TRUE)
  corrected <- read_in(vr2w180)

  # Make sure time offset column (V3) has values
  expect_false(
    is.logical(corrected$V3)
  )
  expect_type(
    corrected$V3, "character"
  )

  # Make sure time offset column (V3) is approximately equal to record time (V2)
  #   plus the offset (V5)
  expect_equal(
    as.numeric(
      strptime(corrected$V2, format = "%Y-%m-%d %H:%M:%OS") + corrected$V5
    ),
    as.numeric(strptime(corrected$V3, format = "%Y-%m-%d %H:%M:%OS")),
    tolerance = 1e-6
  )
})

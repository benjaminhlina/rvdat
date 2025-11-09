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
    vdat_to_json(hr, outdir = td),
    "\\d\\.json"
  )

  ## Second file's message
  expect_message(
    vdat_to_json(hr, outdir = td),
    "\\]\\.json"
  )


  # VR2AR vrl
  ## First
  expect_message(
    vdat_to_json(vr2ar, outdir = td),
    "\\d\\.json"
  )
  ## Second
  expect_message(
    vdat_to_json(vr2ar, outdir = td),
    "\\]\\.json"
  )


  # VR2Tx vrl
  ## First
  expect_message(
    vdat_to_json(vr2tx, outdir = td),
    "\\d\\.json"
  )
  ## Second
  expect_message(
    vdat_to_json(vr2tx, outdir = td),
    "\\]\\.json"
  )


  # VR2W 69k vrl
  ## First
  expect_message(
    vdat_to_json(vr2w69, outdir = td),
    "\\d\\.json"
  )
  ## Second
  expect_message(
    vdat_to_json(vr2w69, outdir = td),
    "\\]\\.json"
  )


  # VR2W 180k vrl
  ## First
  expect_message(
    vdat_to_json(vr2w180, outdir = td),
    "\\d\\.json"
  )
  ## Second
  expect_message(
    vdat_to_json(vr2w180, outdir = td),
    "\\]\\.json"
  )


  # Clean up
  unlink(
    list.files(td, pattern = "\\.json$", full.names = TRUE)
  )
})


test_that("errors if multiple files are provided", {
  expect_error(
    vdat_to_json(
      grep(
        "VR2W.*\\.vrl",
        testfiles,
        value = TRUE
      )
    ),
    "Only one file is allowed at a time\\."
  )

  expect_error(
    vdat_to_json(
      grep(
        "VR2W.*\\.vrl",
        testfiles,
        value = TRUE
      )
    ),
    "Consider using lapply\\(vdata_files, vdat_to_json\\)\\."
  )
})


test_that("errors if file can't be found", {
  skip_on_cran()

  expect_error(
    vdat_to_json("mising_file"),
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
    vdat_to_json(hr,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2AR vrl
  expect_warning(
    vdat_to_json(vr2ar,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2Tx vrl
  expect_warning(
    vdat_to_json(vr2tx,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2W 69k vrl
  expect_warning(
    vdat_to_json(vr2w69,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )


  # VR2W 180k vrl
  expect_warning(
    vdat_to_json(vr2w180,
      outdir = td,
      filter = "abc123"
    ),
    warn_should_be
  )

  # Clean up
  unlink(
    list.files(td, pattern = "\\.json$", full.names = TRUE)
  )
})


test_that("time is corrected", {
  skip_on_cran()


  read_in_json <- function(x) {
    x <- gsub("(vrl|vdat)$", "json", x)

    # Selecting a random sublist is pretty fragile. Keep an eye on this.
    jsonlite::fromJSON(
      x
    )$recordBlock$record[[9]]
  }


  # HR VDAT ####
  vdat_to_json(hr, outdir = td, time_corrected = TRUE, quiet = TRUE)
  corrected <- read_in_json(hr)

  # Make sure time offset column (correctedTime) has values
  expect_false(
    is.logical(corrected$correctedTime)
  )
  expect_type(
    corrected$correctedTime, "character"
  )


  # VR2AR vrl ####
  vdat_to_json(vr2ar, outdir = td, time_corrected = TRUE, quiet = TRUE)
  corrected <- read_in_json(vr2ar)

  expect_false(
    is.logical(corrected$correctedTime)
  )
  expect_type(
    corrected$correctedTime, "character"
  )


  # VR2Tx vrl ####
  vdat_to_json(vr2tx, outdir = td, time_corrected = TRUE, quiet = TRUE)
  corrected <- read_in_json(vr2tx)

  expect_false(
    is.logical(corrected$correctedTime)
  )
  expect_type(
    corrected$correctedTime, "character"
  )


  # VR2W 69k vrl ####
  vdat_to_json(vr2w69, outdir = td, time_corrected = TRUE, quiet = TRUE)
  corrected <- read_in_json(vr2w69)

  # Make sure time offset column (V3) has values
  expect_false(
    is.logical(corrected$correctedTime)
  )
  expect_type(
    corrected$correctedTime, "character"
  )


  # VR2W 180k vrl ####
  vdat_to_json(vr2w180, outdir = td, time_corrected = TRUE, quiet = TRUE)
  corrected <- read_in_json(vr2w180)

  expect_false(
    is.logical(corrected$correctedTime)
  )
  expect_type(
    corrected$correctedTime, "character"
  )
})

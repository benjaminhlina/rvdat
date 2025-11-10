#' Return general VDAT file metadata
#'
#' @param vdata_file file path of VDAT file to inspect.
#' @param ... arguments passed to [`vdat_call`].
#'
#' @export
vdat_inspect <- function(vdata_file, ...) {
  shell_out <- vdat_call(
    what = c(
      "inspect",
      vdata_file
    ),
    pass_error = TRUE,
    ...
  )

  if (shell_out$status == 1) {
    error_file_location(vdata_file, rawToChar(shell_out$stderr))
  }

  # Convert output into data frame
  ## Parse the output
  metadata <- shell_out$stdout |>
    sys::as_text()

  ## Remove section dividers
  metadata <- metadata[sapply(metadata, function(.) !grepl("=|^$", .))]

  ## Parse section headers
  ### Find section header indices (rows with >= 12 spaces)
  section_header_indices <- metadata |>
    grepl("\\s{12,}", x = _) |>
    which()

  ## Parse the metadata
  ### Grab section headers
  section_headers <- metadata[
    section_header_indices[
      # Repeat the headers however many times
      findInterval(seq_along(metadata), vec = section_header_indices)
    ]
  ] |>
    # Remove the spaces
    gsub("\\s", "", x = _) |>
    # Drop header rows
    _[-section_header_indices]

  ### Split according to colons followed by multiple spaces.
  metadata <- metadata |>
    strsplit(":(\\s+|$)") |>
    ### Variables with multiple entries either have those entries indented and
    ###   split into different lines OR split into different lines and preceeded
    ###   with a dash. Split these into two columns according to a space that
    ###   precedes an alphanumeric character OR a dash that precedes a space.
    lapply(function(.) {
      unlist(
        strsplit(
          .,
          "(\\s{2,}(?=[[:alpha:]]))|-\\s|\\s(?=(\\[|\\())",
          perl = TRUE
        )
      )
    })

  ### Now that every section has at least two entries, bind them together
  metadata <- do.call(rbind, metadata) |>
    # silence warning associated with rbind auto-filling while letting
    #   others through
    withCallingHandlers(warning = function(w) {
      if (
        grepl(
          "number of columns of result is not a multiple of vector length",
          conditionMessage(w)
        )
      ) {
        invokeRestart("muffleWarning")
      }
    }) |>
    data.frame() |>
    ### Remove section headers
    _[-section_header_indices, ]

  ### Fill in blanks using last observation carried forward
  ###   Function adapted (trimmed down) from:
  ###   https://stackoverflow.com/questions/10554741/fill-in-data-frame-with-values-from-rows-above

  locf <- function(x) {
    isnotblank <- x != ""
    x[which(isnotblank)][cumsum(isnotblank)]
  }

  ### Rename
  names(metadata) <- c("variable", "subvariable", "value")

  metadata$variable <- locf(metadata$variable)

  ### Add back section headers
  metadata$section <- section_headers

  ### Remove redundant variables
  metadata <- metadata[metadata$variable != metadata$subvariable, ]
  rownames(metadata) <- NULL

  ### Reorganize values
  metadata$value <- ifelse(
    metadata$variable == metadata$value,
    metadata$subvariable,
    metadata$value
  )
  metadata$subvariable <- ifelse(
    metadata$subvariable == metadata$value,
    NA,
    metadata$subvariable
  )

  ### Convert NA in value column
  metadata[metadata$value == "N/A", "value"] <- NA

  ### Drop parentheses
  metadata$value <- gsub("\\]|\\[|\\(|\\)", "", metadata$value)

  invisible(metadata)
}

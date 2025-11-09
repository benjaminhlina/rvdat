#' Return description fields ("template") of different VDAT data types and/or files
#'
#' @param format file format of the template. Currently only accepts "csv.fathom";
#'      here for future compatibility.
#' @param print logical. Defaults to FALS.E Print the output to console?
#' @param ... arguments passed to [`vdat_call`].
#'
#' @export

vdat_template <- function(
  format = "csv.fathom",
  print = FALSE,
  ...
) {
  format <- match.arg(format, "csv.fathom")

  shell_out <- vdat_call(
    what = c(
      "template",
      paste0("--format=", format)
    ),
    pass_error = TRUE,
    print = print,
    ...
  )

  template <- rawToChar(shell_out$stdout)
  template <- unlist(
    strsplit(
      template,
      "\r?\n"
    )
  )
  template <- strsplit(template, ",")[-c(1:2)]

  names(template) <- sapply(template, `[`, 1)

  lapply(template, `[`, -1)
}

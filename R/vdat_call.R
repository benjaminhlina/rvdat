#' Interface directly with `vdat.exe`.
#'
#' Low-level interface to `vdat.exe`, wherein arguments are passed directly
#'    to `vdat.exe`. Arguments should be character vectors, each element being
#'    one command.
#'
#' @param what arguments passed to `vdat.exe`. Defaults to `--help`.
#' @param print logical. Defaults to TRUE. Print the output to console?
#' @param pass_error logical. Defaults to FALSE. Capture and pass any error
#'    through to the user?
#' @param ... arguments passed to [`sys::exec_internal`].
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # Check the help documentation
#' vdat_call()
#'
#' #
#' vdat_call("--help")
#'
#' # Inspect a file; multiple arguments are passed in a character vector
#' vdat_call(c("inspect", "FILENAME"))
#' }
#'
vdat_call <- function(
  what = "--help",
  print = TRUE,
  pass_error = FALSE,
  ...
) {
  vdat_loc <- vdat_here()

  ## Enter Wine mode if needed
  if (Sys.getenv("RVDAT_WINE_EXE") != "") {
    cli::cli_alert_info("Using Wine mode: EXPERIMENTAL!")

    Sys.setenv(WINEDEBUG = "fixme-all")
    on.exit(Sys.unsetenv("WINEDEBUG"))

    # Wine (often) internally mounts things as "Z:/", fix paths accordingly
    what <- sapply(
      what,
      function(x) {
        if (
          # if ends with vrl or vdat
          grepl("\\.(vrl|vdat)$", x, ignore.case = TRUE) &&
            # ...and doesn't already begin with "Z:/"
            !grepl("^Z:/", x)
        ) {
          file.path("Z:", normalizePath(x))
        } else {
          x
        }
      },
      USE.NAMES = FALSE
    )

    # Move VDAT.exe from the command to an argument
    what <- c(path.expand(vdat_loc), what)
    # Make /usr/bin/wine the command
    vdat_loc <- Sys.getenv("RVDAT_WINE_EXE")
  }

  shell_out <- sys::exec_internal(
    cmd = vdat_loc,
    args = what,
    error = FALSE,
    ...
  )

  if (shell_out$status == 1) {
    if (pass_error == FALSE) {
      error_generic_call(
        paste(what, collapse = " "),
        rawToChar(shell_out$stderr)
      )
    }
  }

  class(shell_out) <- "vdat_resp"

  if (print == TRUE) {
    print(shell_out)
  }

  invisible(shell_out)
}

#' Miscellaneous functions for package checking, building, and CI
#'
#' `skip_example_on_ci` and `skip_example_on_runiverse` check the environment for
#'    variables called "CI" and "MY_UNIVERSE", respectively, and return `TRUE`
#'    if it does not exist. Used to run examples if the package is being built
#'    locally and there's a chance that `vdat.exe` exists. If the package is being built on
#'    a continuous integration platform like GitHub Actions, the "CI" variable
#'    will be `TRUE` and `skip_example_on_ci` will return `FALSE`. If it is being
#'    built locally, "CI" will be "" and `skip_example_on_ci` will return
#'    `TRUE`. Similarly, if the package is being built on R-Universe, the
#'    "MY_UNIVERSE" variable will have your universe's name.
#'
#' @name CI_utilities
#' @export

skip_example_on_ci <- function() {
  Sys.getenv("CI") == ""
}

#' @rdname CI_utilities
#' @export

skip_example_on_runiverse <- function() {
  Sys.getenv("MY_UNIVERSE") == ""
}

#' Error functions
#'
#' @param error Character. Error from exec_internal(), passed through `rawToChar`
#'
#' @keywords internal
#' @name error_functions

error_generic_call <- function(what, error) {
  cli::cli_abort(
    c(
      "x" = "Call to VDAT failed with error:",
      " " = "{cli::col_red(error)}",
      "i" = "Is {what} a valid command?"
    )
  )
}

#' @rdname error_functions

error_file_location <- function(vdata_file, error) {
  cli::cli_abort(
    c(
      "x" = "Call to VDAT failed with error:",
      " " = "{cli::col_red(error)}",
      "i" = "Is the location of {vdata_file} correct?"
    )
  )
}

#' @rdname error_functions

error_too_many_files <- function(output_format) {
  cli::cli_abort(
    c(
      "x" = "Only one file is allowed at a time.",
      "i" = "Consider using lapply(vdata_files, {paste0('vdat_to_', output_format)})."
    )
  )
}

#' @param x argument
#' @param vald_args vector of valid arguments
#' @rdname error_functions

error_args <- function(x, valid_args) {

  if (!is.character(x) || !all(x %in% valid_args)) {
    cli::cli_abort(c(
      "Invalid argument(s) passed.",
      "x" = "Got: {.val {x}}",
      "i" = "Valid options are {.val {valid_args}}."
    ))

  }

}



#' @rdname error_functions

error_image_name <- function(x) {
  if (!is.character(x)) {
    cli::cli_abort("Image name has to be character")
  }
}

#' @rdname error_functions

error_path <- function(x) {
  # if not supplied error
  if (missing(x) || is.null(x)) {
    cli::cli_abort("Argument {.var path} is missing or NULL.")
  }
  # if not character or length 1 error
  if (!is.character(x) || length(x) != 1) {
    cli::cli_abort("`path` needs to be a character and has a length greater 1")
  }
  # if path doesn't exist that path exists
  if (!dir.exists(x)) {
    cli::cli_abort("Directory {.val {path}} does not exist.")
  }

  files <- c("vdat.sh", "Fathom_Installer.msi")

  missing <- files[!file.exists(file.path(x, files))]

  if (length(missing))

    cli::cli_abort(c(
      "Missing file(s) in path {.val {x}}:",
      paste0("x ", missing, collapse = ", ")
    ))

}

#' Methods
#'
#' Methods for VDAT responses
#'
#' @keywords internal

print.vdat_resp <- function(x, ...) {
  rawToChar(x$stdout) |>
    cat()

  invisible(x)
}

#' Docker functions
#'
#' @param image_name docker image name
#' @param type is either `{{.Size}}` or `{{.VirtualSize}}`
#'
#' @keywords internal
#' @name interact_docker
image_size <- function(image_name, type) {

  error_image_name(image_name)
  error_size_type(type)

  if (type %in% "download_size") {

    image_size <- sys::exec_internal("docker",
                                     c("image",
                                       "inspect",
                                       image_name,
                                       "--format",
                                       "{{.Size}}"))
  }

  if (type %in% "uncompressed_size") {

    image_size <- sys::exec_internal("docker",
                                     c("images",
                                       image_name,
                                       "--format",
                                       paste("{{.", "Size", "}}", sep = "")
                                     )
    )
  }
  return(image_size)
}



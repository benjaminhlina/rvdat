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
#' @param x argument
#' @param vald_args vector of valid arguments
#'
#' @keywords internal
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

#' @keywords internal
#' @rdname error_functions

error_docker_install <- function() {
  if (Sys.which("docker") == "") {
    # ---- get os and arch
    os <- Sys.info()[["sysname"]]
    arch <- Sys.info()[["machine"]]

    # ---- docker urls based on platform
    docker_url <- list(
      "Darwin" = "https://docs.docker.com/desktop/setup/install/mac-install/",
      "Linux" = "https://docs.docker.com/engine/install/"
    )

    # ---- select the corect url for the right OS
    url <- docker_url[[os]] %||% "https://docs.docker.com/get-docker/"
    # ---- switch out Darwin or "MacOS"
    os_corect <- switch(os,
                        "Darwin" = "MacOS",
                        os
    )
    # ---- error
    cli::cli_abort(
      c(
        "x" = "Docker is not installed or not in PATH",
        "i" = "Install Docker for {.val {os_corect}} using the following architecture
      {.val {arch}} at {.url {url}}"
      )
    )
  }
}

#' @keywords internal
#' @rdname error_functions

error_docker_start <- function() {

  # ----- run docker info
  docker_info <- sys::exec_internal("docker", "info", error = FALSE)
  # ---- grab error
  std_error <-  rawToChar(docker_info$stderr)
  # ---- grab is docker running
  running <- sub(".*\\.\\s*(.*)$", "\\1", std_error) |>
    trimws()
  # if it isn't run depending on OS start application
  if (running == "Is the docker daemon running?") {
    cli::cli_abort(
      c(
        "x" = "Docker is not running",
        "i" = "Starting {.fun {start_docker()}} Docker Desktop. Please wait till
        window appear. Docker can run in the background."
      )
    )
  }
}

#' @keywords internal
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
#' @keywords internal
#' @rdname error_functions

error_image_name <- function(x) {
  if (!is.character(x) & !is.null(x)) {
    cli::cli_abort("Image name has to be character")
  }
}

#' @keywords internal
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

  missing_files <- files[!file.exists(file.path(x, files))]

  if (length(missing_files)) {
    cli::cli_abort(c(
      "Missing file(s) in path {.val {x}}:",
      paste0("x ", missing_files, collapse = ", ")
    ))
  }
}


#' @keywords internal
#' @rdname error_functions

error_too_many_files <- function(output_format) {
  cli::cli_abort(
    c(
      "x" = "Only one file is allowed at a time.",
      "i" = "Consider using lapply(vdata_files, {paste0('vdat_to_', output_format)})."
    )
  )
}

#' Methods
#'
#' Methods for VDAT responses
#'
#' @keywords internal
#' @name sys_outputs

print.vdat_docker <- function(x, image_size, ...) {
  dots <- list(...)
  args <- dots$args

  # ---- get sh run output
  stderr_text <- rawToChar(x$stderr)

  stdout_text <- rawToChar(x$stdout)

  # Print stderr first, in red
  if (nchar(stderr_text) > 0) {
    cli::cli_h1("Downloading Docker Image")
    cat(cli::col_red(stderr_text), "\n")
    cli::cli_alert_success(paste(
      "Docker image download size:",
      image_size$download_size,
      "Mb"
    ))
    cli::cli_alert_success(paste(
      "Docker image unpacked size:",
      image_size$unpacked_size, "Gb"
    ))
  }

  # Print stdout second, in green
  if (nchar(stdout_text) > 0) {
    if (!is.null(args)) {
      if (args == "extract") {
        cli::cli_h1("Extracting vdat.exe")
      }
      if (args == "run") {
        cli::cli_h1("Running vdat.exe")
      }
    }


    cat(cli::col_green(stdout_text), "\n")
  }

  # Optional: final separator
  cli::cli_rule(left = "End of Output")
}

#' @keywords internal
#' @name sys_outputs

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

get_image_size <- function(image_name, type) {
  error_image_name(image_name)
  error_args(type, valid_args = c("download_size", "unpacked_size"))

  if (type %in% "download_size") {
    image_size <- sys::exec_internal(
      "docker",
      c(
        "image",
        "inspect",
        image_name,
        "--format",
        "{{.Size}}"
      )
    )
  }

  if (type %in% "unpacked_size") {
    image_size <- sys::exec_internal(
      "docker",
      c(
        "images",
        image_name,
        "--format",
        "{{.Size}}"
      )
    )
  }
  return(image_size)
}

#' @keywords internal
#' @name interact_docker
image_name <- function(image_name = NULL) {
  error_image_name(image_name)
  if (is.null(image_name)) {
    image_name <- "ghcr.io/trackyverse/vdat:latest"
  }
  return(image_name)
}

#' @keywords internal
#' @name interact_docker

image_size <- function(image_name = NULL) {
  image_name <- image_name()

  download_size <- get_image_size(
    image_name = image_name,
    type = "download_size"
  )

  unpacked_size <- get_image_size(
    image_name = image_name,
    type = "unpacked_size"
  )


  image_size <- list(
    download_size = rawToChar(download_size$stdout),
    unpacked_size = rawToChar(unpacked_size$stdout)
  )

  image_size <- lapply(image_size, function(x) {
    x <- as.numeric(gsub("[^0-9.]", "", x))
    round(x, 2)
  })
  image_size$download_size <- round(image_size$download_size / (1024^2), 2)
  return(image_size)
}

#' Clean up after extracting
#' Remove ocker images
#' @export
#' @name clean_up

rm_docker_image <- function() {
  x <- sys::exec_internal("docker", c("rmi", image_name()))
  print.vdat_resp(x)
}

#' Delete `vdat.exe`
#' @param x `vdat.exe`
#' @export
#' @name clean_up

rm_vdat <- function(x) {
  file.remove("vdat.exe")
}

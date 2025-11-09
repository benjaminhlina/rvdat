#' Run `vdat.exe` in docker
#'
#' Allows the ability to pull GitHub Container of vdat-docker using `vdat.sh`.
#'
#' @param path file path to `vdat.sh` and `Fatham_Installer.msi`. These need
#' to be in the same location. Path has to be a `character`.
#' @param args either `extract` or `run` see @details for more information.
#' `args` has to be a `character`.
#'
#' @details
#' When `args = "extract"`, `vdat.sh` is provided `Fathom_Installer.msi`
#' which will extract `vdat.exe` to project directory.
#' When `args = run`,  `vdat.sh` is provide `vdat.exe` which will
#' run `vdat.exe --help`.
#'
#' @export

vdat_docker <- function(
    path,
    args
) {
  error_path(path)
  error_args(args, valid_args = c("extract", "run"))

  # ---- path to shell file -----
  sh_path <- paste(path, "vdat.sh", sep = "/")

  # ---- make it excutable -----
  sys::exec_internal("chmod", c("+x", sh_path))

  # ----- run extraction of vdat if needed -----
  if (args == "extract") {
    sh_arg <- paste(path, "Fathom_Installer.msi", sep = "/")

    sh_run <- sys::exec_internal(sh_path, sh_arg)

  }
  # ---- run vdat ------
  if (args == "run") {
    sh_arg <- paste(sh_path, " --help", sep = "")
    sh_run <- sys::exec_internal(sh_path, " --help")
  }

  # ----- git docker image size ====
  image_name <- "ghcr.io/trackyverse/vdat:latest"

  download_size <- image_size(image_name = image_name,
                              type = "download_size")

  uncompressed_size <- image_size(image_name = image_name,
                                  type = "uncompressed_size")



  images_sizes <- list(
    download_size = rawToChar(download_size$stdout),
    uncompressed_size = rawToChar(uncompressed_size$stdout)
  )

  images_sizes <- lapply(images_sizes, function(x) {
    x <- as.numeric(gsub("[^0-9.]", "", x))
    round(x, 2)
  }
  )

  # images_sizes$download_size <- images_sizes$download_size / (1024^2)
  # ---- get sh run output -----
  stderr_text <- rawToChar(sh_run$stderr)

  stdout_text <- rawToChar(sh_run$stdout)

  # Print stderr first, in red
  if (nchar(stderr_text) > 0) {
    cli::cli_h1("Downloading Docker Image")
    cat(cli::col_red(stderr_text), "\n")
    cli::cli_alert_success(paste("Docker image download size:",
                                 round(images_sizes$download_size / (1024 ^ 2),
                                       2),
                                 "Mb"))
    cli::cli_alert_success(paste("Docker image unpacked size:",
                                 images_sizes$uncompressed_size, "Gb"))


  }

  # Print stdout second, in green
  if (nchar(stdout_text) > 0) {
    if (args == "extract") {
      cli::cli_h1("Extracting vdat.exe")
    }
    if (args == "run") {
      cli::cli_h1("Running vdat.exe")
    }

    cat(cli::col_green(stdout_text), "\n")
  }

  # Optional: final separator
  cli::cli_rule(left = "End of Output")
}



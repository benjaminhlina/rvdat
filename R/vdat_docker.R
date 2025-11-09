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
  }
  # ---- run vdat ------
  if (args == "run") {
    sh_arg <- " --help"
  }
  sh_run <- sys::exec_internal(sh_path, sh_arg)

  # ----- git docker image size ----

  image_sizez <- image_size()

  # ----- print output -----
  print.vdat_docker(x = sh_run, image_size = image_sizez)
}

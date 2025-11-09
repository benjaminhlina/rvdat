#' Write the location of `vdat.exe` to the environmental variables.
#'
#' @param here location of `vdat.exe`, either a full path name or relative
#'    to the current working directory. Defaults to the value of the "VDAT_EXE"
#'    environment variable
#' @param wine location of `wine.exe`, either a full path name or relative
#'    to the current working directory. Defaults to the value of the "VDAT_EXE"
#'    environment variable. Only used on Linux or Mac operating systems.
#'
#' @export
#' @examplesIf all(skip_example_on_ci(), skip_example_on_runiverse())
#'
#' # Auto-find vdat:
#' vdat_here()
#'
#' # Provide an explicit location:
#' vdat_here("c:/program files/innovasea/fathom connect/vdat.exe")
vdat_here <- function(
  here = Sys.getenv("RVDAT_EXE"),
  wine = Sys.getenv("RVDAT_WINE_EXE")
) {
  if (dir.exists(here)) {
    cli::cli_abort(
      c("x" = "Please include the file name in the path.")
    )
  }

  # Check for Wine installation on non-Windows OSes
  if (Sys.info()["sysname"] != "Windows") {
    if (file.exists(wine)) {
      Sys.setenv(RVDAT_WINE_EXE = wine)
    } else {
      # Wine locations in order of preference
      wine_locations <- c(
        "/usr/bin/wine",
        "/usr/local/bin/wine",
        # Mac (homebrew)
        "/opt/homebrew/bin/wine"
      )

      wine_exists <- file.exists(wine_locations)

      # Error if Wine can't be found automatically
      if (!any(wine_exists)) {
        cli::cli_abort(
          c(
            "x" = "Not on Windows and unable to find a Wine installation.
            Please provide an explicit location of the Wine executable to
            `vdat_here(wine = ...)`."
          )
        )
      }

      # Select the "preferred" (lowest index) Wine
      Sys.setenv(RVDAT_WINE_EXE = wine_locations[min(which(wine_exists))])
    }
  }

  if (file.exists(here)) {
    Sys.setenv(RVDAT_EXE = here)
  } else {
    current_os <- Sys.info()["sysname"]

    if (current_os == "Windows") {
      standard_location <- "C:/Program Files/Innovasea/Fathom Connect/vdat.exe"
    } else if (current_os %in% c("Darwin", "Linux")) {
      standard_location <-
        "~/.wine/drive_c/Program Files/Innovasea/Fathom Connect/vdat.exe"

      ## These no longer exist, but keeping them around in case Innovasea
      ##  provides Linux/Mac versions
      # Linux
      # "/usr/local/Innovasea/Fathom Connect/vdat"
      # Mac
      # "~/Applications/Innovasea/Fathom Connect/vdat"
    } else {
      cli::cli_abort(
        c("x" = "Unable to identify operating system.")
      )
    }

    if (file.exists(standard_location)) {
      Sys.setenv(RVDAT_EXE = standard_location)

      if (current_os %in% c("Linux", "Darwin")) {
        cli::cli_alert_info("VDAT detected in Wine installation.")
      }
    } else {
      cli::cli_abort(
        c("x" = "Unable to find vdat, please provide an explicit location.")
      )
    }
  }

  vdat_env <- Sys.getenv("RVDAT_EXE")

  if (here != vdat_env && here != "") {
    cli::cli_warn("vdat.exe not found at {here}, but at {vdat_env}.")
  }

  vdat_env
}

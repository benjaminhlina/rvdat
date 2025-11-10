# rvdat 0.3.1

  - Fix by @benjaminhlina ([#22](https://github.com/mhpob/rvdat/pull/22) to properly parse standard files.
  - Parse subsections designated by dashes ([#24](https://github.com/mhpob/rvdat/pull/24))

# rvdat 0.3.0

  - **BREAKING CHANGE**: `rvdat` now looks for an environmental variable of
  `RVDAT_EXE` rather than `VDAT_EXE`. If you had this set between sessions,
  [you will need to update your `.Renviron` accordingly](https://rvdat.obrien.page/articles/how-to-use-rvdat.html#getting-started).
  - Experimental support for Linux and Mac systems by wrapping calls to `vdat.exe`
  in a call to [Wine](https://www.winehq.org/). Needs Wine and Winetricks installed,
  (~1.75 GB total!) so more of a bandage rather than an actual implementation.

# rvdat 0.2.0

  - [vdat_here](https://rvdat.obrien.page/reference/vdat_here.html) now looks for
  the vdat executable in the OS-standard installation locations.
  - Miscellaneous test updates to accommodate changes in version 11.0.1 of the 
  vdat executable. See differences here:
  [@e5b8803](https://github.com/mhpob/rvdat/commit/e5b8803b1fc1c61c535a2d3248558fd0f33f30c0)
  - Update to README as Fathom now installs in `.../Innovasea/Fathom Connect`
  instead of `.../Innovasea/Fathom`.

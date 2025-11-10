
<!-- README.md is  generated from README.Rmd. Please edit that file -->

# rvdat

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/mhpob/rvdat/branch/main/graph/badge.svg)](https://app.codecov.io/gh/mhpob/rvdat?branch=main)
<!-- badges: end -->

The intent of this package is to provide lightweight R wrapper functions
around Innovasea’s VDAT File Tool for those who are intimidated by the
shell (me) or just want to keep everything in one language (R, also me).

`rvdat` is intended to play nicely with the
[`matos`](https://matos.obrien.page) and
[`otndo`](https://otndo.obrien.page) packages, though full connectivity
and documentation on how to do so is a work in progress. Please reach
out to me at <mike@obrien.page> or open an issue on GitHub if you need
any help.

For similar implementation that has a few more bells and whistles, check
out
[`glatos::vdat_convert`](https://github.com/ocean-tracking-network/glatos/blob/dev/R/util-vdat.r)
in version \>= 0.8.0 of the [glatos
package](https://github.com/ocean-tracking-network/glatos).

## Installation

### Download `vdat.exe`

`rvdat` requires a VDAT executable (`vdat.exe`) in order to work, which
comes packaged in Innovasea’s Fathom Connect software. You can [download
the software
here](https://support.fishtracking.innovasea.com/s/downloads) after
providing your contact details and agreeing to their End User License
Agreement.

![](man/figures/README-fathom_connect_download.png)

### Install Fathom Connect

#### On Windows

Fathom Connect is a Windows-specific program, so if you’re running
Windows, you’re in luck! Just extract and run the installer, paying
attention into which directory the program is installed. The default
install location on Windows machines is
`C:\Program Files\Innovasea\Fathom Connect`.

#### On Linux

Innovasea does not provide a non-Windows version of Fathom Connect and
`vdat.exe`. If you’re up for doing a little bit more work, you can run
`vdat.exe`, and thus `rdvat`, using [Wine](https://www.winehq.org).
[Install Wine](https://gitlab.winehq.org/wine/wine/-/wikis/Download) on
your Linux distribution of choice, followed by
[Winetricks](https://github.com/Winetricks/winetricks); the latter is
used to install the needed Windows .NET frameworks: v4.5.2 is needed to
run the installer and v 4.8 is needed to run the program. Note that this
is a ~1.75GB installation.

After installing, initiate Wine via `wineboot`, then use `winetricks` to
set Wine to run as Windows 10 (or greater) and install the needed .NET
frameworks.

``` bash
wineboot
winetricks -q win10 dotnet452 dotnet48
```

Now, you need to install Fathom Connect. The installer is usually named
something like “Install-Fathom-Connect-SOMELONGVERSION.msi”, switch this
with “Fathom-Connect-Installer.msi” below.

``` bash
wine msiexec /i Fathom-Connect-Installer.msi /qb
```

If things don’t work and you’re not working headless, run
`wine uninstaller` and install via the GUI interface. Yes, it is
“`uninstaller`” (counter-intuitive).

### On Mac

Similar to Linux, [install
Wine](https://gitlab.winehq.org/wine/wine/-/wikis/MacOS). Install Fathom
Connect accordingly.

### Install `rvdat`

You can install the most-up-to-date version of this package from
[R-universe](https://mhpob.r-universe.dev/rvdat) or
[GitHub](https://github.com/mhpob/rvdat).

R-universe:

``` r
install.packages(
  "rvdat",
  repos = c(
    "https://mhpob.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

GitHub:

``` r
# install.packages("remotes")
remotes::install_github("mhpob/rvdat")
```

## Progress

### To do

- [ ] Sensor values
- [ ] Logging

### Completed

- [x] Check VDAT is where you say it is
- Convert VDAT file to
  - [x] CSV
  - [x] folder of CSVs by factor
  - [x] JSON
- [x] Output location
- [x] Time correction
- [x] Inspect content of file
- [x] Create CSV template
- [x] Look for `vdat.exe`

### Won’t add (for now)

- [ ] ~~Detection filter~~
  - only implemented for HR3 VDAT files; will implement when there’s a
    file to test
- [ ] ~~Convert multiple VRLs~~
  - Removed from `vdat.exe` in spring 2023. Left to user.
- [ ] ~~Time offset~~
  - Won’t add; subtracts a number of hours from the time without being
    DST-aware.
- [ ] ~~JSON template~~
  - The `json.rxlog` and `vfwp` formats noted in the help documentation
    were for internal testing and not intended to be exposed. (See [this
    issue](https://github.com/mhpob/rvdat/issues/15#issuecomment-2214421397))

## Using the package

Load the package:

``` r
library(rvdat)
```

Set or look for system location of vdat.exe:

``` r
vdat_here()
#> [1] "C:/Program Files/Innovasea/Fathom Connect/vdat.exe"
```

What version?

``` r
vdat_version()
#> [1] "vdat-12.9.1-20250203-976858-release"
```

Convert a VRL to CSV:

``` r
## vdat_to_csv("SOME-VDAT-FILE")
#> ✔ File converted:
#>   C:\Users\darpa2\AppData\Local\Temp\RtmpOs8CLb/readme_files/HR2-180_461396_2021-04-20_173145.vdat
#> ℹ File saved in:
#>   C:\Users\darpa2\AppData\Local\Temp\RtmpOs8CLb/readme_files/HR2-180_461396_2021-04-20_173145.csv
```

Convert a VRL to a folder of CSVs split by data type:

``` r
## vdat_to_folder("SOME-VDAT-FILE")
#> ✔ File converted:
#>   C:\Users\darpa2\AppData\Local\Temp\RtmpOs8CLb/readme_files/HR2-180_461396_2021-04-20_173145.vdat
#> ℹ Files saved in:
#>   C:\Users\darpa2\AppData\Local\Temp\RtmpOs8CLb/readme_files/HR2-180_461396_2021-04-20_173145.csv-fathom-split
## list.files("SOME-VDAT-FILE.csv-fathom-split")
#> character(0)
```

Check out the file metadata:

``` r
## vdat_inspect("SOME-VDAT-FILE")
#> ==============================================================================
#>                                      VDAT                                     
#> ==============================================================================
#> File:      HR2-180_461396_2021-04-20_173145.vdat
#> Original:  HR2-180 461396 2021-04-20 173145.vdat
#> Container: Vemco Data File (com.vemco.file.vdat/1.0.0)
#> Content:   HR2 Receiver Data Pack (com.vemco.file.vrdp.vrhr2/1.0.0)
#> Created:   2021-04-20T17:31:45
#> File UUID: f1a18604-46ea-4985-b57c-24809d37ad46
#> Data UUID: 1a595886-99ea-4ee9-a996-2e4d92dc01c3
#> Size:      39370
#> Blocks:    17
#> Block Types: 
#>            VRDP Header (com.vemco.file.vrdp.header/1.1.0)
#>            RxLog General Summary (com.vemco.protobuf.rxlog.summary.general/1.0.0)
#>            HR2 Offload Header (com.vemco.device.vrhr2.offload.header/1.0.0)
#>            HR2 Offload Footer (com.vemco.device.vrhr2.offload.footer/1.0.0)
#>            HR2 Detection Log Block (com.vemco.device.vrhr2.log.detect/1.0.0)
#>            HR2 Ping Log Block (com.vemco.device.vrhr2.log.ping/1.0.0)
#> Codecs: 
#>            zlib compression (com.vemco.file.vdat.codec.zlib/1.2.11)
#> 
#> ==============================================================================
#>                                      VRDP                                     
#> ==============================================================================
#> Creator:   fathom-2.5.0-19700101--release
#> Source:    HR2-180 (0814)
#> 
#> ==============================================================================
#>                                    Offload                                    
#> ==============================================================================
#> Firmware Version: 2.0.1
#> Receiver Time @ Init: 2021-04-20T17:20:05Z
#> Client Time @ Init: 2021-04-20T17:20:06Z
#> Client Time Zone @ Init: -04:00
#> Receiver Time @ Offload: 2021-04-20T21:31:45Z
#> Client Time @ Offload: 2021-04-20T21:31:45Z
#> Client Time Zone @ Offload: -04:00
#> 
#> 
```

See the fields associated with different data types:

``` r
vdat_template(format = "csv.fathom")
#> $ATTITUDE_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Tilt (deg)"         
#> 
#> $BATTERY_DESC
#>  [1] "Device Time (UTC)"     "Time"                  "Time Offset (h)"      
#>  [4] "Time Correction (s)"   "Model"                 "Serial Number"        
#>  [7] "Battery Position"      "Battery Type"          "Battery Serial Number"
#> [10] "Battery Voltage (V)"   "Battery Remaining (%)"
#> 
#> $CFG_CHANNEL_DESC
#>  [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#>  [4] "Time Correction (s)" "Model"               "Serial Number"      
#>  [7] "Channel"             "Detection Type"      "Frequency (kHz)"    
#> [10] "Blanking (ms)"       "Map ID"              "Coding ID"          
#> 
#> $CFG_RECEIVER_HR3_DESC
#>  [1] "Device Time (UTC)"                  "Time"                              
#>  [3] "Time Offset (h)"                    "Time Correction (s)"               
#>  [5] "Model"                              "Serial Number"                     
#>  [7] "Mode"                               "HR Bitscore Threshold"             
#>  [9] "HR Detection Combining Timeout (s)" "HTI Threshold Factor"              
#> [11] "HTI Threshold Minimum"              "HTI Filter"                        
#> 
#> $CFG_STATION_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Station Name"        "Latitude (deg)"      "Longitude (deg)"    
#> 
#> $CFG_STUDY_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Description"        
#> 
#> $CFG_TRANSMITTER_DESC
#>  [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#>  [4] "Time Correction (s)" "Model"               "Serial Number"      
#>  [7] "Transmission Type"   "Full ID"             "ID"                 
#> [10] "Power Level"         "Min Delay (s)"       "Max Delay (s)"      
#> 
#> $CLOCK_REF_DESC
#> [1] "Device Time (UTC)"       "Time"                   
#> [3] "Time Offset (h)"         "Time Correction (s)"    
#> [5] "Model"                   "Serial Number"          
#> [7] "External Time (UTC)"     "External Difference (s)"
#> [9] "Source"                 
#> 
#> $CLOCK_SET_DESC
#> [1] "Device Time (UTC)"       "Time"                   
#> [3] "Time Offset (h)"         "Time Correction (s)"    
#> [5] "Model"                   "Serial Number"          
#> [7] "Prior Device Time (UTC)" "Prior Difference (s)"   
#> [9] "Source"                 
#> 
#> $DATA_ERROR_DESC
#> [1] "Type"        "Error"       "Page"        "Offset"      "Description"
#> 
#> $DATA_SOURCE_FILE_DESC
#> [1] "File Name" "UUID"      "Type"      "Size"      "State"    
#> 
#> $DEPTH_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Depth (m)"          
#> 
#> $DEPTH_STATS_DESC
#>  [1] "Device Time (UTC)"       "Time"                   
#>  [3] "Time Offset (h)"         "Time Correction (s)"    
#>  [5] "Model"                   "Serial Number"          
#>  [7] "Depth Min (m)"           "Depth Max (m)"          
#>  [9] "Depth Mean (m)"          "Sample Count"           
#> [11] "Accumulation Period (s)"
#> 
#> $DET_DESC
#>  [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#>  [4] "Time Correction (s)"  "Model"                "Serial Number"       
#>  [7] "Channel"              "Detection Type"       "Full ID"             
#> [10] "ID"                   "Raw Data"             "Transmitter Serial"  
#> [13] "Signal Strength (dB)" "Noise (dB)"           "Gain (dB)"           
#> [16] "Quality Score"        "Station Name"         "Latitude"            
#> [19] "Longitude"            "GPS HDOP"            
#> 
#> $DET_HTI_DESC
#>  [1] "Device Time (UTC)"     "Time Correction (s)"   "Model"                
#>  [4] "Serial Number"         "Peak Amplitude"        "Noise"                
#>  [7] "Threshold"             "PW -3dB (ms)"          "PW -6dB (ms)"         
#> [10] "PW -12dB (ms)"         "Frequency Offset (Hz)"
#> 
#> $DET_FILTER_DESC
#> [1] "Filter Name"         "Details"             "Rejected Detections"
#> 
#> $DET_SENS_DESC
#>  [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#>  [4] "Time Correction (s)"  "Model"                "Serial Number"       
#>  [7] "Channel"              "Detection Type"       "Full ID"             
#> [10] "ID"                   "Raw Data"             "Transmitter Serial"  
#> [13] "Signal Strength (dB)" "Noise (dB)"           "Gain (dB)"           
#> [16] "Quality Score"        "Station Name"         "Latitude"            
#> [19] "Longitude"            "GPS HDOP"             "Transmitter Type"    
#> [22] "Sensor Function"      "Sensor Value"         "Sensor Unit"         
#> [25] "Sensor Precision"     "Definition Source"   
#> 
#> $DIAG_DESC
#>  [1] "Device Time (UTC)"           "Time"                       
#>  [3] "Time Offset (h)"             "Time Correction (s)"        
#>  [5] "Model"                       "Serial Number"              
#>  [7] "Ambient Temperature (deg C)" "Noise Mean (mV)"            
#>  [9] "Tilt (deg)"                  "Depth (m)"                  
#> [11] "PPM Pings"                   "PPM Detections"             
#> 
#> $DIAG_FAST_DESC
#>  [1] "Device Time (UTC)"           "Time"                       
#>  [3] "Time Offset (h)"             "Time Correction (s)"        
#>  [5] "Model"                       "Serial Number"              
#>  [7] "Ambient Temperature (deg C)" "Noise (mV)"                 
#>  [9] "Tilt (deg)"                  "Depth (m)"                  
#> 
#> $DIAG_HR2_DESC
#>  [1] "Device Time (UTC)"      "Time"                   "Time Offset (h)"       
#>  [4] "Time Correction (s)"    "Model"                  "Serial Number"         
#>  [7] "Tilt (deg)"             "HR Noise (dB)"          "HR Accepted Detections"
#> [10] "HR Rejected Detections" "PPM Pings (D1)"         "PPM Detections (D1)"   
#> [13] "PPM Pings (D2)"         "PPM Detections (D2)"    "PPM Noise (dB)"        
#> 
#> $DIAG_HR3_DESC
#>  [1] "Device Time (UTC)"      "Time"                   "Time Offset (h)"       
#>  [4] "Time Correction (s)"    "Model"                  "Serial Number"         
#>  [7] "Tilt (deg)"             "HR Noise (dB)"          "HR Accepted Detections"
#> [10] "HR Rejected Detections" "PPM Pings (D1)"         "PPM Detections (D1)"   
#> [13] "PPM Pings (D2)"         "PPM Detections (D2)"    "PPM Noise (dB)"        
#> [16] "HTI Detections"         "HTI Noise (dB)"        
#> 
#> $DIAG_VR2W_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Pings"               "Detections"         
#> 
#> $DIAG_VR2W_INTERIM_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Pings"               "Detections"         
#> 
#> $DIAG_VR2AR_DESC
#>  [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#>  [4] "Time Correction (s)" "Model"               "Serial Number"      
#>  [7] "Pings"               "Detections"          "Noise (mV)"         
#> [10] "Tilt (deg)"         
#> 
#> $DIAG_VR2AR_INTERIM_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Pings"               "Detections"         
#> 
#> $DIAG_VR2TX_DESC
#>  [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#>  [4] "Time Correction (s)" "Model"               "Serial Number"      
#>  [7] "Pings"               "Detections"          "Noise (mV)"         
#> [10] "Tilt (deg)"         
#> 
#> $DIAG_VR2TX_INTERIM_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Pings"               "Detections"         
#> 
#> $DIAG_VR4_DESC
#>  [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#>  [4] "Time Correction (s)"  "Model"                "Serial Number"       
#>  [7] "Pings (69 kHz)"       "Detections (69 kHz)"  "Pings (180 kHz)"     
#> [10] "Detections (180 kHz)" "Tilt (deg)"          
#> 
#> $DIAG_NEXTRAK_DESC
#>  [1] "Device Time (UTC)"           "Time"                       
#>  [3] "Time Offset (h)"             "Time Correction (s)"        
#>  [5] "Model"                       "Serial Number"              
#>  [7] "Ambient Temperature (deg C)" "Noise (dB)"                 
#>  [9] "Tilt (deg)"                  "Depth (m)"                  
#> [11] "Pings"                       "Detections"                 
#> 
#> $EVENT_DESC
#>  [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#>  [4] "Time Correction (s)" "Model"               "Serial Number"      
#>  [7] "Type"                "Subtype"             "Description"        
#> [10] "Values"              ""                    ""                   
#> [13] ""                    ""                    ""                   
#> [16] ""                    "Latitude"            "Longitude"          
#> [19] "GPS HDOP"           
#> 
#> $EVENT_FAULT_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Fault Importance"    "Fault Code"          "Fault Description"  
#> 
#> $EVENT_INIT_DESC
#> [1] "Device Time (UTC)"       "Time"                   
#> [3] "Time Offset (h)"         "Time Correction (s)"    
#> [5] "Model"                   "Serial Number"          
#> [7] "Prior Device Time (UTC)" "External Time Zone"     
#> [9] "Firmware Version"       
#> 
#> $EVENT_OFFLOAD_DESC
#>  [1] "Device Time (UTC)"             "Time"                         
#>  [3] "Time Offset (h)"               "Time Correction (s)"          
#>  [5] "Model"                         "Serial Number"                
#>  [7] "External Time (UTC)"           "External Time Zone"           
#>  [9] "HR Total Accepted Detections"  "PPM Total Accepted Detections"
#> [11] "Memory Remaining (%)"          "Battery Remaining (%)"        
#> [13] "Original File"                
#> 
#> $HEALTH_HR2_DESC
#> [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#> [4] "Time Correction (s)"  "Model"                "Serial Number"       
#> [7] "Line Voltage (V)"     "Memory Remaining (%)" "RTC Time"            
#> 
#> $HEALTH_HR3_DESC
#> [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#> [4] "Time Correction (s)"  "Model"                "Serial Number"       
#> [7] "Line Voltage (V)"     "Memory Remaining (%)" "RTC Time"            
#> 
#> $HEALTH_VR2AR_DESC
#> [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#> [4] "Time Correction (s)"  "Model"                "Serial Number"       
#> [7] "Memory Remaining (%)" "RTC Time"            
#> 
#> $HEALTH_VR2TX_DESC
#> [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#> [4] "Time Correction (s)"  "Model"                "Serial Number"       
#> [7] "Memory Remaining (%)" "RTC Time"            
#> 
#> $HEALTH_VR2W_DESC
#> [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#> [4] "Time Correction (s)"  "Model"                "Serial Number"       
#> [7] "Memory Remaining (%)" "RTC Time"            
#> 
#> $HEALTH_VR4_DESC
#> [1] "Device Time (UTC)"     "Time"                  "Time Offset (h)"      
#> [4] "Time Correction (s)"   "Model"                 "Serial Number"        
#> [7] "Memory Remaining (%)"  "Relative Humidity (%)" "RTC Time"             
#> 
#> $HEALTH_NEXTRAK_DESC
#> [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#> [4] "Time Correction (s)"  "Model"                "Serial Number"       
#> [7] "Memory Remaining (%)"
#> 
#> $NOISE_STATS_VR2AR_DESC
#>  [1] "Device Time (UTC)"       "Time"                   
#>  [3] "Time Offset (h)"         "Time Correction (s)"    
#>  [5] "Model"                   "Serial Number"          
#>  [7] "Noise Min (mV)"          "Noise Max (mV)"         
#>  [9] "Noise Mean (mV)"         "Sample Count"           
#> [11] "Accumulation Period (s)"
#> 
#> $NOISE_STATS_VR2TX_DESC
#>  [1] "Device Time (UTC)"       "Time"                   
#>  [3] "Time Offset (h)"         "Time Correction (s)"    
#>  [5] "Model"                   "Serial Number"          
#>  [7] "Noise Min (mV)"          "Noise Max (mV)"         
#>  [9] "Noise Mean (mV)"         "Sample Count"           
#> [11] "Accumulation Period (s)"
#> 
#> $PING_DESC
#>  [1] "Device Time (UTC)"    "Time"                 "Time Offset (h)"     
#>  [4] "Time Correction (s)"  "Model"                "Serial Number"       
#>  [7] "Channel"              "Frequency (kHz)"      "Blanking (ms)"       
#> [10] "Signal Strength (dB)" "Noise (dB)"           "Gain (dB)"           
#> [13] ""                     ""                     ""                    
#> [16] ""                     "Latitude"             "Longitude"           
#> [19] "GPS HDOP"            
#> 
#> $TEMP_DESC
#> [1] "Device Time (UTC)"   "Time"                "Time Offset (h)"    
#> [4] "Time Correction (s)" "Model"               "Serial Number"      
#> [7] "Ambient (deg C)"     "Internal (deg C)"   
#> 
#> $TEMP_STATS_DESC
#>  [1] "Device Time (UTC)"       "Time"                   
#>  [3] "Time Offset (h)"         "Time Correction (s)"    
#>  [5] "Model"                   "Serial Number"          
#>  [7] "Ambient Min (deg C)"     "Ambient Max (deg C)"    
#>  [9] "Ambient Mean (deg C)"    "Sample Count"           
#> [11] "Accumulation Period (s)"
```

Call VDAT using standard flags:

``` r
vdat_call("--help")
#> Usage: C:\PROGRA~1\INNOVA~1\FATHOM~1\vdat.exe [OPTIONS] [SUBCOMMAND]
#> 
#> Options:
#>   -h,--help                   Show help and summary of commands, or detailed
#>                               help for selected command (and exit)
#>   --help-all                  Show help for all commands (and exit)
#>   -v,--version                Print application version (and exit)
#>   --app-id                    Print application identity (and exit)
#> 
#> 
#> Subcommands:
#>   convert                     Convert file to the given file format
#>   inspect                     Describe the content of an existing file
#>   template                    Generate template for a given file format
```

## Development notes

If contributing, please use the following general style:

- All functions that call vdat.exe should use
  [`vdat_call`](https://rvdat.obrien.page/reference/vdat_call.html).
- Create informative messages, warnings, and errors using the [`cli`
  package](https://cli.r-lib.org/).
- In summary:

``` r
a_new_wrapper <- function(some_command) {
  vdat_call("--do this")

  cli::cli_alert_success("Woohoo!!")
}
```

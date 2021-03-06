#' Run R Scripts Parallel with System Control
#'
#' @param rscript_path path of rscript.
#' @param args input arguments of rscript.
#' @param used_memory_treshold upper bound for memory usage
#' @param used_cpu_treshold upper bound for CPU usage
#' @param sleep_time sleep time between two jobs in seconds
#' @param swap server swap memory in GB
#' @param process Boolean variable to see function messages
#'
#' @return
#' @export
#'
parallel_rscripts <- function(
  rscript_path,
  args,
  used_memory_treshold = 75,
  used_cpu_treshold = 75,
  sleep_time = 10,
  swap = 8,
  process = F
){

  # ----------------------------
  # Load Library
  suppressMessages(library(magrittr))
  suppressMessages(library(reticulate))

  # ----------------------------- #
  # Turn off warning and messages
  if(process){
    options(warn=-1)
    options(message=-1)
  }


  # ----------------------------
  # Load psutil python package
  psutil <- import("psutil")

  # ----------------------------
  # Extract job number from args input
  job_number <- lapply(args, length) %>% unlist() %>% max()

  # ----------------------------
  # Convert input args same size
  args_df <-  as.data.frame(args,stringsAsFactors = F)

  # ----------------------------
  # Create R Script Base Command

  script_command = paste("Rscript --vanilla", rscript_path)


  # ----------------------------
  # Run Parallel Tasks
  pb <- txtProgressBar(min = 0, max = job_number, style = 3)
  start_time = Sys.time()
  for(i in 1:job_number){

    # ----------------------------
    # Check System Status
    cpu_percent <- psutil$cpu_percent(interval=2)
    virtual_memory <- psutil$virtual_memory()["percent"]
    swap_memory <- 100*(psutil$swap_memory()["used"]/(swap*1024*1024*1024))


    while(virtual_memory > used_memory_treshold  | cpu_percent > used_cpu_treshold){
      # ----------------------------
      # If Swap is filled Kill all Process
      if(swap_memory > 95){system("pkill -u mshoai")}
      # ----------------------------
      # Check system stats
      cpu_percent <- psutil$cpu_percent(interval=2)
      virtual_memory <- psutil$virtual_memory()["percent"]
      swap_memory <- 100*(psutil$swap_memory()["used"]/(swap*1024*1024*1024))
      # ----------------------------
      # every 10 second check system
      Sys.sleep(10)
    }

    # Add start, end and simulation name to R Script
    system(paste(script_command, paste0(unlist(args_df[i,]),collapse = " ")), wait = FALSE)
    Sys.sleep(sleep_time)
    setTxtProgressBar(pb, i)
  }
  cat(paste("\n Parallel Task Duration: ", round(Sys.time() - start_time,2)))
}

#Elchin Novruzov

# Load necessary libraries
library(dplyr)
install.packages("zoo")

# Get a list of files with names matching the pattern "*.dat"
files <- list.files(pattern = "*.dat")

# Loop through each file
for (file in files) {
  
  # Read the data from the file into a data frame with columns "time" and "runoff"
  data <- read.table(file, header = FALSE, col.names = c("time", "runoff"))
  
  # Filter out rows where runoff is equal to 0
  data <- data[data$runoff != 0, ]
  
  
  # Negate the values in the "runoff" column
  data$runoff <- -1 * data$runoff
  

  # Define a vector of window sizes for the rolling mean calculation
  window_sizes <- c(5, 7, 9, 10, 12, 15, 20)
  
  # Calculate rolling means for each window size and add columns to the data frame
  for (window_size in window_sizes) {
    col_name <- paste("ma", window_size, sep = "")
    data[col_name] <- zoo::rollmean(data$runoff, window_size, fill = NA)
  }
  
  
  # Write the data frames to new files for each window size
  for (window_size in window_sizes) {
    col_name <- paste("ma", window_size, sep = "")
    output_file <- paste(sub(".dat", paste("_win", window_size, ".dat", sep = ""), file), sep = "")
    write.table(data[c("time", col_name)], output_file, col.names = FALSE, row.names = FALSE, quote = FALSE)
  }
}




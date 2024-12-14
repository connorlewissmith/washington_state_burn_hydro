# 05_wria_burn_in.R

# Road and nhd intersection file
library(tidyverse)
library(raster)
library(sf)
library(whitebox)
library(here)
library(sp)
library(job)

# Define the directory containing the clipped WRIA rasters
output_dir <- "~/Downloads/usgs_dems/clipped_wrias"

# List all files in the specified directory
file_list <- list.files(path = normalizePath(output_dir), full.names = TRUE)

job::job({
  # If installing/using whitebox for the first time
  # whitebox::install_whitebox()
  
  # Initiate Whitebox
  whitebox::wbt_init()
  
  theme_set(theme_classic())
  
  # Function to process DEM files
  hydro_burn <- function(file_path) {
    # Extract file name without directory and extension
    file_name <- tools::file_path_sans_ext(basename(file_path))
    
    # Load DEM raster
    dem <- raster(file_path)
    dem_crs <- crs(dem) # Get the CRS of the DEM
    
    # Prepare base raster with the same dimensions as DEM
    r <- raster(nrow = nrow(dem), ncol = ncol(dem), ext = extent(dem), crs = dem_crs) # Ensure CRS matches DEM
    
    # Directory paths for processed outputs
    processed_dir <- here("data", "processed")
    dir.create(file.path(processed_dir, "base_rasters"), showWarnings = FALSE)
    dir.create(file.path(processed_dir, "breaches"), showWarnings = FALSE)
    dir.create(file.path(processed_dir, "burn_in"), showWarnings = FALSE)
    
    # Write base raster
    base_raster_path <- file.path(processed_dir, "base_rasters", paste0(file_name, "_base_raster.tif"))
    writeRaster(r, base_raster_path, overwrite = TRUE)
    
    # Breach depressions
    breached_output <- file.path(processed_dir, "breaches", paste0(file_name, "_breached_dem.tif"))
    wbt_breach_depressions_least_cost(
      dem = file_path,
      output = breached_output,
      dist = 5,
      fill = TRUE
    )
    
    # Fill depressions
    filled_output <- file.path(processed_dir, "breaches", paste0(file_name, "_breach_filled_dem.tif"))
    wbt_fill_depressions_wang_and_liu(
      dem = breached_output,
      output = filled_output
    )
    
    # Calculate difference
    filled_breached <- raster(filled_output)
    difference <- dem - filled_breached
    difference[difference == 0] <- NA
    
    difference_output <- file.path(processed_dir, "breaches", paste0(file_name, "_difference_fill.tif"))
    writeRaster(difference, difference_output, overwrite = TRUE)
    
    # Flow accumulation
    flow_accum_output <- file.path(processed_dir, "burn_in", paste0(file_name, "_demD8FA.tif"))
    wbt_d8_flow_accumulation(
      input = filled_output,
      output = flow_accum_output
    )
    
    # Extract streams
    stream_output <- file.path(processed_dir, "burn_in", paste0(file_name, "_dem_raster_streams.tif"))
    wbt_extract_streams(
      flow_accum = flow_accum_output,
      output = stream_output,
      threshold = 2000
    )
    
    # D8 pointer
    d8_pointer_output <- file.path(processed_dir, "burn_in", paste0(file_name, "_dem_D8pointer.tif"))
    wbt_d8_pointer(
      dem = filled_output,
      output = d8_pointer_output
    )
    
    # Convert raster streams to vector
    vector_streams_output <- file.path(processed_dir, "burn_in", paste0(file_name, "_burned_streams.shp"))
    wbt_raster_streams_to_vector(
      streams = stream_output,
      d8_pntr = d8_pointer_output,
      output = vector_streams_output
    )
    
    # Add file_name attribute to vector streams
    vector_streams <- sf::st_read(vector_streams_output) # Load the vector file
    sf::st_crs(vector_streams) <- dem_crs # Ensure CRS matches DEM
    vector_streams$file_name <- file_name # Add a new attribute with the file name
    sf::st_write(vector_streams, vector_streams_output, delete_layer = TRUE) # Overwrite the file
    
    message(paste(file_name, "processing complete"))
  }
  
  # List of DEM files
  file_list <- list.files(path = normalizePath(output_dir), full.names = TRUE, pattern = "\\.tif$")
  
  # Process each DEM file
  lapply(file_list, hydro_burn)
  
})


# Directory containing the individual burn-in shapefiles
burn_in_dir <- here("data", "processed", "burn_in")

# List all shapefiles in the directory
shapefile_list <- list.files(burn_in_dir, pattern = "\\.shp$", full.names = TRUE)

# Read and combine all shapefiles into one sf object
combined_burn_ins <- do.call(rbind, lapply(shapefile_list, st_read))

wria_key <- st_read(here("ECY_-5919676691824476931 2","WRIA.shp"))

# Standardize `WRIA_NM` in `wria_key` for matching
wria_key <- wria_key %>%
  mutate(
    WRIA_NM_clean = str_to_lower(WRIA_NM) %>%  # Convert to lowercase
      str_replace_all("[^a-z0-9]+", "_")      # Replace non-alphanumeric with underscores
  ) %>% 
  st_drop_geometry()

# Clean `file_name` in `combined_burn_ins`
combined_burn_ins <- combined_burn_ins %>%
  mutate(
    WRIA_NM_clean = file_name %>%             # Use `file_name` column
      str_remove("_dem$") %>%                 # Remove "_dem" at the end
      str_to_lower() %>%                      # Convert to lowercase
      str_replace_all("[^a-z0-9]+", "_"),     # Replace non-alphanumeric with underscores
    WRIA_NM_clean = ifelse(WRIA_NM_clean == "upper_crabwilson", "upper_crab_wilson", WRIA_NM_clean) # Fix specific case
  )

combined_burn_ins <- combined_burn_ins %>%
  left_join(wria_key, by = "WRIA_NM_clean")

combined_burn_ins = combined_burn_ins %>% 
  dplyr::select(-c(file_name, created_us, created_da, last_edite, last_edi_1))

# Save the combined shapefile
st_write(combined_burn_ins, here("output", "wria_burn_ins.shp"), delete_layer = TRUE)


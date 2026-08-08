# ==============================================================================
# TEMPLATE: PRINCIPAL COMPONENT ANALYSIS (PCA) WITH BIPLOT
# Description: A reproducible pipeline for data cleaning, running PCA, 
# and generating a publication-ready biplot using factoextra.
# ==============================================================================

# --- 0. LOAD PACKAGES ---
# Install missing packages by running: install.packages(c("dplyr", "factoextra", "ggplot2"))
library(dplyr)
library(factoextra)
library(ggplot2)

# --- 1. IMPORT DATA ---
# Replace "your_data.csv" with your file name. 
# Adjust 'sep' and 'dec' depending on your regional format (.csv or .csv2)
raw_data <- read.csv("your_data.csv", sep = ";", dec = ".")

# --- 2. DATA PREPARATION & FILTERING ---
# Clean data, apply optional filters, and create grouping variables for the plot.
data_prepared <- raw_data %>%
  na.omit() %>% # Removes any row with NA/errors that could cause the PCA to drop samples
  
  # OPTIONAL: Filter your dataset for a specific condition (e.g., a specific depth or time)
  # filter(DepthColumn == 20) %>% 
  
  # Create a unified column for grouping (used to color the plot).
  # Here we merge two factors (e.g., Environment and Condition). 
  # Update 'Factor1' and 'Factor2' with your actual categorical column names.
  mutate(Treatment_Group = paste(Factor1, Factor2, sep = "_")) 

# --- 3. ISOLATE NUMERIC MATRIX ---
# PCA only accepts numeric variables. We must exclude the experimental design columns.
data_numeric <- data_prepared %>%
  # UPDATE THIS LINE: List all your categorical/text columns with a minus sign to drop them
  select(-Factor1, -Factor2, -Treatment_Group) %>%
  # Extra safeguard to ensure ONLY numeric columns are passed to the PCA
  select(where(is.numeric)) 

# --- 4. RUN THE PCA ---
# Variables are centered and scaled by default (Crucial if variables have different units)
pca_model <- prcomp(data_numeric, center = TRUE, scale. = TRUE)

# --- 5. GENERATE THE PLOT ---
pca_graph <- fviz_pca_biplot(pca_model,
                             geom.ind = "point",
                             habillage = data_prepared$Treatment_Group, # Colors points by the group we created
                             addEllipses = TRUE,
                             ellipse.type = "norm", # Use "convex" to simply wrap the outer points, or "norm" for confidence areas
                             col.var = "black",     # Color of the variables (arrows)
                             pointsize = 2.5,
                             repel = TRUE,          # Prevents text overlapping
                             title = "PCA - Your Custom Title Here") +
  theme_classic()

# View the plot in the RStudio viewer
print(pca_graph)

# --- 6. EXPORT PLOT ---
# The output format is defined by the file extension (.tiff, .png, .jpeg, .pdf)
ggsave(filename = "PCA_Output_HighRes.tiff", 
       plot = pca_graph,
       width = 20,            # Graph width
       height = 14,           # Graph height
       units = "cm",          # Unit of measurement (can also be "in" for inches)
       dpi = 300)             # Resolution: 300 is standard for scientific papers, 600 for ultra-high quality
setwd("~/NAS/Lena/baysor/")

#read the data
df <- read.csv2('segmentation.csv', head = TRUE, sep=",")

df_stats <- read.csv2('baysor_pdf_cell_stats.csv', head = TRUE, sep=",")

summary(df)

#N segmented cells in the data without noise ("")
str(unique(df[df$cell != "", "cell"]))

#N clusters
str(unique(df$cluster))

#N genes
str(unique(df$gene))

#N segmented cells in the data
str(unique(df$cell))

library(ggplot2)
library(dplyr)
#quality control 50 < transcripts < 400 per cell
n_transcripts_hist <- df_stats %>%
  filter(density < 4, 
         elongation < 5000, 
         avg_confidence > 0.9, 
         n_transcripts > 50, 
         n_transcripts < 400) %>%
  ggplot(aes(x = n_transcripts)) +
  geom_histogram(binwidth = 3, fill = "skyblue", color = "black", alpha = 0.7) +
  labs(title = "density < 4, 
         elongation < 5000, 
         avg_confidence > 0.9, 
         n_transcripts > 50, 
         n_transcripts < 400",
       x = "N molecules",
       y = "N cells") +
  theme_minimal()

print(n_transcripts_hist)

mean_density <- mean(df_stats$density, na.rm = TRUE)
df_stats$density[is.na(df_stats$density)] <- mean_density

# Determine the upper limit for the x-axis scale
upper_limit <- quantile(df_stats$density, probs = 0.99)  # Using the 99th percentile to exclude outliers
# upper_limit <- median(df_stats$density)  # Alternatively, you can use the median value

# Create the histogram plot with adjusted scale
#filter to see normal distribution
density_hist <- df_stats[!is.na(df_stats$density), ] %>% 
  filter(density < 4, 
         elongation < 5000, 
         avg_confidence > 0.9, 
         n_transcripts > 50, 
         n_transcripts < 400) %>% 
  ggplot(aes(x = density)) +
  geom_histogram(binwidth = 0.1, fill = "skyblue", 
                 color = "black", 
                 alpha = 0.7) +
  labs(title = "density < 4, 
         elongation < 5000, 
         avg_confidence > 0.9, 
         n_transcripts > 50, 
         n_transcripts < 400",
       x = "Density",
       y = "N cells") +
  scale_x_continuous(limits = c(0, upper_limit)) +
  theme_minimal()

# Print or display the histogram
print(density_hist)
#------------------
library(Seurat)

data_dir <- '~/NAS/Lena/baysor/baysor_mtx'
list.files(data_dir) # Should show barcodes.tsv.gz, features.tsv.gz, and matrix.mtx.gz
data <- Read10X(data.dir = data_dir)

#https://hbctraining.github.io/scRNA-seq/lessons/03_SC_quality_control-setup.html
#start analyse data in Seurat if need be
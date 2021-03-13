install.packages("BiocManager")
BiocManager::install("ComplexHeatmap")

library(BiocManager)
library(ComplexHeatmap)
library(tidyr)
library(dplyr)
#use reshape2 to convert format long to wide
install.packages("reshape2")
library(reshape2)
library(ComplexHeatmap)

#convert long data to wide for with sampMqConc as my variable
# i can change out "sampMqConc" with other column as variable
new_data <- read.csv(here::here("data/2021-03-04/pmi_conc_targets.csv"))
#metadata <- read.csv(here::here("data/2021-02-28/mustin_pmi_file_factor_db.csv"))

#use reshape2 to convert format long to wide
new_data_wide <- dcast(new_data, compound  ~ expFactor, value.var = "perCellMqConc" )

#Shift compound name into row names
new_data_wide_2 <- new_data_wide[,-1]
rownames(new_data_wide_2) <-new_data_wide[,1]


##scaling with z-score
scaled_data <-t(scale(t(as.matrix(new_data_wide_2)[,-1])))
Heatmap(scaled_data)


## vialzing the data
Heatmap(scaled_data)

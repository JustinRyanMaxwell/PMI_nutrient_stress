## loading + installing complexheatmap if needed
if(!require(ComplexHeatmap)) {
    install.packages("ComplexHeatmap")
    require(ComplexHeatmap)
}

library(reshape2)

#new data from Crag
concentration_data <- read.csv(here::here("data/2021-03-04/pmi_conc_targets.csv"))
#metadata <- read.csv(here::here("data/2021-02-28/mustin_pmi_file_factor_db.csv"))

count_data_matrix <- dcast(formula = compound ~ expFactor, data = concentration_data, 
      value.var = "perCellMqConc")


#generate heat map

## scalling w/ z-score
scaled_data <- t(scale(t(count_data_matrix[, -1])))

## normalizing a different ways
mean_norm_data <- apply(count_data_matrix[, -1], 1, function(row) row/mean(row))
mean_norm_data <- t(mean_norm_data)

## vialzing the data
Heatmap(scaled_data, row_labels = count_data_matrix$compound)
Heatmap(mean_norm_data, row_labels = count_data_matrix$compound)

### using scaled data seems like the best way to go for viz

#### Question - how do we argue that a compound is enriched in one factor
#### relative to another? 

sample_classes <- colnames(count_data_matrix)[-1]
sample_classes <- sub("[1-3]", "", sample_classes)

## write something here to store the test output
stat_store <- list()
for(i in 1:nrow(count_data_matrix)) {
    
    cur_row <- count_data_matrix[i,-1]
    cur_row <- as.numeric(cur_row)
    
    temp <- pairwise.t.test(x = cur_row, g = sample_classes)
    stat_store[[i]] <- data.frame(n_v_p = temp$p.value[1,1],
               n_v_r = temp$p.value[2,1],
               p_v_r = temp$p.value[2,2])
    rm(temp, cur_row)
}
rm(i)

stat_store <- Reduce(f = rbind, x = stat_store)

rownames(stat_store) <- count_data_matrix$compound
n_signif_cpds <- rownames(stat_store)[stat_store$n_v_r < 0.05]
p_signif_cpds <- rownames(stat_store)[stat_store$p_v_r < 0.05]


n_rows <- count_data_matrix$compound %in% n_signif_cpds
Heatmap(scaled_data[n_rows,], row_labels = count_data_matrix$compound[n_rows])

p_rows <- count_data_matrix$compound %in% p_signif_cpds
Heatmap(scaled_data[p_rows,], row_labels = count_data_matrix$compound[p_rows])


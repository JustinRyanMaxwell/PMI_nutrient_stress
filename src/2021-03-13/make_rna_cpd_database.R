networkTable <- read.delim(here::here("data/2021-03-13/react_map.txt"), 
                           sep = " ", col.names = c("To", "From", "id", 
                                                    "KO", "RXN", "PathID", 
                                                    "Cpd1", "Cpd2"),
                           stringsAsFactors = F,
                           colClasses = rep("character",7))

rna_data <- read.csv(here::here("data/2021-03-11/pmi_only_rna.csv"))

cpd_database <- read.csv(here::here("data/2021-03-12/compounds - compounds (2).csv"))
cpd_database <- cpd_database[,-2]
colnames(cpd_database)[2] <- 'kegg_ids'
cpd_database$kegg_ids <- trimws(cpd_database$kegg_ids)


keep_net_rows <- networkTable$To %in% cpd_database$kegg_ids | networkTable$From %in% cpd_database$kegg_ids

networkTable <- networkTable[keep_net_rows,]

kos_to_check <- strsplit(networkTable$KO, split = "\\|")

kos_in_rna_data <- sapply(kos_to_check, function(x) any(x %in% rna_data$KEGG.ID))

networkTable <- networkTable[kos_in_rna_data,]

## making a list of all cpd specific kos
cpd_row_list <- list()
for(i in 1:nrow(cpd_database)) {
    
    cur_row <- cpd_database[i,]
    if(cur_row$kegg_ids == "") {
        next
    }
    
    cpd_rows <- networkTable$To == cur_row$kegg_ids | 
        networkTable$From == cur_row$kegg_ids
    
    if(!any(cpd_rows)) {
        next
    } else {
        cpd_row_list[[i]] <- networkTable[cpd_rows,]
    }
    
}
names(cpd_row_list) <- cpd_database$kegg_ids

cpd_row_list <- cpd_row_list[!sapply(cpd_row_list, is.null)]


## removing kos that are not in the transcriptome data
for(i in seq_along(cpd_row_list)) {
    cur_cpd <- cpd_row_list[[i]]
    check_kos <- strsplit(x = cur_cpd$KO, split = "\\|")
    matching_kos <- sapply(check_kos, function(x) x[x %in% rna_data$KEGG.ID])
    
    temp_cpd_list <- list()
    for(j in 1:nrow(cur_cpd)) {
        y <- cur_cpd[j,]
        idx <- rep(1, length(matching_kos[[j]]))
        y <- y[idx,]
        y$KO <- matching_kos[[j]]
        temp_cpd_list[[j]] <- y
    }
    cpd_row_list[[i]] <- Reduce(f = rbind, x = temp_cpd_list)
    rm(j, idx, y, cur_cpd, check_kos, matching_kos, temp_cpd_list)
    
}
rm(i)


## cleaning up database
for(i in seq_along(cpd_row_list)) {
    cur_cpd <- cpd_row_list[[i]]
    cpd_row_list[[i]] <- cur_cpd[,c("KO", "PathID")]
}
rm(i, cur_cpd)


## getting the rna data into our refrence table
for(i in seq_along(cpd_row_list)) {
    cur_cpd <- cpd_row_list[[i]]
    transcript_data <- lapply(cur_cpd$KO, function(x) rna_data[rna_data$KEGG.ID %in% x,10:12])
    
    temp_cpd_list <- list()
    for(j in 1:nrow(cur_cpd)) {
        y <- cur_cpd[j,]
        idx <- rep(1, nrow(transcript_data[[j]]))
        y <- y[idx,]
        y <- cbind(y, transcript_data[[j]])
        temp_cpd_list[[j]] <- y
    }
    cpd_row_list[[i]] <- Reduce(f = rbind, x = temp_cpd_list)
    rm(j, idx, y, cur_cpd, matching_kos, temp_cpd_list)
    
}

#temp_db <- Reduce(f = rbind, x = cpd_row_list)


#ComplexHeatmap::Heatmap(scale(t(temp_db[,3:5])))






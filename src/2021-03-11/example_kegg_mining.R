library(KEGGREST)

rna_data <- read.csv(file = here::here("data/2021-03-11/pmi_only_rna.csv"))

temp <- keggGet("C00020")
rxns <- temp[[1]]$REACTION
rxns <- strsplit(x = rxns, split = " ")
rxns <- unlist(rxns)

samp_ko <- keggGet(rxns[13])
check_kos <- names(samp_ko[[1]]$ORTHOLOGY)

rna_data[which(rna_data$KEGG.ID %in% check_kos),]

samp_ko[[1]]

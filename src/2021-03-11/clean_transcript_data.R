all_transcripts <- read.csv(here::here("data/2021-03-11/all_transcript_expression.csv"))
all_transcripts <- all_transcripts[grep("pmi", all_transcripts$ContigID),]
all_transcripts <- all_transcripts[-grep("n/a ", all_transcripts$KEGG.ID),]

write.csv(x = all_transcripts, here::here("data/2021-03-11/pmi_only_rna.csv"), row.names = F)
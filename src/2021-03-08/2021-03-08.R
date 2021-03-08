read.csv()

#new data from Crag
new_data<-pmi_conc_targets
#Shift compound name into row names
new_data2 <- new_data[,-1]

#i don't remember why i did these steps to get the heatmap to work.
rownames(new_data2) <- new_data[,1]

#generate heat map
heatmap(as.matrix(new_data2, -1), Colv=NA, Rowv=NA, scale="row")

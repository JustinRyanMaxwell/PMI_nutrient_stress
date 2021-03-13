
new_data<-pmi_conc_targets
library(tidyr)

#use reshape2 to convert format long to wide
install.packages("reshape2")
library(reshape2)
#convert long data to wide for with sampMqConc as my variable
# i can change out "sampMqConc" with other column as variable
new_data_wide <- dcast(new_data, compound  ~ expFactor, value.var = "perCellMqConc" )
View(new_data_wide_2)
#Shift compound name into row names
new_data_wide_2 <- new_data_wide[,-1]


rownames(new_data_wide_2) <-new_data_wide[,1]
View(new_data_wide)


#generate heat maps( i need to label x axis and figure out how to group these things)
heatmap(as.matrix(new_data_wide_2, -1), Colv=NA, Rowv=NA, scale="row")
View(new_data_wide_2) 


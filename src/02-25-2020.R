#rename data
data_pos<-pos_data_processed_maven_targ_output
data_neg<-neg_data_processed_maven_targ_output
data_prost<-neg_prostaglandins_processed_maven_targ_output
data_meta<-mustin_pmi_file_factor_db
library(tidyr)

#use reshape2 to convert format long to wide
install.packages("reshape2")
library(reshape2)
#convert long data to wide for with sampMqConc as my variable
# i can change out "sampMqConc" with other column as variable
data_pos_wide <- dcast(data_pos, compound  ~ sample, value.var = "sampMqConc" )
data_neg_wide <- dcast(data_neg, compound ~ sample, value.var="sampMqConc")
data_prost_wide <- dcast(data_prost, compound ~ sample, value.var="sampMqConc")
#Shift compound name into row names
data_pos_wide_2 <- data_pos_wide[,-1]
data_neg_wide_2 <-data_neg_wide[,-1]
data_prost_wide_2 <-data_prost_wide[,-1]
#i don't remember why i did these steps to get the heatmap to work.
rownames(data_pos_wide_2) <- data_pos_wide[,1]
rownames(data_neg_wide_2)<- data_neg_wide[,1]
rownames(data_prost_wide_2)<- data_prost_wide[,1]
#generate heat maps( i need to label x axis and figure out how to group these things)
heatmap(as.matrix(data_pos_wide_2, -1), Colv=NA, Rowv=NA, scale="row")

library(misc3d)
library(barsurf)
set.bs.options (rendering.style = "pdf", theme="blue", top.color="yellow", side.color="red")
plot_bar(,,(data_neg_wide_2),main = 'neg',xlab="compounds",ylab="sample")
plot_bar(,,data_pos_wide_2)
plot_bar(,,data_prost_wide_2)

install.packages("hrbrthemes")
library(hrbrthemes)
View(data_neg_wide_2)
View(data_pos_wide_2)
View(data_meta)
View(data_neg_wide_2)
library(dplyr)
#rename columns the hard way
data_mod_neg<-rename(data_neg_wide_2, N3 = mtab_TSQ_cm_PMI_2020_1112_80, N1 = mtab_TSQ_cm_PMI_2020_1112_89, N2 = mtab_TSQ_cm_PMI_2020_1112_88, 
                     P1 = mtab_TSQ_cm_PMI_2020_1112_86, P2 = mtab_TSQ_cm_PMI_2020_1112_87, P3 = mtab_TSQ_cm_PMI_2020_1112_83, 
                     R1 = mtab_TSQ_cm_PMI_2020_1112_81, R2 = mtab_TSQ_cm_PMI_2020_1112_82, R3 = mtab_TSQ_cm_PMI_2020_1112_84)
View(data_mod_neg)
View(data_prost_wide_2)
data_mod_pos<-rename(data_pos_wide_2, N1 = mtab_TSQ_cm_PMI_2020_1112_61, N2 = mtab_TSQ_cm_PMI_2020_1112_62, N3 = mtab_TSQ_cm_PMI_2020_1112_52,
                     P1=mtab_TSQ_cm_PMI_2020_1112_58, P2 = mtab_TSQ_cm_PMI_2020_1112_59, P3=mtab_TSQ_cm_PMI_2020_1112_55,
                     R1=mtab_TSQ_cm_PMI_2020_1112_53, R2 = mtab_TSQ_cm_PMI_2020_1112_54, R3= mtab_TSQ_cm_PMI_2020_1112_56) 
# Delete columns not represented in Metadata
View(data_mod_neg)
data_mod_pos$mtab_TSQ_cm_PMI_2020_1112_51 = NULL
data_mod_pos$mtab_TSQ_cm_PMI_2020_1112_57 = NULL
data_mod_pos$mtab_TSQ_cm_PMI_2020_1112_60 = NULL
data_mod_neg$mtab_TSQ_cm_PMI_2020_1112_79 = NULL
data_mod_neg$mtab_TSQ_cm_PMI_2020_1112_85 = NULL
data_mod_neg$mtab_TSQ_cm_PMI_2020_1112_90 = NULL
#combine data into 1
data_mod_comb <- rbind(data_mod_neg, data_mod_pos)
View(data_mod_comb)
#reorder columns
data_mod_comb2 <- data_mod_comb[,c("R1", "R2", "R3", "N1", "N2", "N3", "P1", "P2", "P3")]
heatmap(as.matrix(data_mod_comb, -1), Colv=NA, Rowv=NA, scale="row")
?heatmap
        
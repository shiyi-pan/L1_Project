#!/bin/env Rscript
#install.packages("dendextend")
setwd("~/Google_Drive/L1_Project/Analysis/IWTomics/high_resolution")
require(IWTomics)
require(dendextend)
require(parallel)
#install.packages("nws")
library(nws)
library(plyr)

# ##################################################################
# #### selecting median pvalues from 10 random results (not shown)##
# ##################################################################
# for (r in 1:10){
#   file=paste('L1_autosomes_results_smoothed_mean_', r, '.RData', sep="")
#   load(file)
#   out <- result_mean@test$result
#   assign(paste('pval_random_',r,sep=""),out)
# }
# 
# is(pval_random_1[[1]][[1]]$adjusted_pval_matrix)
# is(pval_random_1[[6]][[45]]$pval_matrix)
# 
# head(pval_random_1[[1]][[1]]$adjusted_pval_matrix)
# head(pval_random_2[[1]][[1]]$adjusted_pval_matrix)
# head(pval_random_10[[1]][[1]]$adjusted_pval_matrix)
# 
# #####Get median from matrix while keeping the structure#####
# #X <- data.frame(matrix(rnorm(1e+07), ncol = 200))
# #mclapply(X, median)
# pval_random_max <- pval_random_1
# #i=1
# #j=1
# is(pval_random_max[[i]][[j]])
# head(pval_random_max[[i]][[j]])

# #Select the median out of 10 randoms 
# setwd("~/Desktop/IWT/cleanControl_pvalues/median_scaled//")
# pval_random_median <- pval_random_1
# 
# #install.packages("abind")
# for (i in 1:6){
#   for (j in 1:45){    
#     #i=1
#     #j=1
#   pval_random_median[[i]][[j]]$adjusted_pval_matrix <- matrix(mapply(function(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10){median(c(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10))},pval_random_1[[i]][[j]]$adjusted_pval_matrix,pval_random_2[[i]][[j]]$adjusted_pval_matrix,
#                                                                      pval_random_3[[i]][[j]]$adjusted_pval_matrix,pval_random_4[[i]][[j]]$adjusted_pval_matrix,
#                                                                      pval_random_5[[i]][[j]]$adjusted_pval_matrix,pval_random_6[[i]][[j]]$adjusted_pval_matrix,
#                                                                      pval_random_7[[i]][[j]]$adjusted_pval_matrix,pval_random_8[[i]][[j]]$adjusted_pval_matrix,
#                                                                      pval_random_9[[i]][[j]]$adjusted_pval_matrix,pval_random_10[[i]][[j]]$adjusted_pval_matrix),nrow=100)
# 
#                                                       
#   pval_random_median[[i]][[j]]$pval_matrix <- matrix(mapply(function(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10){median(c(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10))},pval_random_1[[i]][[j]]$pval_matrix,pval_random_2[[i]][[j]]$pval_matrix,
#                                                                      pval_random_3[[i]][[j]]$pval_matrix,pval_random_4[[i]][[j]]$pval_matrix,
#                                                                      pval_random_5[[i]][[j]]$pval_matrix,pval_random_6[[i]][[j]]$pval_matrix,
#                                                                      pval_random_7[[i]][[j]]$pval_matrix,pval_random_8[[i]][[j]]$pval_matrix,
#                                                                      pval_random_9[[i]][[j]]$pval_matrix,pval_random_10[[i]][[j]]$pval_matrix),nrow=100)
#   }
# }
# 
# 
# head(pval_random_1[[1]][[1]]$adjusted_pval_matrix)
# head(pval_random_2[[1]][[1]]$adjusted_pval_matrix)
# head(pval_random_median[[1]][[1]]$adjusted_pval_matrix)
# 
####Replace the original matrices for ramdom sample 1 (not shown) with the ones in pval_random_median
#load('L1_autosomes_results_smoothed_mean_1.RData')
#load('L1_autosomes_results_smoothed_mean_alldenovo.RData')
#result_mean@test$result<-pval_random_median
#save(result_mean,file='L1_autosomes_results_smoothed_mean_alldennovo_median_final.RData')

### Load IWTomics data object with median p-values across random samples
load('L1_autosomes_results_smoothed_mean_alldennovo_median_final.RData')
## Change working directory to "median/", in which the IWTomics test scales were updated for each feature in all six comparisons
setwd('~/Google_Drive/L1_Project/Analysis/IWTomics/high_resolution/median_scaled/')

####### Scale selection for each of the six pairwise comparison###############
scale_threshold=list(test1=c(100,100,10,4,100,
                             16,16,100,4,100,
                             8,100,4,4,10,
                             100,6,100,100,100,
                             100,4,100,10,10,
                             2,100,100,100,100,
                             6,100,100,20,100,
                             20,2,8,100,8,
                             100,100,100,100,10),
                     test2=c(10,100,100,100,100,
                             100,100,100,100,100,
                             8,100,100,100,100,
                             100,8,12,4,4,
                             100,100,100,100,100,
                             100,2,100,100,100,
                             100,4,4,6,100,
                             2,100,4,6,100,
                             100,100,2,100,100),
                     test3=c(10,100,100,100,100,
                             100,100,100,100,100,
                             100,100,100,100,100,
                             100,8,100,6,100,
                             100,100,100,100,100,
                             100,6,100,100,100,
                             100,10,100,100,100,
                             2,100,10,100,100,
                             100,100,6,100,100),
                     test4=c(100,100,100,100,100,
                             100,100,100,100,4,
                             8,100,100,100,100,
                             100,100,100,100,2,
                             100,100,100,100,100,
                             100,100,100,100,6,
                             100,100,100,100,100,
                             100,100,6,6,100,
                             8,100,100,100,6),
                     test5=c(6,100,100,100,100,
                             100,100,100,100,4,
                             8,100,100,100,100,
                             100,4,8,44,6,
                             100,100,100,100,100,
                             100,100,100,100,6,
                             100,100,100,100,100,
                             10,100,4,100,100,
                             100,100,100,100,2),
                     test6=c(24,8,30,4,100,
                             8,8,10,8,2,
                             10,2,10,2,100,
                             100,2,6,6,100,
                             2,2,100,100,100,
                             100,100,100,6,6,
                             100,100,100,6,8,
                             4,20,4,10,16,
                             100,100,100,100,100)
                     )
write.table(scale_threshold,file="scales_all_six_tests.txt")

pdf('IWT_autosomes_smoothed_mean_scaled.pdf',width=7,height=10)
plotTest(result_mean,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

plotSummary(result_mean,groupby="test",only_significant=FALSE,xlab='kb',scale_threshold=scale_threshold,
            filenames=paste0("IWT_autosomes_smoothed_mean_summary_test_",c("denovo_control","pol_control","hs_control","denovo_pol","denovo_hs","pol_hs"),"_scaled.pdf"),
            align_lab="Integration site",ask=FALSE,cellwidth=10,cellheight=15)

plotSummary(result_mean,groupby="feature",only_significant=FALSE,gaps_tests=3,xlab='kb',scale_threshold=scale_threshold,
            filenames=paste0("IWT_autosomes_smoothed_mean_summary_feature_",idFeatures(result_mean),"_scaled.pdf"),
            align_lab="Integration site",ask=FALSE,cellwidth=10,cellheight=15)


## Select the scales based on the IWT heatmap (transformed) and boxplot by each test, 
## then replace the scale vector in the pipeline above
setwd("~/Google_Drive/L1_Project/Analysis/IWTomics/high_resolution/median_scaled/")
# test1: de novo L1 vs control
test=1
result_mean1=result_mean
result_mean1@test$input$id_region1=result_mean1@test$input$id_region1[test]
result_mean1@test$input$id_region2=result_mean1@test$input$id_region2[test]
result_mean1@test$result=result_mean1@test$result[test]
##To covert the adjusted pvalue matrix so that everything above 0.05 will be converted to 1, and
##the heatmap becomes 2-colored 
result_mean1@test$result[[1]]=lapply(result_mean1@test$result[[1]],
                                     function(feat){
                                       feat$adjusted_pval_matrix=(feat$adjusted_pval_matrix-1)*(feat$adjusted_pval_matrix<=0.05)+1
                                       return(feat)
                                     })
validObject(result_mean1)

##Change scales one by one for the 45 features and copy it to ~line 280
scale_threshold=c(100,100,10,4,100,
                  16,16,100,4,100,
                  8,100,4,4,10,
                  100,6,100,100,100,
                  100,4,100,10,10,
                  2,100,100,100,100,
                  6,100,100,20,100,
                  20,2,8,100,8,
                  100,100,100,100,10)

pdf('IWT_autosomes_smoothed_mean_scaled1.pdf',width=7,height=10)
plotTest(result_mean1,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

##test2: polymorphic L1 vs control
test=2
result_mean2=result_mean
result_mean2@test$input$id_region1=result_mean2@test$input$id_region1[test]
result_mean2@test$input$id_region2=result_mean2@test$input$id_region2[test]
result_mean2@test$result=result_mean2@test$result[test]
##To covert the adjusted pvalue matrix so that everything above 0.05 will be converted to 1, and
##the heatmap becomes 2-colored 
result_mean2@test$result[[1]]=lapply(result_mean2@test$result[[1]],
                                     function(feat){
                                       feat$adjusted_pval_matrix=(feat$adjusted_pval_matrix-1)*(feat$adjusted_pval_matrix<=0.05)+1
                                       return(feat)
                                     })
validObject(result_mean2)

##Change scales one by one for the 45 features and copy it to ~line 280
scale_threshold=c(10,100,100,100,100,
                  100,100,100,100,100,
                  8,100,100,100,100,
                  100,8,12,4,4,
                  100,100,100,100,100,
                  100,2,100,100,100,
                  100,4,4,6,100,
                  2,100,4,6,100,
                  100,100,2,100,100)

pdf('IWT_autosomes_smoothed_mean_scaled2.pdf',width=7,height=10)
plotTest(result_mean2,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

##test3: L1HS vs control
test=3
result_mean3=result_mean
result_mean3@test$input$id_region1=result_mean3@test$input$id_region1[test]
result_mean3@test$input$id_region2=result_mean3@test$input$id_region2[test]
result_mean3@test$result=result_mean3@test$result[test]
##To covert the adjusted pvalue matrix so that everything above 0.05 will be converted to 1, and
##the heatmap becomes 2-colored 
result_mean3@test$result[[1]]=lapply(result_mean3@test$result[[1]],
                                     function(feat){
                                       feat$adjusted_pval_matrix=(feat$adjusted_pval_matrix-1)*(feat$adjusted_pval_matrix<=0.05)+1
                                       return(feat)
                                     })
validObject(result_mean3)

##Change scales one by one for the 45 features and copy it to ~line 280
scale_threshold=c(10,100,100,100,100,
                  100,100,100,100,100,
                  100,100,100,100,100,
                  100,8,100,6,100,
                  100,100,100,100,100,
                  100,6,100,100,100,
                  100,10,100,100,100,
                  2,100,10,100,100,
                  100,100,6,100,100)

pdf('IWT_autosomes_smoothed_mean_scaled3.pdf',width=7,height=10)
plotTest(result_mean3,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

##test4: de novo L1 vs polymorphic L1
test=4
result_mean4=result_mean
result_mean4@test$input$id_region1=result_mean4@test$input$id_region1[test]
result_mean4@test$input$id_region2=result_mean4@test$input$id_region2[test]
result_mean4@test$result=result_mean4@test$result[test]
##To covert the adjusted pvalue matrix so that everything above 0.05 will be converted to 1, and
##the heatmap becomes 2-colored 
result_mean4@test$result[[1]]=lapply(result_mean4@test$result[[1]],
                                     function(feat){
                                       feat$adjusted_pval_matrix=(feat$adjusted_pval_matrix-1)*(feat$adjusted_pval_matrix<=0.05)+1
                                       return(feat)
                                     })
validObject(result_mean4)

##Change scales one by one for the 45 features and copy it to ~line 280
scale_threshold=c(100,100,100,100,100,
                  100,100,100,100,4,
                  8,100,100,100,100,
                  100,100,100,100,2,
                  100,100,100,100,100,
                  100,100,100,100,6,
                  100,100,100,100,100,
                  100,100,6,6,100,
                  8,100,100,100,6)

pdf('IWT_autosomes_smoothed_mean_scaled4.pdf',width=7,height=10)
plotTest(result_mean4,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

##test5: de novo L1 vs L1HS
test=5
result_mean5=result_mean
result_mean5@test$input$id_region1=result_mean5@test$input$id_region1[test]
result_mean5@test$input$id_region2=result_mean5@test$input$id_region2[test]
result_mean5@test$result=result_mean5@test$result[test]
##To covert the adjusted pvalue matrix so that everything above 0.05 will be converted to 1, and
##the heatmap becomes 2-colored 
result_mean5@test$result[[1]]=lapply(result_mean5@test$result[[1]],
                                     function(feat){
                                       feat$adjusted_pval_matrix=(feat$adjusted_pval_matrix-1)*(feat$adjusted_pval_matrix<=0.05)+1
                                       return(feat)
                                     })
validObject(result_mean5)

##Change scales one by one for the 45 features and copy it to ~line 280
scale_threshold=c(6,100,100,100,100,
                  100,100,100,100,4,
                  8,100,100,100,100,
                  100,4,8,44,6,
                  100,100,100,100,100,
                  100,100,100,100,6,
                  100,100,100,100,100,
                  10,100,4,100,100,
                  100,100,100,100,2)

pdf('IWT_autosomes_smoothed_mean_scaled5.pdf',width=7,height=10)
plotTest(result_mean5,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

##test6: polymorphic L1 vs L1HS
test=6
result_mean6=result_mean
result_mean6@test$input$id_region1=result_mean6@test$input$id_region1[test]
result_mean6@test$input$id_region2=result_mean6@test$input$id_region2[test]
result_mean6@test$result=result_mean6@test$result[test]
##To covert the adjusted pvalue matrix so that everything above 0.05 will be converted to 1, and
##the heatmap becomes 2-colored 
result_mean6@test$result[[1]]=lapply(result_mean6@test$result[[1]],
                                     function(feat){
                                       feat$adjusted_pval_matrix=(feat$adjusted_pval_matrix-1)*(feat$adjusted_pval_matrix<=0.05)+1
                                       return(feat)
                                     })
validObject(result_mean6)

##Change scales one by one for the 45 features and copy it to ~line 280
scale_threshold=c(24,8,30,4,100,
                  8,8,10,8,2,
                  10,2,10,2,100,
                  100,2,6,6,100,
                  2,2,100,100,100,
                  100,100,100,6,6,
                  100,100,100,6,8,
                  4,20,4,10,16,
                  100,100,100,100,100)

pdf('IWT_autosomes_smoothed_mean_scaled6.pdf',width=7,height=10)
plotTest(result_mean6,col=c('red','blue','green','black'),
         scale_threshold=scale_threshold,ask=FALSE)
dev.off()

# Save the data image with adjusted scales 
save.image("scale_selection.RData")

## To write down which features at each test are LOCALIZED (look at both heatmap and boxplot)

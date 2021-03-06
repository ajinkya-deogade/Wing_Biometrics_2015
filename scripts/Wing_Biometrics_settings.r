#script for testing various settings on the machine learning packages
#currently testing:
#    1.
#    kernel shape for support vector machines 
#    2.
#    number of trees in random forest
#    3.
#    k values for k means
#########################################################################################
require(MASS)     # contains lda() and qda() functions
require(sampling) # easier way to generate subsets of data
require(mda)      # flexible discriminant analysis and mixture discriminant analysis
require(class)    # k nearest neighbours (knn)
require(adabag)   # bagging()
require(ada)      # boosting function, ada()
require(nnet)     # neural net function, nnet()
require(e1071)    # svm()
require(randomForest) # randomForest() 
require(plyr)
#########################################################################################
 

#1.
#########################################################################################
#entering all 4X Olympus wing data, with subsetting
wings <- read.table("../data/Olympus_4X_coords.tsv", h=T) #all wings
sam_wings <- data.frame( wings[ wings$genotype == "samw" ,], row.names=c(1:416) ) #sam wings, both sexes
left_all_wings    <- data.frame( wings[ wings$side == "L" ,], row.names=c(1:1130) ) #left wings only
left_sam_wings    <- data.frame( wings[ wings$genotype == "samw" & wings$side == "L",], row.names=c(1:208) ) #left sam wings only
left_female_wings <- data.frame( wings[ wings$sex == "F" & wings$side == "L",], row.names=c(1:559) ) #left female wings only

#wings from other datasets
wings_olympus_2x <- read.table("../data/Olympus_2X_coords.tsv", h=T)
wings_leica_4x <- read.table("../data/Leica_4X_coords.tsv", h=T)
wings_leica_2x <- read.table("../data/Leica_2X_coords.tsv", h=T)
o2x_sam_wings <- data.frame(wings_olympus_2x[wings_olympus_2x$genotype == "samw" ,], row.names=c(1:413) ) 
l4x_sam_wings <- data.frame(wings_leica_4x[wings_leica_4x$genotype == "samw" ,], row.names=c(1:398) )
l2x_sam_wings <- data.frame(wings_leica_2x[wings_leica_2x$genotype == "samw" ,], row.names=c(1:411) )

##this creates a second dataframe, with left and right wings from individual flies averaged into one value
wing_average <- aggregate( wings[,9:105], list( ID=wings$ID, genotype=wings$genotype, sex=wings$sex ), mean)
sam_wing_average <- aggregate( sam_wings[,9:105], list( ID=sam_wings$ID, genotype=sam_wings$genotype, sex=sam_wings$sex ), mean)
#averaging for other datasets
wing_average_olympus_2x <- aggregate( wings_olympus_2x[,9:105], list( ID=wings_olympus_2x$ID, genotype=wings_olympus_2x$genotype, sex=wings_olympus_2x$sex ), mean)
wing_average_leica_4x <- aggregate( wings_leica_4x[,9:105], list( ID=wings_leica_4x$ID, genotype=wings_leica_4x$genotype, sex=wings_leica_4x$sex ), mean)
wing_average_leica_2x <- aggregate( wings_leica_2x[,9:105], list( ID=wings_leica_2x$ID, genotype=wings_leica_2x$genotype, sex=wings_leica_2x$sex ), mean)
sam_wing_average_olympus_2x <- aggregate( o2x_sam_wings[,9:105], list( ID=o2x_sam_wings$ID, genotype=o2x_sam_wings$genotype, sex=o2x_sam_wings$sex ), mean)
sam_wing_average_leica_4x <- aggregate( l4x_sam_wings[,9:105], list( ID=l4x_sam_wings$ID, genotype=l4x_sam_wings$genotype, sex=l4x_sam_wings$sex ), mean)
sam_wing_average_leica_2x <- aggregate( l2x_sam_wings[,9:105], list( ID=l2x_sam_wings$ID, genotype=l2x_sam_wings$genotype, sex=l2x_sam_wings$sex ), mean)


#Append PCs to new dataframe
#all wings from olympus 4X dataset			   
wings_mean_pc <- prcomp(wing_average[,4:99])
summary(wings_mean_pc)
head(wings_mean_pc$x[,1:58])
average_wings <- data.frame(wing_average, wings_mean_pc$x[,1:58])
#sam wings from olympus 4X dataset
sam_wings_mean_pc <- prcomp(sam_wing_average[,4:99])
sam_average_wings <- data.frame(sam_wing_average, sam_wings_mean_pc$x[,1:58])


#appending PCs to dataframe for wings from other datasets
#all wings
olympus_2x_wings_mean_pc <- prcomp(wing_average_olympus_2x[,4:99])
olympus_2x_average_wings <- data.frame(wing_average_olympus_2x, olympus_2x_wings_mean_pc$x[,1:58])
#sam wings
sam_olympus_2x_wings_mean_pc <- prcomp(sam_wing_average_olympus_2x[,4:99])
olympus_2x_sam_average_wings <- data.frame(sam_wing_average_olympus_2x, sam_olympus_2x_wings_mean_pc$x[,1:58])
#all wings
leica_4x_wings_mean_pc <- prcomp(wing_average_leica_4x[,4:99])
leica_4x_average_wings <- data.frame(wing_average_leica_4x, leica_4x_wings_mean_pc$x[,1:58])
#sam wings
sam_leica_4x_wings_mean_pc <- prcomp(sam_wing_average_leica_4x[,4:99])
leica_4x_sam_average_wings <- data.frame(sam_wing_average_leica_4x, sam_leica_4x_wings_mean_pc$x[,1:58])
#all wings
leica_2x_wings_mean_pc <- prcomp(wing_average_leica_2x[,4:99])
leica_2x_average_wings <- data.frame(wing_average_leica_2x, leica_2x_wings_mean_pc$x[,1:58])
#sam wings
sam_leica_2x_wings_mean_pc <- prcomp(sam_wing_average_leica_2x[,4:99])
leica_2x_sam_average_wings <- data.frame(sam_wing_average_leica_2x, sam_leica_2x_wings_mean_pc$x[,1:58])

#appending PCs, including centroid- just olympus 4X dataset				
#all wings
wings_mean_pc_cent <- prcomp(wing_average[,4:100])
summary(wings_mean_pc_cent)
head(wings_mean_pc_cent$x[,1:58])
average_wings_cent <- data.frame(wing_average, wings_mean_pc_cent$x[,1:58])
#averaged sam wings
sam_wings_mean_pc_cent <- prcomp(sam_wing_average[,4:100])
sam_average_wings_cent <- data.frame(sam_average_wings, sam_wings_mean_pc_cent$x[,1:58])

#sam wings from olympus 4X dataset 
#here wings are not averaged, because these subsets are meant for comparison to BioCAT
sam_pc <- prcomp(sam_wings[,9:104]) #excluding centroid
sam_data <- data.frame(sam_wings, sam_pc$x[,1:58])
#left wings, both sexes
left_wings_pc <- prcomp(left_all_wings[,9:104])
left_all_wings_data <- data.frame(left_all_wings, left_wings_pc$x[,1:58])
left_wings_pc_cent <- prcomp(left_all_wings[,9:105])
left_all_wings_cent <- data.frame(left_all_wings, left_wings_pc_cent$x[,1:58])
#left wings, females
left_female_wings_pc <- prcomp(left_female_wings[,9:104])
left_female_wings_data <- data.frame(left_female_wings, left_female_wings_pc$x[,1:58])
left_female_wings_pc_cent <- prcomp(left_female_wings[,9:105])
left_female_wings_cent <- data.frame(left_female_wings, left_female_wings_pc_cent$x[,1:58])
#left wings, sam
left_sam_wings_pc <- prcomp(left_sam_wings[,9:104])
left_sam_wings_data <- data.frame(left_sam_wings, left_sam_wings_pc$x[,1:58])
left_sam_wings_pc_cent <- prcomp(left_sam_wings[,9:105])
left_sam_wings_cent <- data.frame(left_sam_wings, left_sam_wings_pc_cent$x[,1:58])


#########################################################################################
#Using morphometric PCs to predict sex and genotype
#########################################################################################


#setting tables
#########################################################################################
#tables for sex prediction - olympus 4X dataset
tabw <- table(average_wings$sex)
tabwc <- table(average_wings_cent$sex)
tablw <- table(left_all_wings_data$sex)
tablwc <- table(left_all_wings_cent$sex)
tabls <- table(left_sam_wings_data$sex)
tablsc <- table(left_sam_wings_cent$sex)
tab_sam <- table(sam_wings$sex)
tab_a_sam <- table(sam_average_wings$sex)
tabw 
tabwc
tablw
tablwc
tabls
tablsc
tab_sam
tab_a_sam

#tables for sex prediction - other datasets
#all averaged wings
tabwo2x <- table(olympus_2x_average_wings$sex)
tabwl4x <- table(leica_4x_average_wings$sex)
tabwl2x <- table(leica_2x_average_wings$sex)
tabwo2x
tabwl4x
tabwl2x
#sam averaged wings
tab_a_wo2x <- table(olympus_2x_sam_average_wings$sex)
tab_a_wl4x <- table(leica_4x_sam_average_wings$sex)
tab_a_wl2x <- table(leica_2x_sam_average_wings$sex)
tab_a_wo2x
tab_a_wl4x
tab_a_wl2x


#tables for genotype prediction, all genotypes, - olympus 4X dataset
tabw_g <- table(average_wings$genotype)
tabwc_g <- table(average_wings_cent$genotype)
tablw_g <- table(left_female_wings_data$genotype)
tablwc_g <- table(left_female_wings_cent$genotype)
tabw_g
tabwc_g
tablw_g
tablwc_g
#########################################################################################

#testing and training sets for sex-- strata is wrapped in separate function to save space
#########################################################################################
strata_2var <- function(dataset, variable_name, variable_table, percentage, variable_pos, dataframe_length = 162){
#this function stratifies a dataset by two variables, 
#and makes testing and training sets based on the strata
#testing and training sets returned as a list
  start_position <- dataframe_length - 57
  my_strata <- strata(dataset, stratanames = c(variable_name), method = "srswor", size = 
    c(round(variable_table[1] *(percentage)), round(variable_table[2] * (percentage))))
  my_data <- dataset[, c(variable_pos, start_position:dataframe_length)]
  my_training <- my_data[rownames(my_data) %in% my_strata$ID_unit, ]
  my_testing <- my_data[!rownames(my_data) %in% my_strata$ID_unit, ] 
  my_train_test_info <- list(my_training, my_testing)
  return(my_train_test_info)
}

#creating testing and training sets, genotype
#########################################################################################
strata_5var <- function(dataset, variable_name, variable_table, percentage, variable_pos, dataframe_length = 162){
#this function stratifies a dataset by five variables, 
#and makes testing and training sets based on the strata
#testing and training sets returned as a list
  start_position <- dataframe_length - 57
  my_strata <- strata(dataset, stratanames = c(variable_name), method = "srswor", 
    size = c(round(variable_table[1] *(percentage)), 
	  round(variable_table[2] * (percentage)),
	  round(variable_table[3] * (percentage)),
	  round(variable_table[4] * (percentage)),
	  round(variable_table[5] * (percentage))))
  my_data <- dataset[, c(variable_pos, start_position:dataframe_length)]
  my_training <- my_data[rownames(my_data) %in% my_strata$ID_unit, ]
  my_testing <- my_data[!rownames(my_data) %in% my_strata$ID_unit, ] 
  my_train_test_info <- list(my_training, my_testing)
  return(my_train_test_info)
}

#1.
#svm settings of interest-- function shape (linear, radial, sigmoid, polynomial)
#########################################################################################

#functions for trying each setting out
#selects the one with the highest prediction accuracy on test set
#separate functions for sex and genotype b/c I'm a loser who can't make options into variables
svm_settings_fun_sex <- function(train_set, test_set){
	svm_settings <- list("linear", "radial", "polynomial", "sigmoid")
	final_output_val <- 0
	final_setting <- ""
    for (each_setting in svm_settings)
	{
        fun_svm <- svm(sex~ ., data = train_set, kernel = each_setting)
        fun_svm_training_table <- table(actual = train_set$sex,
                              predicted = predict(fun_svm, type="class"))                         
        fun_svm_test_table <- table(actual = test_set$sex,
                              predicted = predict(fun_svm, newdata=test_set, type="class")) 
        output_val <- 100*sum(diag(fun_svm_test_table)/sum(fun_svm_test_table))
		if(output_val > final_output_val) 
            {final_output_val <- output_val; final_setting <- each_setting}
	}
	output_info <- list(final_output_val, final_setting)
	return(output_info)
}

svm_settings_fun_genotype <- function(train_set, test_set){
	svm_settings <- list("linear", "radial", "polynomial", "sigmoid")
	final_output_val <- 0
	final_setting <- ""
    for (each_setting in svm_settings)
	{
        fun_svm <- svm(genotype~ ., data = train_set, kernel = each_setting)
        fun_svm_training_table <- table(actual = train_set$genotype,
                              predicted = predict(fun_svm, type="class"))                         
        fun_svm_test_table <- table(actual = test_set$genotype,
                              predicted = predict(fun_svm, newdata=test_set, type="class")) 
        output_val <- 100*sum(diag(fun_svm_test_table)/sum(fun_svm_test_table))
		if(output_val > final_output_val) 
            {final_output_val <- output_val; final_setting <- each_setting}
	}
	output_info <- list(final_output_val, final_setting)
	return(output_info)
}

#functions for looping the 'check each setting' function, with resampled testing and training sets
svm_sex_fun <- function(dataset, datatable){
    svm_wings_sex <- strata_2var(dataset, "sex", datatable, 2/3, 3, 158)
	svm_training <- svm_wings_sex[[1]]
    svm_test <- svm_wings_sex[[2]]
    mytest <- svm_settings_fun_sex(svm_training, svm_test)
	return(mytest)
}

svm_genotype_fun <- function(dataset, datatable){
    svm_wings_genotype <- strata_5var(dataset, "genotype", datatable, 2/3, 2, 158)
	svm_training <- svm_wings_genotype[[1]]
	svm_test <- svm_wings_genotype[[2]]
	mytest <- svm_settings_fun_genotype(svm_training, svm_test)
	return(mytest)
}

#fake bootstrap for the SVM functions. 
#Repeats the sampling testing and training sets for variable reps
#gives frequency of each setting being optimal
#outputs as a list of how many 'best prediction success' went to each setting option
resample_settings <- function(function_name, dataset, datatable, reps){
    mylist_linear <- list()
    mylist_radial <- list()
    mylist_sigmoid <- list()
    mylist_polynomial <- list()
	out_list <- list()
    for(i in 1:reps){
        myresult <- function_name(dataset, datatable)
	    if (myresult[[2]] == "linear") {mylist_linear <- unlist(c(mylist_linear, myresult[[1]]))}
	    if (myresult[[2]] == "radial") {mylist_radial <- unlist(c(mylist_radial, myresult[[1]]))}
        if (myresult[[2]] == "sigmoid") {mylist_sigmoid <- unlist(c(mylist_sigmoid, myresult[[1]]))}
	    if (myresult[[2]] == "polynomial") {mylist_polynomial <- unlist(c(mylist_polynomial, myresult[[1]]))}}
    out_list <- list(mylist_linear, mylist_radial, mylist_sigmoid, mylist_polynomial)
	return(out_list)
}


svm_genotype_fake_bootstrap <- resample_settings(svm_genotype_fun, average_wings, tabw_g, 10)
svm_genotype_fake_bootstrap
mean(svm_genotype_fake_bootstrap[[2]]) #sigmoid and radial both work, radial works much better
svm_sex_fake_bootstrap <- resample_settings(svm_sex_fun, sam_average_wings, tab_a_sam, 10)
svm_sex_fake_bootstrap #sigmoid consistently tends to win here, but linear and radial also work really well
mean(svm_sex_fake_bootstrap[[3]])

#2.
#random forest settings of interest-- number of trees
#########################################################################################

#trying a few different variations on tree number. 
#I didn't think it was necessary to do this in increments of one, 
#but it could be modified for that pretty easily
random_forest_sex <- function(train_data, test_data){
#random forest predictions
#makes a training and testing table, outputs a list including
#training table, test table, and overall prediction success percentage
  vector_of_trees <- c(10, 100, 500, 1000)
  random_forest_return <- list()
  final_output_val <- 0
  final_setting <- ""
  for (i in vector_of_trees)
  {
      random_forest_model <- randomForest(sex ~., data = train_data, ntree = i)
      rf_training_table <- table(actual = train_data$sex,
                              predicted = predict(random_forest_model, type="class"))
      rf_test_table <- table(actual = test_data$sex,
                              predicted = predict(random_forest_model, newdata=test_data, type="class"))
      prediction_success <- 100 * sum(diag(rf_test_table)/sum(rf_test_table))
	  if (prediction_success > final_output_val){final_output_val <- prediction_success; final_setting <- i}
      random_forest_return_part <- list(rf_training_table, rf_test_table, prediction_success, random_forest_model, i)
	  }
	  random_forest_return <- list(final_output_val, final_setting)
	  return(random_forest_return)
}



random_forest_genotype <- function(train_data, test_data){
#random forest predictions
#makes a training and testing table, outputs a list including
#training table, test table, and overall prediction success percentage
  vector_of_trees <- c(10, 100, 500, 1000)
  random_forest_return <- list()
  final_output_val <- 0
  final_setting <- ""
  for (i in vector_of_trees)
  {
      random_forest_model <- randomForest(genotype ~., data = train_data, ntree = i)
      rf_training_table <- table(actual = train_data$genotype,
                              predicted = predict(random_forest_model, type="class"))
      rf_test_table <- table(actual = test_data$genotype,
                              predicted = predict(random_forest_model, newdata=test_data, type="class"))
      prediction_success <- 100 * sum(diag(rf_test_table)/sum(rf_test_table))
	  if (prediction_success > final_output_val){final_output_val <- prediction_success; final_setting <- i}
      random_forest_return_part <- list(rf_training_table, rf_test_table, prediction_success, random_forest_model, i)
	  }
	  random_forest_return <- list(final_output_val, final_setting)
	  return(random_forest_return)
}


#function for looping the random forest sex function with different testing/training sets
rf_sex_fun <- function(dataset, datatable){
    rf_wings_sex <- strata_2var(dataset, "sex", datatable, 2/3, 3, 158)
	rf_training <- rf_wings_sex[[1]]
	rf_test <- rf_wings_sex[[2]]
	mytest <- random_forest_sex(rf_training, rf_test)
	myreturn <- mytest
	return(myreturn)
}

#function for looping the random forest genotype function with different testing/training sets
rf_genotype_fun <- function(dataset, datatable){
    rf_wings_genotype <- strata_5var(dataset, "genotype", datatable, 2/3, 2, 158)
	rf_training <- rf_wings_genotype[[1]]
	rf_test <- rf_wings_genotype[[2]]
	mytest <- random_forest_genotype(rf_training, rf_test)
	myreturn <- mytest
	return(myreturn)
}

resample_settings_rf <- function(function_name, dataset, datatable, reps){
	mylist_10 <- list()
    mylist_100 <- list()
    mylist_500 <- list()
	mylist_1000 <- list()
	out_list <- list()
    for(i in 1:reps){
        myresult <- function_name(dataset, datatable)
	    if (myresult[[2]] == 10) {mylist_10 <- unlist(c(mylist_10, myresult[[1]]))}
	    if (myresult[[2]] == 100) {mylist_100 <- unlist(c(mylist_100, myresult[[1]]))}
        if (myresult[[2]] == 500) {mylist_500 <- unlist(c(mylist_500, myresult[[1]]))}
	    if (myresult[[2]] == 1000) {mylist_1000 <- unlist(c(mylist_1000, myresult[[1]]))}}
    out_list <- list(mylist_10, mylist_100, mylist_500, mylist_1000)
	return(out_list)
}

rf_list_sex <- resample_settings_rf(rf_sex_fun, sam_average_wings, tab_a_sam, 10)
rf_list_sex #100 trees works the best
rf_list_genotype <- resample_settings_rf(rf_genotype_fun, average_wings, tabw_g, 10)
rf_list_genotype #1000 trees works the best here


#3.
#k nearest neighbour k values
#########################################################################################

#function that loops across a range of k values, finds the one that produces highest accuracy
knn_accuracy_loop_sex <- function(dataset, datatable,kvals){ 
  knn_wings_sex <- strata_2var(dataset, "sex", datatable, 2/3, 3, 158)
  train_set <- knn_wings_sex[[1]]
  test_set <- knn_wings_sex[[2]]
  knn_accuracy_val <- 0
  for (i in 1:kvals)
  {knn_fun <- knn(train = train_set[, -1], test = test_set[, -1], cl = train_set$sex, k = i, prob=TRUE);
   knn_table <- table(predicted=knn_fun, actual = test_set$sex);
   accuracy <- 100 * sum(diag(knn_table)/sum(knn_table));
   if(accuracy > knn_accuracy_val) 
     {k_val <- i; knn_accuracy_val <- accuracy;knn_sex_table <- knn_table;}
  }
  knn_info <- list(k_val, knn_accuracy_val, knn_sex_table)
  return(knn_info)
}

knn_accuracy_loop_genotype <- function(dataset, datatable,kvals){ 
  knn_wings_genotype <- strata_5var(dataset, "genotype", datatable, 2/3, 2, 158)
  train_set <- knn_wings_genotype[[1]]
  test_set <- knn_wings_genotype[[2]]
  knn_accuracy_val <- 0
  for (i in 1:kvals)
  {knn_fun <- knn(train = train_set[, -1], test = test_set[, -1], cl = train_set$genotype, k = i, prob=TRUE);
   knn_table <- table(predicted=knn_fun, actual = test_set$genotype);
   accuracy <- 100 * sum(diag(knn_table)/sum(knn_table));
   if(accuracy > knn_accuracy_val) 
     {k_val <- i; knn_accuracy_val <- accuracy;knn_sex_table <- knn_table;}
  }
  knn_info <- list(k_val, knn_accuracy_val, knn_sex_table)
  return(knn_info)
}

#resampling for knn functions
resample_settings_knn <- function(function_name, dataset, datatable, reps){
	out_list <- list()
	K_sum <- 0
	Prediction_accuracy <- 0
    for(i in 1:reps){
        my_result <- function_name(dataset, datatable, 100)
		K_sum <- K_sum + my_result[[1]]
		Prediction_accuracy <- Prediction_accuracy + my_result[[2]]
		}
	K_sum_mean <- K_sum/reps
	Accuracy_mean <- Prediction_accuracy/reps
    out_list <- list(K_sum_mean, Accuracy_mean)
	return(out_list)
}

knn_sex_info <- resample_settings_knn(knn_accuracy_loop_sex, sam_average_wings, tab_a_sam, 10) #best kvalue tends to be between 3-5
knn_genotype_info <- resample_settings_knn(knn_accuracy_loop_genotype, average_wings, tabw_g, 10) #best kvalue is ~32
knn_sex_info
knn_genotype_info
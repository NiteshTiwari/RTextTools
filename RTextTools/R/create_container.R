create_container <- function(matrix, labels, trainSize=NULL, testSize=NULL, virgin=FALSE) {
    if (is.null(trainSize) && is.null(testSize)) {
        stop("You must specify either a trainSize or testSize parameter, or both.")
    }
	
    can_train <- TRUE
    can_test <- TRUE
    if (is.null(trainSize)) {
	    trainSize <- testSize
	    can_train <- FALSE
	}
	
    if (is.null(testSize)) { 
        testSize <- trainSize
        can_test <- FALSE
    }

	#totalSize <- sort(unique(append(trainSize,testSize)))
	column_names <- colnames(matrix)
	#data_matrix <- as.compressed.matrix(matrix[totalSize])
	data_matrix <- as.compressed.matrix(matrix)
	
	matrix_train_predict <- NULL
	train_code <- NULL
	if (can_train) {
	   
	    matrix_train_predict <- data_matrix[trainSize,]
	    train_code <- as.factor(labels[trainSize])
	    if (length(unique(is.na(train_code))) > 1) {
	        stop("All data in the training set must have corresponding codes.")
	    } 
	} else {
	    # We still need to provide a non-null matrix
	    matrix_train_predict <- data_matrix
	    train_code <- as.factor(labels)
	}
	
	matrix_test_predict <- NULL
	test_code <- NULL
	if (can_test) {
	    matrix_test_predict <- data_matrix[testSize,]
	    test_code <- as.factor(labels[testSize])
	} else {
	    # We still need to provide a non-null matrix
	    matrix_test_predict <- data_matrix
	    test_code <- as.factor(labels)
	}
	
	
	if (virgin == FALSE && length(unique(is.na(test_code))) > 1) {
	    stop("The data to be classified does not have corresponding codes. 
	         To treat this data set as virgin data, set virgin=TRUE.")
    }

    container <- new("matrix_container", training_matrix=matrix_train_predict, 
                     classification_matrix=matrix_test_predict, 
                     training_codes=train_code, 
                     testing_codes=test_code, 
                     column_names=column_names, 
                     virgin=virgin,
                     can_train=can_train,
                     can_test=can_test)
    
    gc()
    return(container)
}
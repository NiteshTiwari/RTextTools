library(RTextTools)


if (FALSE) {
    library(tm)
    library(tree)
    library(nnet)
    library(e1071)
    library(ipred)
    library(caTools)
    library(maxent)
    library(glmnet)
    library(Matrix)
    library(foreach)
    source('~/dev/code/RTextToolsMoriano/RTextTools/R/stem.S')
    #source('~/dev/code/RTextToolsMoriano/RTextTools/R/zzz.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/create_matrix.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/create_container.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/train_models.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/train_model.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/classify_models.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/classify_model.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/create_analytics.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/create_scoreSummary.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/create_precisionRecallSummary.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/create_ensembleSummary.R')
    debugSource('~/dev/code/RTextToolsMoriano/RTextTools/R/recall_accuracy.R')
}


data(SOQuestions)
#SOQuestions <- read.csv("/home/moriano/dev/code/RTextToolsMoriano/RTextTools/data/SOQuestions.csv")
print(nrow(SOQuestions))
raw <- SOQuestions



base_data <- raw[1:200, ]

all_labels <- unique(base_data[, 2])
all_labels <- all_labels[!is.na(all_labels)]

doc_matrix <- create_matrix(base_data$Text, language="english", removeNumbers=TRUE,
                            stemWords=TRUE, removeSparseTerms = 0.998)

container <- create_container(doc_matrix, base_data$Class, trainSize=1:100, 
                              testSize=101:200, virgin=FALSE)

algs <- c(#'SVM'
          #,'GLMNET'
          #,'MAXENT'
          'SLDA'
          ,'BOOSTING'
          ,'BAGGING'
          #,'RF'
          #,'NNET'
          #,'TREE'
)
models <- train_models(container, algs)

classify <- classify_models(container, models)
analytics <- create_analytics(container, classify)
summary(analytics)

print ("New data!!")
new_data <- raw[200:300, ]

new_doc_matrix <- create_matrix(new_data$Text, language="english", removeNumbers=TRUE,
                            stemWords=TRUE, removeSparseTerms = 0.998, originalMatrix=doc_matrix)
new_container <- create_container(new_doc_matrix, all_labels, trainSize=NULL, 
                              testSize=1:(nrow(new_data)-1), virgin=TRUE)


classify <- classify_models(new_container, models)

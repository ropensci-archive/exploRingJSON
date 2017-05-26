
library(jsonlite)
library(tibble)


rm(list=ls())

jsondata <- fromJSON("https://api.github.com/users/hadley/repos")

summary.doc <- function(jsondata){
	
	# number of documents
	number.docs <- nrow(jsondata) 
	
	# number of 1st degree keys
	number.keys <- ncol(jsondata)
	
	dummy_json <- matrix(1,nrow(jsondata),ncol(jsondata))
	for (i in 1:nrow(jsondata)){
		for (j in 1:ncol(jsondata)){
			dummy_json[i,j] <- sum(is.na(jsondata[i,j]))/length(jsondata[i,j])	
		}
	}
	
	docs.per.key <- number.docs - colSums(dummy_json)
	
	tibble(Key = colnames(jsondata) , Doc.count = docs.per.key)

	# vector to pass to summary.key
	#invisible(jsondata)
	
}








library(jsonlite)
library(tibble)


rm(list=ls())

jsondata <- fromJSON("https://api.github.com/users/hadley/repos")

summary.doc <- function(jsondata){
	
	# number of documents
	number.docs <- nrow(jsondata) 
	
	# number of 1st degree keys
	number.keys <- ncol(jsondata)
	
	# how
	docs.per.key <- 
	
	tibble(Key = colnames(jsondata) , Doc.count = docs.per.key)

	# vector to pass to summary.key
	#invisible(jsondata)
	
}







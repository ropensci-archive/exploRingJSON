
library(jsonlite)
library(tibble)


rm(list=ls())

jsondata <- fromJSON("https://api.github.com/users/hadley/repos")

summary.doc <- function(jsondata){
  # number of documents
  R <- nrow(jsondata)
  # number of 1st degree keys
  J <- ncol(jsondata)
	
	dummy_json <- matrix(0,R,J)
	docs.class <- rep(NA, J)
	docs.size <- rep(NA, J)
	for (j in 1:J){
	  docs.class[j] <- class(jsondata[,j])
	  docs.size[j] <- length(jsondata[,j]) # won't this give the length of each column = R?
		# nested apply functions (ugh) below might also work
		for (i in 1:R){
			if (length(jsondata[i,j])==1){dummy_json[i,j] <- is.na(jsondata[i,j])}
		}
	}
	
	docs.per.key <- R - colSums(dummy_json)
	
	# add type of each key, total depth
	tibble(Key = colnames(jsondata) , Doc.count = docs.per.key, 
	       Class = docs.class, Obj.len = docs.size)

	# vector to pass to summary.key
	# invisible(jsondata)
}







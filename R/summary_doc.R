
library(jsonlite)
library(tibble)


rm(list=ls())

jsondata <- fromJSON("https://api.github.com/users/hadley/repos")

summary.doc <- function(jsondata){
  # number of documents
  R <- nrow(jsondata)
  # number of 1st degree keys
  J <- ncol(jsondata)
	
	dummy.json <- matrix(0,R,J)
	docs.class <- rep(NA, J)
	all.docs.size <- matrix(0,R,J)
	for (j in 1:J){
	  docs.class[j] <- class(jsondata[,j])
		# nested apply functions (ugh) below might also work
		for (i in 1:R){
			if (length(jsondata[i,j])==1){dummy.json[i,j] <- is.na(jsondata[i,j])}
			all.docs.size[i,j] <- length(jsondata[i,j])
		}
	}
	
	docs.per.key <- R - colSums(dummy.json)
	docs.size <- apply(all.docs.size,2,max)
	
	# add type of each key, total depth
	print(tibble(Key = colnames(jsondata) , Doc.count = docs.per.key, 
	       Class = docs.class, Obj.len = docs.size, Is.terminal = docs.size == 1))

	# vector to pass to summary.key
	invisible(jsondata)
}







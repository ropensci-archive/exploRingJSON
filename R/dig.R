#' Dig into a JSON data frame.
#' 
#' @param jsondata
#' @param keyname 
#' @param rs \code{logical} Short for return summary. Should \code{dig} return the data or a summary of the data? 
#' 
#' @example 
#' library(jsonlite)
#' jsondata <- fromJSON("https://api.github.com/users/hadley/repos", flatten = FALSE)
#' jsondata %>% dig("owner") %>% dig("type")
#' jsondata %>% dig("owner", rs= T) 
dig <- function(jsondata, keyname, rs = FALSE){
  if (!(keyname %in% names(jsondata))){
    stop("Error: Provided key name is not a key in the current level. Keep digging!")
  }
  if(rs){
    summary(jsondata[,keyname])
  } else{
    jsondata[,keyname]
  }
}
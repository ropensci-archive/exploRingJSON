# Summary of rjson and rjsonio packages

## rjson

### Package Functions:
newJsonParser - convert a collection of JSONobjects to R objects
fromJSON - convert a JSON object into an R object
toJSON - convert R to JSON (lists must have named components)

## rjsonio

### Package Functions:
asJSVars - takes R objects and serializes them as JavaScript/Action Script values
basicJSONHandler - creates a handler object that is used to consume tokens/elements from a JSONparser and
combine them into R objects
Bob - symbolic constants identifying the type of a json value
fromJSON - convert JSON content to R objects (deserializes into R objects) maps into R data types: logical, integer, numeric, character, named lists
isValidJSON - test
readJSONstream - parse from open connection
toJSON - convert an R object to a string in JavaScript notation

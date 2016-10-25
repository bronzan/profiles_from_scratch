## prevent getting hosed by factors
options(stringsAsFactors = FALSE)

## input frame
input_fn <- "average_tmax_2100.csv"

## file to relate cells to counties
grid_fn <- "grid.classify.csv"

## load data and grid
tmax <- read.csv(input_fn)
grid <- read.csv(grid_fn)

##merge grid with data file
tmax <- merge(grid, tmax, by=c("LON","LAT"))

##set up county output file
cty <- data.frame()

##loop through GEOIDs, calculate means, build county data frame
for (g in unique(tmax$GEOID)) {
	tmax_subset <- tmax[tmax$GEOID == g,]
	newrow <- c(tmax_subset[1,3:5], colMeans(tmax_subset[,10:374]))
	newrow <- as.vector(unlist(newrow))
	cty <- rbind(cty, newrow)
}
colnames(cty) <- c(colnames(tmax)[c(3,4,5,10:length(colnames(tmax)))])

## make temp data numeric
for (i in 4:368) {
	cty[,i] <- as.numeric(cty[,i])
	cty[,i] <- round(cty[,i], digits = 2)
}




## Load reference files
msa <- read.csv(file="MSAtoCounty.csv")
tvm <- read.csv(file="tvm_msas.csv"

tvm_profiles <- data.frame()
## Cycle through markets, subset "cty", take means, and add to output table (tvm_profiles)

for (i in 1:nrow(tvm)) {
	market_counties <- msa$FIPS[tvm$Data.Source[i] == msa$MSA.Name]
	market_subset <- cty[cty$GEOID %in% market_counties,]
	values <- round(as.numeric(colMeans(market_subset[,4:368])), digits = 2)
	newrow <- as.vector(unlist(c(tvm[i,1:2],values)))
	tvm_profiles <- rbind(tvm_profiles, newrow)
}

## make data rows numeric
for (i in 3:ncol(tvm_profiles)) {
	tvm_profiles[,i] <- as.numeric(tvm_profiles[,i])
}

##fix column names
colnames(tvm_profiles) <- c("Market", "MSA", colnames(cty)[4:368])
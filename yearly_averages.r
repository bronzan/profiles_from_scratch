# parse 52,232 X 7313 grid into yearly averages (1 model)

options(stringsAsFactors = FALSE)
modelnames <- c("access1-0","bcc-csm1-1-m","bcc-csm1-1","canesm2","ccsm4","cesm1-bgc","cesm1-cam5","cmcc-cm","cnrm-cm5","csiro-mk3-6-0","fgoals-g2","fio-esm","gfdl-cm3","gfdl-esm2g","gfdl-esm2m","giss-e2-r","hadgem2-ao","hadgem2-cc","hadgem2-es","inmcm4","ipsl-cm5a-mr","ipsl-cm5b-lr","miroc-esm-chem","miroc-esm","miroc5_rcp85","mpi-esm-lr","mpi-esm-mr","mri-cgcm3","noresm1-m")
models <- c("access1-0_rcp85_r1i1p1","bcc-csm1-1-m_rcp85_r1i1p1","bcc-csm1-1_rcp85_r1i1p1","canesm2_rcp85_r1i1p1","ccsm4_rcp85_r1i1p1","cesm1-bgc_rcp85_r1i1p1","cesm1-cam5_rcp85_r1i1p1","cmcc-cm_rcp85_r1i1p1","cnrm-cm5_rcp85_r1i1p1","csiro-mk3-6-0_rcp85_r1i1p1","fgoals-g2_rcp85_r1i1p1","fio-esm_rcp85_r1i1p1","gfdl-cm3_rcp85_r1i1p1","gfdl-esm2g_rcp85_r1i1p1","gfdl-esm2m_rcp85_r1i1p1","giss-e2-r_rcp85_r1i1p1","hadgem2-ao_rcp85_r1i1p1","hadgem2-cc_rcp85_r1i1p1","hadgem2-es_rcp85_r1i1p1","inmcm4_rcp85_r1i1p1","ipsl-cm5a-mr_rcp85_r1i1p1","ipsl-cm5b-lr_rcp85_r1i1p1","miroc-esm-chem_rcp85_r1i1p1","miroc-esm_rcp85_r1i1p1","miroc5_rcp85_r1i1p1","mpi-esm-lr_rcp85_r1i1p1","mpi-esm-mr_rcp85_r1i1p1","mri-cgcm3_rcp85_r1i1p1","noresm1-m_rcp85_r1i1p1")

# construct dates

month <- c("01","02","03","04","05","06","07","08","09","10","11","12")
enddates <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
ydates <- c()

for (m in 1:12) {
	mdates <- c(paste0(month[m], "0", 1:9), paste0(month[m], 10:enddates[m]))
	ydates <- c(ydates, mdates)
}

# initialize annual average


writenamer <- function(model, yr, mtype) {
	basename <- paste0("tasmax/")
	name <- paste0(basename,"conus_c5.",model,".daily.",yr,".",mtype,".Rdata");
}


year <- "2080" ## Here is where you would adjust to iterate through 20-year periods

for (mod in 1:29) {
# loop through dates, assemble data frame of daily averages per year.
model <- models[mod]
fn <- writenamer(model, year, "tasmax")

modelname <- modelnames[mod]  ## here is where you would adjust to iterate through models
print(paste("Model", model, "at", Sys.time()))
load(fn)
annualavg <- df[,1:3]



for (d in ydates) {
	dfsubset <- df[,substr(colnames(df),6,10) == d]
	date_average <- rowMeans(dfsubset)
	annualavg <- cbind(annualavg, date_average)
	colnames(annualavg)[length(colnames(annualavg))] <- paste0("x", d)


}

save(annualavg, file=paste0("model_profiles/annual_profile_", year, "_", modelname, ".", "RData"))

}


source("https://raw.githubusercontent.com/jcervas/R-Functions/main/GERRYfunctions.R")
# Will eventually replace with full list of URLs
# urls <- c("https://results.enr.clarityelections.com//GA/Appling/105371/269554/json/","https://results.enr.clarityelections.com//GA/Sumter/105499/270350/json/")
urls <- read.csv("https://raw.githubusercontent.com/jcervas/Georgia-2020/main/Georgia%202020%20Vote%20Links.csv", header=F)
urls <- unlist(urls)

# For looping through three types of ballots
votetype.json <- c("Election_Day_Votes", "Absentee_by_Mail_Votes", "Advanced_Voting_Votes", "Provisional_Votes") # No longer necessary, ALL.json has all the data aggregated. Keep in case we want to view differences

tmp <- list()
for (j in 1:length(urls)) {
		# cnty.tmp1 <- fromJSON(paste0(urls[j], votetype.json[1], ".json"))
		# cnty.tmp2 <- fromJSON(paste0(urls[j], votetype.json[2], ".json"))
		# cnty.tmp3 <- fromJSON(paste0(urls[j], votetype.json[3], ".json"))
		# cnty.tmp4 <- fromJSON(paste0(urls[j], votetype.json[4], ".json"))
		cnty.tmp <- jsonlite::fromJSON(paste0(urls[j],"ALL.json"))
			dem.tmp <- list()
			rep.tmp <- list()
			other.tmp <- list()
			k.list <- length(cnty.tmp$Contests$A) - 1 # Last row is the county total...
		for (k in 1:k.list) {
			# cnty.tmp.tmp1 <- unlist(cnty.tmp1$Contests$V[[k]][1])
			# cnty.tmp.tmp2 <- unlist(cnty.tmp2$Contests$V[[k]][1])
			# cnty.tmp.tmp3 <- unlist(cnty.tmp3$Contests$V[[k]][1])
			# cnty.tmp.tmp4 <- unlist(cnty.tmp4$Contests$V[[k]][1])
			# rep.tmp[[k]] <- cnty.tmp.tmp1[1]+cnty.tmp.tmp2[1]+cnty.tmp.tmp3[1]+cnty.tmp.tmp4[1]
			# dem.tmp[[k]] <- cnty.tmp.tmp1[2]+cnty.tmp.tmp2[2]+cnty.tmp.tmp3[2]+cnty.tmp.tmp4[2]
			# other.tmp[[k]] <- cnty.tmp.tmp1[3]+cnty.tmp.tmp2[3]+cnty.tmp.tmp3[3]+cnty.tmp.tmp4[3]
			cnty.tmp.tmp <- unlist(cnty.tmp$Contests$V[[k]][1])
			rep.tmp[[k]] <- cnty.tmp.tmp[1]
			dem.tmp[[k]] <- cnty.tmp.tmp[2]
			other.tmp[[k]] <- cnty.tmp.tmp[3]
			}
			precinct.list <- cnty.tmp$Contests$A
			precinct.list <- precinct.list[1:k.list]
			# Test code to get county name
				cnty.tmp <- substring(urls[j], regexpr("GA/", urls[j]) +3)
				county.name <- sub("\\/.*", "", cnty.tmp)
	tmp[[j]] <- data.frame(state="Georgia",county=rep(county.name,k.list),precinct=precinct.list,rep=do.call(rbind,rep.tmp),dem=do.call(rbind,dem.tmp),other=do.call(rbind,other.tmp)) #Creates list of precincts, by county
}

GA_precincts <- do.call(rbind, tmp)
head(GA_precincts)
GA_precincts$precinct <- toupper(GA_precincts$precinct)
GA_precincts$dem_TP <- as.integer(100*round(replaceNA(two_party(GA_precincts$dem,GA_precincts$rep)),1))
write.csv(GA_precincts, "/Users/user/Google Drive/GitHub/Georgia-2020/GA_precincts_pres.csv", row.names=F)

# We also need precinct shapefiles to match on.
# https://doi.org/10.7910/DVN/XPW7T7

# library(rgdal)
u <- "https://raw.githubusercontent.com/jcervas/Georgia-2020/main/ga_2020_general.json"
# downloader::download(url = u, destfile = "/tmp/ga.GeoJSON")
# ga <- readOGR(dsn = "/tmp/ga.GeoJSON", layer = "OGRGeoJSON")
ga <- readOGR(dsn = u, layer = "ga_2020_general")
plot(ga)
urls <- c("https://results.enr.clarityelections.com//GA/Appling/105371/269554/json/","https://results.enr.clarityelections.com//GA/Sumter/105499/270350/json/")

votetype.json <- c("Election_Day_Votes", "Absentee_by_Mail_Votes", "Advanced_Voting_Votes", "Provisional_Votes")

tmp <- list()
for (j in 1:length(urls)) {
		cnty.tmp1 <- fromJSON(paste0(urls[j], votetype.json[1], ".json"))
		cnty.tmp2 <- fromJSON(paste0(urls[j], votetype.json[2], ".json"))
		cnty.tmp3 <- fromJSON(paste0(urls[j], votetype.json[3], ".json"))
		cnty.tmp4 <- fromJSON(paste0(urls[j], votetype.json[4], ".json"))
			dem.tmp <- list()
			rep.tmp <- list()
			other.tmp <- list()
			k.list <- length(cnty.tmp1$Contests$A) - 1 # Last row is the county total...
		for (k in 1:k.list) {
			cnty.tmp.tmp1 <- unlist(cnty.tmp1$Contests$V[[k]][1])
			cnty.tmp.tmp2 <- unlist(cnty.tmp2$Contests$V[[k]][1])
			cnty.tmp.tmp3 <- unlist(cnty.tmp3$Contests$V[[k]][1])
			cnty.tmp.tmp4 <- unlist(cnty.tmp4$Contests$V[[k]][1])
			rep.tmp[[k]] <- cnty.tmp.tmp1[1]+cnty.tmp.tmp2[1]+cnty.tmp.tmp3[1]+cnty.tmp.tmp4[1]
			dem.tmp[[k]] <- cnty.tmp.tmp1[2]+cnty.tmp.tmp2[2]+cnty.tmp.tmp3[2]+cnty.tmp.tmp4[2]
			other.tmp[[k]] <- cnty.tmp.tmp1[3]+cnty.tmp.tmp2[3]+cnty.tmp.tmp3[3]+cnty.tmp.tmp4[3]
			}
			precinct.list <- cnty.tmp1$Contests$A
			precinct.list <- precinct.list[1:k.list]
	tmp[[j]] <- data.frame(state="Georgia",precinct=precinct.list,rep=do.call(rbind,rep.tmp),dem=do.call(rbind,dem.tmp),other=do.call(rbind,other.tmp))
}



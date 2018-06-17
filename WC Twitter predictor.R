###WC Twitter Analysis
library(twitteR)
library(tidyverse)
library(httr)
library(jsonlite)
library(lubridate)
library(stringr)
setwd("C:/Users/sagge/Documents/Betting")

consumer_key <- ""
consumer_secret <- ""
access_token <- ""
access_secret <- ""
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


fixtures = read.csv("fifa-world-cup-2018-GMTStandardTime.csv")
fixtures = fixtures[-(1:4),]
fixtures = fixtures[-(45:60),]
fixtures$Date = dmy_hm(fixtures$Date)

i = 6
for (x in 1:99999999){
  if (format.POSIXct(fixtures$Date[i], format = "%Y-%m-%d %H:%M") == format.POSIXct(Sys.time(), format = "%Y-%m-%d %H:%M")){
    Team1 = fixtures$Home.Team[i]
    Team2 = fixtures$Away.Team[i]
    tweets = strip_retweets(searchTwitter(paste0(Team1, " +", Team2, " +prediction"), n = 3200, since = "2018-06-07"))
    tweets = twListToDF(tweets)
    tweets$Team = str_extract(tweets$text, paste0(Team1, "|", Team2))
    tweets$Scores = str_extract(tweets$text, "\\s\\d-\\d\\s|\\s\\d:\\d\\s")
    
    Match = as.data.frame(tweets$Team)
    colnames(Match) = "Team"
    Match$Score = tweets$Scores
    Match = Match[!is.na(Match$Score),]
    Match = Match[!is.na(Match$Team),]
    Match$One = str_extract(Match$Score, "\\d")
    Match$Two = str_extract(Match$Score, "(\\d+)(?!.*\\d)")
    Match$One = as.integer(Match$One)
    Match$Two = as.integer(Match$Two)
    Match$Team = as.character((Match$Team))
    Match$Team1Score = Match$One
    Match$Team2Score = Match$Two
    Match$Team2Score[Match$Team == Team2] = Match$One[Match$Team == Team2]
    Match$Team1Score[Match$Team == Team2] = Match$Two[Match$Team == Team2]
    Match$Result[Match$Team1Score > Match$Team2Score] = "Win"
    Match$Result[Match$Team1Score == Match$Team2Score] = "Draw"
    Match$Result[Match$Team1Score < Match$Team2Score] = "Loss"
    Match$NewResult = paste0(Match$Team1Score, "-", Match$Team2Score)
    Mode = names(which.max(table(Match$NewResult)))
    table(Match$Result)
    prop.table(table(Match$Result))
    Probs = as.data.frame(prop.table(table(Match$Result)))
    updateStatus(paste0(Team1, " vs ", Team2, ":\n", Team1, " Win: ", round(Probs[3,2]*100, 2), "%\n", "Draw: ",
                        round(Probs[1,2]*100, 2), "%\n", Team1, " Lose: ", round(Probs[2,2]*100, 2), "%\nModal Score: ",
                        Mode, "\nAvg goals per team: ", round(mean(Match$Team1Score, na.rm = T)), "-", round(mean(Match$Team2Score, na.rm = T))))
    i = i + 1
  }
  Sys.sleep(30)
  
}

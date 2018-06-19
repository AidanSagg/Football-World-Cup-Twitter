# Football-World-Cup-Twitter
Using Twitter data to model implied probability for each World Cup match. 
--------------------------------------------------------------------------------------------------------
The idea was to use tweets to calculate implied probability for each match in the world cup. The old wisdom of the crowd theory.
The data will still be available after the tournament, as we can specify the any dates to search for tweets for. The script is 
running on a Google server, so that the tweet will go out as each match kicks off. Win/Draw/Lose probabilities are calculated as 
well as the modal (most predicted) score and the average score predicted (total goals per team/number of tweets).
We noticed that the implied probability for draws was lower, we suspect this is due to the fact that people aren't going to tweet
a prediction and sit on the fence. Also, any fans of the team are going to tweet their team to win. Some bias is introduced.
Currently working on calibrating for this...

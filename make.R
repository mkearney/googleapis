devtools::load_all()
api_call("asdf")

rt <- rtweet::search_tweets("trump is the worst president", include_rts = FALSE)
text <- rt$text[1:5]

x <- analyze_sentiment(text)
x


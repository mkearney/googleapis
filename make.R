## build funs
devtools::load_all()
devtools::document()

## fetch text to analyze
rt <- rtweet::search_tweets("trump is the worst president", include_rts = FALSE)
text <- rt$text[1:5]

## sentiment analysis
x <- analyze_sentiment(text)
x


## build funs
devtools::load_all()
devtools::document()

## fetch text to analyze
rt <- rtweet::search_tweets("lang:en", include_rts = FALSE)

## sentiment analysis
df <- analyze_sentiment(rt$text)
as.data.frame(df)
tibble::as_tibble(df)

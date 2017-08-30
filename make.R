## build funs
devtools::load_all()
devtools::document()

## fetch text to analyze
rt <- rtweet::search_tweets("#rstats lang:en", include_rts = FALSE)

## sentiment analysis
txt <- prep_text(rt$text[1:5])
df <- analyze_sentiment(txt)
df
as.data.frame(df)

options(width = 200)
tibble::as_tibble(df)

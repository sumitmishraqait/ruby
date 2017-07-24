Feature:Yahoo Finance stock gainer page
Background:
  Given I am yahoo finance gainer page

@1
Scenario:Selct watchlist-name dropdown list and print dropdown list element
When I click on click on watchlist-name dropdown
Then I have dropdown list with following values
|Recently Viewed |
|Currencies|
|Trending Tickers|
|Stocks:Most Actives|
|Stocks:Gainers|
|Stocks:Losers|
|Commodities|
|Top Mutual Funds|
|World Indices|
|US Treasury Bond Rates|
@2
Scenario:Select option and check its visibility
When I have selected any option from watchlist-name
Then I should see the option as selected
@3
Scenario:Select option and check its header
When I select any option from watchlist-name
Then I should see follwing  header for list
|Symbol|
|Company|
|Last price|
|Changes|
|%changes|
|52-week range|
|Day chart|
@4
Scenario:Select Mutual fund option and give error message
When I select mutual fund option
Then I should get error message  "Sorry, but we were unable to retrieve your list. Redirecting to Yahoo Finance Home in a few seconds."
@5
Scenario:Select Currency option and check its values
When I select currency option
And I select any data symbol
Then I should see its following values
|Symbol|
|Company|
|Last price|

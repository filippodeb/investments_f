"""Download data."""

from market_data import MarketData, DataProvider
from tickers import EU_tickers_trading212, NASDAQ100_tickers

#md_eu = MarketData()
#md_eu.get_returns(tickers=EU_tickers_trading212, years_of_observations=1).to_excel("EUROSTOXX_ret_250.xlsx")
md_usa = MarketData(DataProvider.ALPACA)
md_usa.get_returns(tickers=NASDAQ100_tickers, years_of_observations=1).to_excel("NASDAQ100_ret_250_alpaca.xlsx")
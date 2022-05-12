"""Download data."""

from market_data import MarketData
from tickers import EU_tickers_trading212, NASDAQ100_tickers

md = MarketData()
md.get_returns(tickers=EU_tickers_trading212, years_of_observations=1).to_excel("EUROSTOXX_ret_250.xlsx")
md.get_returns(tickers=NASDAQ100_tickers, years_of_observations=1).to_excel("NASDAQ100_ret_250.xlsx")
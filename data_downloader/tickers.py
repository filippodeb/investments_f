"""List of tickers."""
import pandas as pd

SP500_tickers = pd.read_html(
    "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
)[0]["Symbol"].tolist()

NASDAQ100_tickers = pd.read_html("https://en.wikipedia.org/wiki/Nasdaq-100")[3][
    "Ticker"
].tolist()

EUROSTOXX50_tickers = pd.read_html("https://en.wikipedia.org/wiki/EURO_STOXX_50")[3][
    "Ticker"
].tolist()

DOW_JONES_tickers = pd.read_html(
    "https://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average"
)[1]["Symbol"].tolist()

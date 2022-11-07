"""Market data."""
import pandas as pd
from typing import Tuple, Optional
from pandas.tseries.offsets import BDay
import yfinance as yf
import numpy as np
from enum import Enum
from alpaca_market_data import AlpacaMarketDataAPI

class DataProvider(str, Enum):
    """Data providers enum."""

    YAHOO_FINANCE = "YAHOO_FINANCE"
    ALPACA = "ALPACA"

class MarketData:

    def __init__(self, data_provider: DataProvider) -> None:
        self.data_provider = data_provider
        if self.data_provider == DataProvider.ALPACA:
            self.alpaca_api = AlpacaMarketDataAPI()


    def _get_prices(
        self,
        tickers: Tuple[str, ...],
        start_date: Optional[pd.Timestamp] = None,
        years_of_observations: Optional[int] = None,
        end_date: pd.Timestamp = pd.Timestamp.today().normalize() - BDay(1),  # type: ignore
    ) -> pd.DataFrame:
        """Get prices.

        Parmaters
        ---------
        tickers
            A tuple of str representing the tickers.
        end_date
            A pd.Timestamp representing end date
        start_date
            A pd.Timestamp representing start date
        years_of_observations
            An int representing how many years of data are asked.

        Returns
        -------
        prices
            pd.DataFrame with market prices.
        """
        if start_date and years_of_observations:
            raise AssertionError(
                "You can pass start_date or years_of_observations, but not both."
            )
        start_date = (
            (end_date - pd.DateOffset(years=years_of_observations))  # type: ignore
            if years_of_observations
            else start_date
        )
        assert isinstance(start_date, pd.Timestamp), "Pass at least one param (start_date or years_of_observations)"
        if self.data_provider == DataProvider.YAHOO_FINANCE:
            prices = yf.download(
                tickers,
                start=start_date,
                end=end_date,
                progress=False,
                show_errors=False,
            )
            prices = prices.loc[:, "Adj Close"]
            if isinstance(prices, pd.Series):
                prices = pd.DataFrame(prices)
            if len(prices.columns) == 1:
                prices.columns = tickers
            prices.index = pd.to_datetime(prices.index).normalize().tz_localize(None)
        elif self.data_provider == DataProvider.ALPACA:
            prices = self.alpaca_api.get_timeseries(tickers, start_date, end_date)
        prices[prices <= 0.0] = np.nan
        return prices.loc[:, list(tickers)]

    def get_returns(
        self,
        tickers: Tuple[str, ...],
        start_date: Optional[pd.Timestamp] = None,
        years_of_observations: Optional[int] = None,
        end_date: pd.Timestamp = pd.Timestamp.today().normalize() - BDay(1),  # type: ignore
        required_pct_obs: float = 0.95,
    ) -> pd.DataFrame:
        """Set and get returns from prices.

        Parameters
        ----------
        tickers
            A tuple of str representing the tickers.
        end_date
            A pd.Timestamp representing end date
        start_date
            A pd.Timestamp representing start date
        years_of_observations
            An int representing how many years of data are requested.
        required_pct_obs
            Minimum treshold for non NaNs in each column.
            Columns with more NaNs(%)>required_pct_obs will be dropped.

        Returns
        -------
        returns
            pd.DataFrame with market linear returns.
        """
        prices = self._get_prices(
            tickers=tickers,
            start_date=start_date,
            end_date=end_date,
            years_of_observations=years_of_observations,
        )
        returns: pd.DataFrame = prices.pct_change().iloc[1:, :]
        returns = returns.dropna(
            axis=1, thresh=int(len(returns) * required_pct_obs)
        ).fillna(0.0)
        return returns
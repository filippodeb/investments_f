"""Alpaca Market Data API module."""
import asyncio
import logging
from typing import Any, Dict, Tuple

import pandas as pd


import pandas as pd
from alpaca.data import (
    Adjustment,
    StockBarsRequest,
    StockHistoricalDataClient,
    StockLatestQuoteRequest,
    TimeFrame,
)

logging.basicConfig(level=logging.INFO)
log: logging.Logger = logging.getLogger(__name__)


class AlpacaMarketDataAPI(StockHistoricalDataClient):
    """Class that handles market data connection with Alpaca."""

    def __init__(
        self,
        api_key: str = "PK1T1OB5EWVXCXY360Y1",
        secret_key: str = "hW9CQKsSqPcicwbLujGiyH32ZcXBIr4yxv5MB6vT",
    ) -> None:
        super().__init__(api_key=api_key, secret_key=secret_key, raw_data=True)

    async def _bars_request(
        self,
        tickers: Tuple[str, ...],
        start_date: pd.Timestamp,
        end_date: pd.Timestamp,
        timeframe: TimeFrame = TimeFrame.Day,
    ) -> Dict[str, Any]:
        """Convert the bars request to a thread."""
        return await asyncio.to_thread(
            self.get_stock_bars,
            StockBarsRequest(
                symbol_or_symbols=list(tickers),
                timeframe=timeframe,
                start=start_date,
                end=end_date + pd.Timedelta(5, unit="hours"),  # needed to include last day
                adjustment=Adjustment.ALL,
            ),
        )

    async def _get_timeseries(
        self,
        tickers: Tuple[str, ...],
        start_date: pd.Timestamp,
        end_date: pd.Timestamp,
        timeframe: TimeFrame = TimeFrame.Day,
    ) -> pd.DataFrame:
        """Helper method to get bars for a list of tickers from Alpaca."""
        bars = await self._bars_request(
            tickers=tickers,
            start_date=start_date,
            end_date=end_date,
            timeframe=timeframe,
        )
        # TODO: remove type ignore when dependencies are aligned
        bars = pd.DataFrame(  # type: ignore
            {ticker: pd.DataFrame(bars[ticker]).set_index("t")["c"] for ticker in bars}
        )
        bars.index = pd.to_datetime(bars.index).normalize().tz_localize(None)  # type: ignore
        return pd.DataFrame(
            bars, columns=list(tickers), index=bars.index
        )

    async def get_timeseries_async(
        self,
        tickers: Tuple[str, ...],
        start_date: pd.Timestamp,
        end_date: pd.Timestamp,
        timeframe: TimeFrame = TimeFrame.Day,
        tickers_bucket_size: int = 100,
    ) -> pd.DataFrame:
        """Async function to run to get all timeseries."""
        bucket_requests = []
        for i in range(0, len(tickers), tickers_bucket_size):
            tickers_bucket = tickers[i : i + tickers_bucket_size]
            bucket_requests.append(
                self._get_timeseries(
                    tickers=tickers_bucket,
                    start_date=start_date,
                    end_date=end_date,
                    timeframe=timeframe,
                )
            )
        # TODO: remove type ignore when dependencies are aligned
        return await asyncio.gather(*bucket_requests)  # type: ignore

    def get_timeseries(
        self,
        tickers: Tuple[str, ...],
        start_date: pd.Timestamp,
        end_date: pd.Timestamp,
        timeframe: TimeFrame = TimeFrame.Day,
    ) -> pd.DataFrame:
        """Method to get timeseries data for a list of tickers from Alpaca."""
        # TODO: remove type ignore when dependencies are aligned
        return pd.concat(  # type: ignore
            asyncio.run(
                main=self.get_timeseries_async(
                    tickers=tickers,
                    start_date=start_date,
                    end_date=end_date,
                    timeframe=timeframe,
                )
            ),
            axis=1,
        )

    def get_latest_quotes(self, tickers: Tuple[str, ...]) -> Dict[str, Dict[str, Any]]:
        """Get the latest quotes."""
        return self.get_stock_latest_quote(StockLatestQuoteRequest(symbol_or_symbols=list(tickers)))

    def get_current_buy_prices(self, tickers: Tuple[str, ...]) -> pd.Series:
        """Get the current bid prices for an array of tickers."""
        latest_quotes = self.get_latest_quotes(tickers)
        return pd.Series({ticker: latest_quotes[ticker]["bp"] for ticker in latest_quotes})

    def get_current_sell_prices(self, tickers: Tuple[str, ...]) -> pd.Series:
        """Get the current ask prices for an array of tickers."""
        latest_quotes = self.get_latest_quotes(tickers)
        return pd.Series({ticker: latest_quotes[ticker]["ap"] for ticker in latest_quotes})

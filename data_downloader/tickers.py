"""List of tickers."""
from typing import Tuple

import pandas as pd

SP500_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/List_of_S%26P_500_companies")[0][
        "Symbol"
    ].tolist()
)

NASDAQ100_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/Nasdaq-100")[4]["Ticker"].tolist()
)

EUROSTOXX50_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/EURO_STOXX_50")[4]["Ticker"].tolist()
)

DOW_JONES_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average")[1][
        "Symbol"
    ].tolist()
)

EU_tickers_trading212: Tuple[str, ...] = (
    "ADS.DE",
    "ADYEN.AS",
    "AD.AS",
    "AI.PA",
    "AIR.PA",
    "ALV.DE",
    "ABI.BR",
    "ASML.AS",
    "CS.PA",
    "BAS.DE",
    "BAYN.DE",
    "BBVA.MC",
    "SAN.MC",
    "BMW.DE",
    "BNP.PA",
    "BN.PA",
    "DB1.DE",
    "DPW.DE",
    "DTE.DE",
    "EL.PA",
    "FLTR.L",  
    "RMS.PA",  
    "IBE.MC",
    "ITX.MC",
    "IFX.DE",
    "INGA.AS",
    "KER.PA",
    "OR.PA",
    "MC.PA",
    "MBG.DE",
    "MUV2.DE",
    "RI.PA",
    "PRX.AS",
    "SAF.PA",
    "SGO.PA",
    "SAN.PA",
    "SAP.DE",
    "SU.PA",
    "SIE.DE",
    "TTE.PA",
    "DG.PA",
    "VOW.DE"
)

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
    "AMS.MC",
    "ABI.BR",
    "ASML.AS",
    "CS.PA",
    "BAS.DE",
    "BAYN.DE",
    "BMW.DE",
    "BNP.PA",
    "DAI.DE",
    "BN.PA",
    "DB1.DE",
    "DPW.DE",
    "DTE.DE",
    "ENGI.PA",
    "EL.PA",
    "FLTR.L",    
    "IBE.MC",
    "ITX.MC",
    "IFX.DE",
    "INGA.AS",
    "KER.PA",
    "OR.PA",
    "MC.PA",
    "MUV2.DE",
    "RI.PA",
    "ORA.PA",
    "PHIA.AS",
    "PRX.AS",
    "SAF.PA",
    "SAN.PA",
    "SAN.MC",
    "SAP.DE",
    "SU.PA",
    "SIE.DE",
    "TEF.MC",
    "TTE.PA",
    "DG.PA",
    "VIV.PA",
    "VOW.DE",
    "VNA.DE"
)

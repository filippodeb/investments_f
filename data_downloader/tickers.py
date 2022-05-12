"""List of tickers."""
from typing import Tuple

import pandas as pd

SP500_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/List_of_S%26P_500_companies")[0][
        "Symbol"
    ].tolist()
)

NASDAQ100_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/Nasdaq-100")[3]["Ticker"].tolist()
)

EUROSTOXX50_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/EURO_STOXX_50")[3]["Ticker"].tolist()
)

DOW_JONES_tickers: Tuple[str, ...] = tuple(
    pd.read_html("https://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average")[1][
        "Symbol"
    ].tolist()
)

EU_tickers_trading212: Tuple[str, ...] = (
    "ASML.AS",
    "MC.PA",
    "LIN.DE",
    "SAP.DE",
    "TTE.PA",
    "SIE.DE",
    "SAN.PA",
    "OR.PA",
    "SU.PA",
    "ALV.DE",
    "AI.PA",
    "BNP.PA",
    "PRX.AS",
    "AIR.PA",
    "BAS.DE",
    "DAI.DE",
    "IBE.MC",
    "DG.PA",
    "CS.PA",
    "DTE.DE",
    "BNC.L",
    "DPW.DE",
    "EL.PA",
    "ADYEN.AS",
    "ABI.BR",
    "BAYN.DE",
    "INGA.AS",
    "KER.PA",
    "IFX.DE",
    "RMS.PA",
    "ADS.DE",
    "SAF.PA",
    "MUV2.DE",
    "BBVA.MC",
    "BN.PA",
    "CRH.L",
    "VOW3.DE",
    "VNA.DE",
    "ITX.MC",
    "AD.AS",
    "BMW.DE",
    "DB1.DE",
    "PHIA.AS",
    "FLTR.L",
)

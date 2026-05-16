# 🇮🇩 Indonesia Trade & Maritime Intelligence Dashboard

> **Interactive R Shiny dashboard analyzing Indonesia's trade performance, commodity exports, major ports, and maritime shipping routes (2018–2023)**

[![R Shiny](https://img.shields.io/badge/Built%20with-R%20Shiny-276DC3?logo=r)](https://shiny.posit.co)
[![Data](https://img.shields.io/badge/Data-BPS%20%7C%20UN%20Comtrade%20%7C%20UNCTAD-059669)](https://bps.go.id)
[![Live Demo](https://img.shields.io/badge/🚀%20Live%20Demo-shinyapps.io-blue)](https://ardityaapusing.shinyapps.io/indonesia-trade-dashboard)

---

## 📊 Dashboard Preview

**5 analytical sections — fully interactive:**

| Section | What you see |
|---------|-------------|
| 📈 **Trade Overview** | Annual export/import trends 2018–2023, monthly patterns, trade balance |
| 📦 **Commodity Analysis** | Top export/import commodities, YoY change, category breakdown |
| 🌏 **Trade Partners** | Export & import by country, bilateral trade balance |
| ⚓ **Ports & Maritime** | Interactive port map, cargo volumes, shipping routes |
| 🗺️ **Provincial Export** | Province-level export map, regional commodity specialization |

---

## 🔑 Key Findings

- **Indonesia's trade surplus** peaked at **+$54.5B in 2022** (commodity supercycle), normalizing to **+$36.9B in 2023**
- **China** is Indonesia's largest partner on both sides: #1 export destination ($61.2B) AND #1 import source ($64.3B) — a structural concentration risk
- **Nickel value-add success**: Nickel exports grew **+375%** from $3.2B (2018) to $15.2B (2023), validating the downstream processing policy
- **Palm oil risk**: EU deforestation regulation and price correction caused a **-32.7% drop** ($39.1B → $26.3B) in 2023
- **Port concentration**: Tanjung Priok handles **35% of national cargo throughput** — eastern Indonesia ports remain severely underutilized
- **Sulawesi Tengah** emerged as the **5th largest exporting province** driven entirely by nickel processing — a regional transformation story

---

## 🚀 Run Locally

### Prerequisites
```r
# Install required packages
install.packages(c(
  "shiny", "ggplot2", "plotly", "dplyr", "tidyr",
  "scales", "leaflet", "DT"
))
```

### Launch
```r
# Clone the repo, then in RStudio:
shiny::runApp(".")

# Or from R console:
setwd("path/to/indonesia-trade-maritime-dashboard")
shiny::runApp()
```

---

## 📁 Project Structure

```
indonesia-trade-maritime-dashboard/
├── app.R        ← Main Shiny application (UI + Server)
├── global.R     ← Data preparation, helper functions, all datasets
└── README.md    ← Documentation
```

---

## 📊 Data Sources

| Dataset | Source | URL |
|---------|--------|-----|
| Annual export/import value | BPS — Statistik Perdagangan Luar Negeri | [bps.go.id](https://www.bps.go.id) |
| Commodity breakdown | UN Comtrade Database | [comtrade.un.org](https://comtrade.un.org) |
| Trade by partner country | UN Comtrade + BPS | [comtrade.un.org](https://comtrade.un.org) |
| Port cargo volumes | Kemenhub RI — Buku Informasi Transportasi | [dephub.go.id](https://dephub.go.id) |
| Provincial export data | BPS — Ekspor Menurut Provinsi | [bps.go.id](https://www.bps.go.id) |
| Maritime route data | UNCTAD Maritime Statistics | [unctadstat.unctad.org](https://unctadstat.unctad.org) |

> **Note:** All data in this dashboard is based on publicly available official statistics from Indonesian and international institutions. Values are embedded in `global.R` for reproducibility. For real-time data, connect directly to BPS API or UN Comtrade API.

---

## 🛠️ Tech Stack

```
Language   : R 4.3+
Framework  : Shiny
Charts     : Plotly (interactive) + ggplot2
Maps       : Leaflet
Tables     : DT (DataTables)
Fonts      : Plus Jakarta Sans (Google Fonts)
```

---

## 💡 Business Relevance

This dashboard was designed to serve the analytical needs of:

- **Shipping & logistics companies** (port performance, route demand, cargo trends)
- **Export-oriented manufacturers** (commodity price exposure, market diversification)
- **Financial institutions** (trade balance trends, country risk, sector exposure)
- **Government & policy** (provincial development gaps, strategic commodity analysis)
- **Investment analysts** (sector growth trends, FDI drivers)

---

## 🔭 Future Enhancements

- [ ] Real-time BPS API integration for auto-refresh
- [ ] Shipping route visualization on interactive map (leaflet polylines)
- [ ] Freight rate index integration (Baltic Dry Index, SCFI)
- [ ] Predictive trade model using time-series (ARIMA/Prophet)
- [ ] PDF report export per section

---

## 👤 Author

**Arditya Sulistya Ningsih Apusing, S.Stat.**
Statistics Graduate · Tadulako University · GPA 3.70/4.00 · Ranked #1

📧 ardityasulistya6@gmail.com
🔗 [linkedin.com/in/ardityaapusing](https://linkedin.com/in/ardityaapusing)
⌥ [github.com/ardityaapusing](https://github.com/ardityaapusing)

---

*"Understanding trade flows is understanding where economies are going."*

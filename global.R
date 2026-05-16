# ============================================================
# global.R — Data & Helper Functions
# Indonesia Trade & Maritime Intelligence Dashboard
# Author: Arditya Sulistya Ningsih Apusing, S.Stat.
# Data source: BPS, UN Comtrade, UNCTAD, Kemenhub RI
# ============================================================

library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(scales)
library(leaflet)
library(DT)

# ── COLORS ────────────────────────────────────────────────────────────────────
COL_PRIMARY   <- "#059669"
COL_SECONDARY <- "#0F172A"
COL_ACCENT    <- "#3B82F6"
COL_WARN      <- "#D97706"
COL_DANGER    <- "#DC2626"
COL_LIGHT     <- "#F8FAFC"
PALETTE_MAIN  <- c("#059669","#0F172A","#3B82F6","#D97706","#8B5CF6",
                   "#EC4899","#14B8A6","#F59E0B","#6366F1","#10B981")

# ── HELPER ────────────────────────────────────────────────────────────────────
fmt_usd <- function(x) {
  dplyr::case_when(
    abs(x) >= 1e9  ~ paste0("$", round(x/1e9,1), "B"),
    abs(x) >= 1e6  ~ paste0("$", round(x/1e6,1), "M"),
    TRUE            ~ paste0("$", round(x/1e3,0), "K")
  )
}
fmt_ton <- function(x) {
  dplyr::case_when(
    abs(x) >= 1e9  ~ paste0(round(x/1e9,2), " Bt"),
    abs(x) >= 1e6  ~ paste0(round(x/1e6,1), " Mt"),
    TRUE            ~ paste0(round(x/1e3,1), " Kt")
  )
}

# ── DATA: ANNUAL TRADE 2018-2023 ──────────────────────────────────────────────
# Source: BPS Indonesia — Statistik Perdagangan Luar Negeri
annual_trade <- data.frame(
  year    = 2018:2023,
  export  = c(180.2, 167.7, 163.2, 231.6, 291.9, 258.8),  # billion USD
  import  = c(188.7, 170.7, 141.6, 196.2, 237.7, 221.9),
  stringsAsFactors = FALSE
) %>%
  mutate(
    balance     = export - import,
    export_growth = c(NA, round(diff(export)/lag(export)*100, 1)),
    import_growth = c(NA, round(diff(import)/lag(import)*100, 1))
  )

# ── DATA: EXPORT BY COMMODITY ─────────────────────────────────────────────────
# Source: BPS — Komoditas Ekspor Utama Indonesia 2023
commodity_export <- data.frame(
  commodity = c("Palm Oil (CPO & Products)", "Coal & Lignite",
                "Nickel & Products", "Iron & Steel",
                "Machinery & Electrical", "Rubber & Products",
                "Petroleum Gas", "Copper & Products",
                "Seafood & Fishery", "Wood & Wood Products",
                "Chemical Products", "Cocoa & Products",
                "Garments & Textile", "Paper & Pulp", "Other"),
  value_2023 = c(26.3, 29.8, 15.2, 21.6, 18.4, 4.2,
                 9.7,  6.8,  2.1,  3.9,  5.3,  1.8,
                 6.2,  4.1,  43.4),  # billion USD
  value_2022 = c(39.1, 45.5, 12.8, 18.2, 16.9, 3.8,
                 11.2, 5.9,  2.0,  3.7,  5.1,  1.7,
                 6.5,  4.3,  51.2),
  category   = c("Agriculture","Mining","Mining","Manufacturing",
                 "Manufacturing","Agriculture","Energy","Mining",
                 "Agriculture","Forestry","Manufacturing","Agriculture",
                 "Manufacturing","Forestry","Other"),
  stringsAsFactors = FALSE
) %>%
  arrange(desc(value_2023)) %>%
  mutate(
    share     = round(value_2023 / sum(value_2023) * 100, 1),
    yoy_change = round((value_2023 - value_2022) / value_2022 * 100, 1)
  )

# ── DATA: IMPORT BY COMMODITY ─────────────────────────────────────────────────
commodity_import <- data.frame(
  commodity = c("Machinery & Mechanical Appliances", "Mineral Fuels & Oil",
                "Iron & Steel", "Electrical Equipment",
                "Organic Chemicals", "Plastics & Products",
                "Vehicles & Parts", "Aircraft & Spacecraft",
                "Fertilizers", "Cotton & Textiles",
                "Medical Instruments", "Animal Feed", "Other"),
  value_2023 = c(31.4, 24.8, 13.2, 16.7, 8.3, 7.1,
                 9.2,  3.8,  4.6,  5.1,  3.9, 2.7, 71.1),
  category   = c("Capital Goods","Energy","Raw Material","Capital Goods",
                 "Raw Material","Raw Material","Consumer Goods","Capital Goods",
                 "Raw Material","Raw Material","Capital Goods","Raw Material","Other"),
  stringsAsFactors = FALSE
) %>%
  arrange(desc(value_2023)) %>%
  mutate(share = round(value_2023 / sum(value_2023) * 100, 1))

# ── DATA: TRADE BY PARTNER COUNTRY ───────────────────────────────────────────
trade_partners <- data.frame(
  country     = c("China","USA","Japan","India","Singapore",
                  "South Korea","Malaysia","Philippines","Australia",
                  "Netherlands","Germany","Thailand","Vietnam","Others"),
  export_2023 = c(61.2, 22.4, 18.7, 21.6, 14.2,
                  8.9,  9.1,  7.3,  6.8,
                  4.2,  3.8,  5.1,  4.7, 70.8),
  import_2023 = c(64.3, 9.8,  15.2, 8.4,  23.1,
                  8.2,  7.9,  2.1,  4.6,
                  2.8,  5.3,  4.7,  3.2, 62.3),
  stringsAsFactors = FALSE
) %>%
  mutate(
    balance = export_2023 - import_2023,
    total   = export_2023 + import_2023
  )

# ── DATA: MAJOR PORTS ─────────────────────────────────────────────────────────
# Source: Kemenhub RI — Buku Informasi Transportasi 2023
ports <- data.frame(
  name      = c("Tanjung Priok","Tanjung Perak","Belawan",
                "Makassar","Balikpapan","Palembang",
                "Semarang","Panjang","Bitung","Pontianak"),
  city      = c("Jakarta","Surabaya","Medan",
                "Makassar","Balikpapan","Palembang",
                "Semarang","Bandar Lampung","Bitung","Pontianak"),
  province  = c("DKI Jakarta","Jawa Timur","Sumatera Utara",
                "Sulawesi Selatan","Kalimantan Timur","Sumatera Selatan",
                "Jawa Tengah","Lampung","Sulawesi Utara","Kalimantan Barat"),
  lat       = c(-6.104, -7.198, 3.785,
                -5.147, -1.265, -2.995,
                -6.978, -5.486, 1.443, -0.047),
  lon       = c(106.878, 112.737, 98.687,
                119.425, 116.839, 104.763,
                110.420, 105.278, 125.184, 109.332),
  cargo_mt  = c(73.8, 42.1, 21.4,
                14.2, 18.7, 12.3,
                16.8, 9.4,  5.2,  6.1),  # million tons
  container_teu = c(8200, 4100, 1850,
                    890,  NA,   NA,
                    1420, NA,   280,  NA),  # thousand TEU
  type      = c("Hub Internasional","Hub Internasional","Hub Internasional",
                "Regional","Regional","Regional",
                "Regional","Feeder","Feeder","Feeder"),
  stringsAsFactors = FALSE
)

# ── DATA: PROVINCIAL EXPORT ───────────────────────────────────────────────────
# Source: BPS — Ekspor Menurut Provinsi 2023 (top 15)
provincial_export <- data.frame(
  province    = c("Kalimantan Timur","Riau","Sumatera Selatan",
                  "Jawa Barat","Sulawesi Tengah","Papua",
                  "Banten","Jawa Timur","Riau Kepulauan",
                  "Kalimantan Selatan","Sumatera Utara","Jawa Tengah",
                  "DKI Jakarta","Sulawesi Selatan","Aceh"),
  export_usd  = c(32.4, 28.7, 18.2, 17.6, 14.3, 12.8,
                  11.9, 11.4, 9.7,  9.2,  8.8,  7.3,
                  6.9,  5.4,  4.1),  # billion USD
  main_commodity = c("Coal","Palm Oil","Coal & Rubber","Machinery",
                     "Nickel","Copper & Gold","Machinery","Palm Oil & Seafood",
                     "Electronics","Coal","Palm Oil","Textiles",
                     "Misc","Nickel & Cocoa","Palm Oil"),
  lat = c(-1.68, 0.29, -3.31, -6.91, -1.43, -4.27,
          -6.20, -7.54, 0.92, -3.09, 2.10, -7.15,
          -6.21, -5.10, 4.69),
  lon = c(116.42, 101.70, 104.48, 107.61, 121.90, 136.18,
          106.15, 112.24, 104.46, 115.51, 98.67, 110.14,
          106.85, 119.43, 96.75),
  stringsAsFactors = FALSE
) %>%
  arrange(desc(export_usd)) %>%
  mutate(
    rank  = row_number(),
    share = round(export_usd / sum(export_usd) * 100, 1)
  )

# ── DATA: MONTHLY TRADE 2023 ──────────────────────────────────────────────────
monthly_2023 <- data.frame(
  month       = month.abb,
  month_num   = 1:12,
  export      = c(22.3,20.9,21.8,19.7,21.4,20.8,
                  21.2,22.5,20.4,21.9,22.1,23.8),  # billion USD
  import      = c(18.4,17.9,19.2,18.1,19.6,18.7,
                  18.9,19.3,17.8,18.6,19.1,20.3),
  stringsAsFactors = FALSE
) %>%
  mutate(balance = export - import)

# ── DATA: SAMUDERA-RELEVANT SHIPPING ROUTES ───────────────────────────────────
shipping_routes <- data.frame(
  route       = c("Jakarta–Surabaya","Jakarta–Makassar","Surabaya–Balikpapan",
                  "Jakarta–Belawan","Makassar–Bitung","Surabaya–Makassar",
                  "Jakarta–Singapore","Belawan–Singapore","Surabaya–Darwin"),
  from_lat    = c(-6.104,-6.104,-7.198,-6.104,-5.147,-7.198,-6.104, 3.785,-7.198),
  from_lon    = c(106.878,106.878,112.737,106.878,119.425,112.737,106.878,98.687,112.737),
  to_lat      = c(-7.198,-5.147,-1.265, 3.785, 1.443,-5.147, 1.352, 1.352,-12.46),
  to_lon      = c(112.737,119.425,116.839,98.687,125.184,119.425,103.820,103.820,130.84),
  cargo_mt    = c(12.4, 8.7, 6.3, 9.8, 3.2, 7.1, 15.6, 11.2, 2.4),
  type        = c("Domestic","Domestic","Domestic","Domestic","Domestic",
                  "Domestic","International","International","International"),
  stringsAsFactors = FALSE
)

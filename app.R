# ============================================================
# app.R — Indonesia Trade & Maritime Intelligence Dashboard
# Author: Arditya Sulistya Ningsih Apusing, S.Stat.
# GitHub: github.com/ardityaapusing
# Data: BPS RI · UN Comtrade · UNCTAD · Kemenhub RI
# ============================================================

source("global.R")

# ════════════════════════════════════════════════════════════
# UI
# ════════════════════════════════════════════════════════════
ui <- fluidPage(
  tags$head(
    tags$title("Indonesia Trade & Maritime Intelligence"),
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap');
      * { font-family: 'Plus Jakarta Sans', sans-serif !important }
      body { background:#F8FAFC; margin:0; padding:0 }
      .navbar-custom {
        background:#0F172A; padding:1rem 2rem;
        display:flex; align-items:center; justify-content:space-between;
        border-bottom:2px solid #059669;
      }
      .navbar-title { color:white; font-size:1.1rem; font-weight:800 }
      .navbar-title span { color:#10B981 }
      .navbar-sub { color:rgba(255,255,255,.4); font-size:.72rem; font-weight:500; margin-top:.1rem }
      .navbar-badge { background:rgba(16,185,129,.15); border:1px solid rgba(16,185,129,.25);
        color:#10B981; padding:.3rem .85rem; border-radius:99px; font-size:.72rem; font-weight:700 }
      .kpi-row { display:grid; grid-template-columns:repeat(5,1fr); gap:1rem;
        padding:1.25rem 2rem; background:white; border-bottom:1px solid #E2E8F0 }
      .kpi { text-align:center; padding:.5rem 0 }
      .kpi-num { font-size:1.6rem; font-weight:800; color:#0F172A; line-height:1 }
      .kpi-num.green { color:#059669 }
      .kpi-num.red { color:#DC2626 }
      .kpi-lbl { font-size:.65rem; color:#64748B; font-weight:600; letter-spacing:.04em;
        text-transform:uppercase; margin-top:.2rem }
      .kpi-delta { font-size:.72rem; font-weight:600; margin-top:.15rem }
      .delta-up { color:#059669 }
      .delta-down { color:#DC2626 }
      .main-content { padding:1.5rem 2rem }
      .tab-panel-custom { background:white; border-radius:12px; padding:1.5rem;
        border:1px solid #E2E8F0; margin-top:1rem }
      .insight-box { background:#F0FDF4; border:1px solid #BBF7D0; border-radius:8px;
        padding:.85rem 1.1rem; margin:.75rem 0; font-size:.82rem; color:#166534;
        border-left:3px solid #059669 }
      .insight-box strong { color:#14532D }
      .insight-warn { background:#FFFBEB; border-color:#FDE68A; color:#92400E;
        border-left-color:#D97706 }
      .section-label { font-size:.68rem; font-weight:700; letter-spacing:.1em;
        text-transform:uppercase; color:#059669; margin-bottom:.5rem }
      .plot-title { font-size:.9rem; font-weight:700; color:#0F172A; margin-bottom:.25rem }
      .nav-tabs { border-bottom:2px solid #E2E8F0 !important }
      .nav-tabs > li > a { color:#64748B !important; font-weight:600 !important; font-size:.82rem !important }
      .nav-tabs > li.active > a { color:#059669 !important; border-bottom:2px solid #059669 !important; font-weight:700 !important }
      .footer-bar { background:#0F172A; color:rgba(255,255,255,.4); font-size:.72rem;
        padding:.85rem 2rem; text-align:center; margin-top:2rem }
      .footer-bar a { color:#10B981 !important; text-decoration:none }
      ::-webkit-scrollbar { width:4px; height:4px }
      ::-webkit-scrollbar-thumb { background:#059669; border-radius:4px }
    "))
  ),

  # ── NAVBAR ────────────────────────────────────────────────
  div(class="navbar-custom",
    div(
      div(class="navbar-title", "🇮🇩 Indonesia Trade & Maritime ", tags$span("Intelligence")),
      div(class="navbar-sub", "Data: BPS RI · UN Comtrade · UNCTAD · Kemenhub RI | 2018–2023")
    ),
    div(class="navbar-badge", "Portfolio Project · Arditya Apusing")
  ),

  # ── KPI STRIP ─────────────────────────────────────────────
  div(class="kpi-row",
    div(class="kpi",
      div(class="kpi-num green", "$258.8B"),
      div(class="kpi-lbl", "Total Export 2023"),
      div(class="kpi-delta delta-down", "▼ 11.3% vs 2022")
    ),
    div(class="kpi",
      div(class="kpi-num", "$221.9B"),
      div(class="kpi-lbl", "Total Import 2023"),
      div(class="kpi-delta delta-down", "▼ 6.6% vs 2022")
    ),
    div(class="kpi",
      div(class="kpi-num green", "+$36.9B"),
      div(class="kpi-lbl", "Trade Surplus 2023"),
      div(class="kpi-delta delta-down", "▼ 44.1% vs 2022")
    ),
    div(class="kpi",
      div(class="kpi-num", "73.8 Mt"),
      div(class="kpi-lbl", "Tanjung Priok Cargo"),
      div(class="kpi-delta delta-up", "▲ Largest in Indonesia")
    ),
    div(class="kpi",
      div(class="kpi-num green", "#2"),
      div(class="kpi-lbl", "ASEAN Largest Exporter"),
      div(class="kpi-delta", "After Singapore (re-export)")
    )
  ),

  # ── MAIN TABS ─────────────────────────────────────────────
  div(class="main-content",
    tabsetPanel(id="main_tabs",

      # TAB 1: OVERVIEW
      tabPanel("📈 Trade Overview",
        div(class="tab-panel-custom",
          fluidRow(
            column(8,
              div(class="section-label", "Annual Trade Performance 2018–2023"),
              plotlyOutput("plot_annual", height="320px")
            ),
            column(4,
              div(class="section-label", "Trade Balance Trend"),
              plotlyOutput("plot_balance", height="320px")
            )
          ),
          div(class="insight-box",
            "💡 ", tags$strong("Key Insight: "),
            "Indonesia recorded its highest-ever trade surplus in 2022 (+$54.5B) driven by commodity supercycle (coal, palm oil, nickel). The 2023 correction (-44% surplus) reflects global commodity price normalization, but Indonesia maintains a structural surplus for the 4th consecutive year — signaling strong export fundamentals."
          ),
          hr(),
          fluidRow(
            column(6,
              div(class="section-label", "Monthly Trade Pattern 2023"),
              plotlyOutput("plot_monthly", height="280px")
            ),
            column(6,
              div(class="section-label", "Export vs Import Decomposition"),
              plotlyOutput("plot_decomp", height="280px")
            )
          )
        )
      ),

      # TAB 2: COMMODITIES
      tabPanel("📦 Commodity Analysis",
        div(class="tab-panel-custom",
          fluidRow(
            column(6,
              div(class="section-label", "Top Export Commodities 2023 (Billion USD)"),
              plotlyOutput("plot_exp_commodity", height="420px")
            ),
            column(6,
              div(class="section-label", "Export by Category + YoY Change"),
              plotlyOutput("plot_commodity_yoy", height="420px")
            )
          ),
          div(class="insight-box insight-warn",
            "⚠️ ", tags$strong("Risk Alert: "),
            "Palm oil exports dropped 32.7% YoY ($39.1B → $26.3B) due to global price correction and EU deforestation regulation. Coal remains resilient at $29.8B despite Western ESG pressure — driven by Asian demand (China, India, Vietnam). Nickel value-add strategy showing results: $15.2B in 2023 vs $3.2B in 2018 (+375%)."
          ),
          hr(),
          fluidRow(
            column(6,
              div(class="section-label", "Top Import Commodities 2023"),
              plotlyOutput("plot_imp_commodity", height="320px")
            ),
            column(6,
              div(class="section-label", "Import Dependency by Category"),
              plotlyOutput("plot_imp_category", height="320px")
            )
          )
        )
      ),

      # TAB 3: TRADE PARTNERS
      tabPanel("🌏 Trade Partners",
        div(class="tab-panel-custom",
          fluidRow(
            column(7,
              div(class="section-label", "Export & Import by Country 2023 (Billion USD)"),
              plotlyOutput("plot_partners", height="400px")
            ),
            column(5,
              div(class="section-label", "Trade Balance per Partner"),
              plotlyOutput("plot_balance_partner", height="400px")
            )
          ),
          div(class="insight-box",
            "💡 ", tags$strong("Strategic Insight: "),
            "China dominates both sides — #1 export destination ($61.2B, 23.7% share) AND #1 import source ($64.3B). Indonesia runs a $3.1B trade deficit with China. The USA and India are bright spots: both show strong trade surpluses ($12.6B and $13.2B respectively). Singapore's $8.9B deficit reflects entrepôt re-export dynamics."
          ),
          hr(),
          div(class="section-label", "Full Partner Breakdown"),
          DTOutput("table_partners")
        )
      ),

      # TAB 4: PORTS & MARITIME
      tabPanel("⚓ Ports & Maritime",
        div(class="tab-panel-custom",
          fluidRow(
            column(8,
              div(class="section-label", "Major Indonesian Ports — Interactive Map"),
              leafletOutput("map_ports", height="400px")
            ),
            column(4,
              div(class="section-label", "Port Cargo Volume (Million Tons)"),
              plotlyOutput("plot_ports", height="400px")
            )
          ),
          div(class="insight-box",
            "💡 ", tags$strong("Maritime Insight: "),
            "Tanjung Priok handles 35% of Indonesia's total port throughput (73.8 Mt) — making it the clear national hub. However, the disparity between Priok and eastern ports (Bitung: 5.2 Mt, Makassar: 14.2 Mt) highlights the underdevelopment of eastern Indonesia maritime infrastructure — a strategic growth opportunity for domestic shipping operators."
          ),
          hr(),
          fluidRow(
            column(6,
              div(class="section-label", "Domestic Shipping Routes (Cargo Volume)"),
              plotlyOutput("plot_routes", height="280px")
            ),
            column(6,
              div(class="section-label", "Port Type Distribution"),
              plotlyOutput("plot_port_type", height="280px")
            )
          )
        )
      ),

      # TAB 5: PROVINCIAL
      tabPanel("🗺️ Provincial Export",
        div(class="tab-panel-custom",
          fluidRow(
            column(7,
              div(class="section-label", "Export by Province 2023 — Interactive Map"),
              leafletOutput("map_province", height="420px")
            ),
            column(5,
              div(class="section-label", "Top 15 Exporting Provinces"),
              plotlyOutput("plot_province", height="420px")
            )
          ),
          div(class="insight-box",
            "💡 ", tags$strong("Regional Insight: "),
            "Kalimantan Timur leads at $32.4B (mainly coal) — but commodity-dependent regions face structural risk. Jawa Barat ($17.6B, mainly machinery) shows more resilient, value-added export structure. Sulawesi Tengah's rapid rise to 5th ($14.3B) is driven entirely by nickel downstream processing — validating Indonesia's raw material ban policy success."
          ),
          hr(),
          div(class="section-label", "Provincial Export Detail"),
          DTOutput("table_province")
        )
      )

    ), # end tabsetPanel

    # ── FOOTER ──────────────────────────────────────────────
    div(class="footer-bar",
      HTML("Built by <strong style='color:#10B981'>Arditya Sulistya Ningsih Apusing, S.Stat.</strong> &nbsp;·&nbsp;
      Data: BPS RI (bps.go.id) · UN Comtrade (comtrade.un.org) · Kemenhub RI &nbsp;·&nbsp;
      <a href='https://github.com/ardityaapusing/indonesia-trade-maritime-dashboard'>GitHub</a> &nbsp;·&nbsp;
      <a href='https://linkedin.com/in/ardityaapusing'>LinkedIn</a>")
    )
  )
)

# ════════════════════════════════════════════════════════════
# SERVER
# ════════════════════════════════════════════════════════════
server <- function(input, output, session) {

  # ── THEME ─────────────────────────────────────────────────
  theme_dash <- function() {
    theme_minimal(base_size=12, base_family="") +
    theme(
      plot.background    = element_rect(fill="white", color=NA),
      panel.background   = element_rect(fill="white", color=NA),
      panel.grid.major   = element_line(color="#F1F5F9", size=.4),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(color="#64748B", size=9),
      axis.title         = element_text(color="#334155", size=9, face="bold"),
      plot.title         = element_text(color="#0F172A", size=11, face="bold"),
      legend.text        = element_text(color="#64748B", size=8),
      legend.title       = element_text(color="#334155", size=8, face="bold"),
      strip.text         = element_text(color="#334155", size=9, face="bold")
    )
  }

  plotly_config <- function(p) {
    p %>% layout(
      paper_bgcolor="white", plot_bgcolor="white",
      font=list(family="Plus Jakarta Sans"),
      margin=list(t=20, b=20, l=10, r=10)
    ) %>% config(displayModeBar=FALSE)
  }

  # ── TAB 1: OVERVIEW ───────────────────────────────────────
  output$plot_annual <- renderPlotly({
    df_long <- annual_trade %>%
      select(year, export, import) %>%
      pivot_longer(c(export, import), names_to="type", values_to="value") %>%
      mutate(type = ifelse(type=="export","Export","Import"))

    p <- plot_ly(df_long, x=~year, y=~value, color=~type,
      colors=c("Export"=COL_PRIMARY, "Import"=COL_SECONDARY),
      type="scatter", mode="lines+markers",
      line=list(width=2.5), marker=list(size=7),
      text=~paste0(type, " ", year, ": $", value, "B"),
      hoverinfo="text"
    ) %>%
    layout(
      yaxis=list(title="Billion USD", tickformat="$,.0f"),
      xaxis=list(title="", dtick=1),
      legend=list(orientation="h", y=1.1, x=0),
      hovermode="x unified"
    )
    plotly_config(p)
  })

  output$plot_balance <- renderPlotly({
    colors <- ifelse(annual_trade$balance > 0, COL_PRIMARY, COL_DANGER)
    p <- plot_ly(annual_trade, x=~year, y=~balance,
      type="bar", marker=list(color=colors, line=list(width=0)),
      text=~paste0(ifelse(balance>0,"+",""), round(balance,1), "B"),
      textposition="outside", hoverinfo="text"
    ) %>%
    add_trace(x=~year, y=~balance, type="scatter", mode="lines+markers",
      line=list(color=COL_PRIMARY, width=2, dash="dot"),
      marker=list(color=COL_PRIMARY, size=6), showlegend=FALSE
    ) %>%
    layout(
      yaxis=list(title="Billion USD"),
      xaxis=list(title="", dtick=1),
      showlegend=FALSE,
      shapes=list(list(type="line",x0=0,x1=1,xref="paper",y0=0,y1=0,
        line=list(color="black",width=1,dash="dash")))
    )
    plotly_config(p)
  })

  output$plot_monthly <- renderPlotly({
    p <- plot_ly(monthly_2023, x=~month, y=~export, name="Export",
      type="scatter", mode="lines+markers",
      line=list(color=COL_PRIMARY, width=2.5),
      marker=list(color=COL_PRIMARY, size=7)
    ) %>%
    add_trace(y=~import, name="Import",
      line=list(color=COL_SECONDARY, width=2.5, dash="dash"),
      marker=list(color=COL_SECONDARY, size=7)
    ) %>%
    add_trace(y=~balance, name="Balance",
      type="bar", marker=list(color=COL_ACCENT, opacity=.3),
      yaxis="y2"
    ) %>%
    layout(
      yaxis=list(title="Billion USD"),
      yaxis2=list(title="Balance", overlaying="y", side="right", showgrid=FALSE),
      xaxis=list(title=""),
      legend=list(orientation="h", y=1.1, font=list(size=10)),
      hovermode="x unified",
      barmode="overlay"
    )
    plotly_config(p)
  })

  output$plot_decomp <- renderPlotly({
    cats <- commodity_export %>%
      group_by(category) %>%
      summarise(export=sum(value_2023), .groups="drop") %>%
      arrange(desc(export))
    p <- plot_ly(cats, labels=~category, values=~export,
      type="pie", hole=.5,
      marker=list(colors=PALETTE_MAIN[1:nrow(cats)],
                  line=list(color="white", width=1.5)),
      textinfo="label+percent",
      hovertemplate="<b>%{label}</b><br>$%{value:.1f}B<br>%{percent}<extra></extra>"
    ) %>%
    layout(
      title=list(text="Export by Category", font=list(size=11)),
      showlegend=FALSE
    )
    plotly_config(p)
  })

  # ── TAB 2: COMMODITIES ────────────────────────────────────
  output$plot_exp_commodity <- renderPlotly({
    top12 <- head(commodity_export, 12) %>% filter(commodity != "Other")
    p <- plot_ly(top12 %>% arrange(value_2023),
      x=~value_2023, y=~reorder(commodity, value_2023),
      type="bar", orientation="h",
      marker=list(
        color=~value_2023,
        colorscale=list(list(0,"#BBF7D0"), list(1,"#059669")),
        showscale=FALSE,
        line=list(width=0)
      ),
      text=~paste0("$",value_2023,"B"),
      textposition="outside",
      hovertemplate="<b>%{y}</b><br>2023: $%{x:.1f}B<extra></extra>"
    ) %>%
    layout(
      xaxis=list(title="Billion USD"),
      yaxis=list(title=""),
      bargap=.3
    )
    plotly_config(p)
  })

  output$plot_commodity_yoy <- renderPlotly({
    top12 <- head(commodity_export, 12) %>%
      filter(commodity != "Other") %>%
      arrange(yoy_change)
    colors <- ifelse(top12$yoy_change >= 0, COL_PRIMARY, COL_DANGER)
    p <- plot_ly(top12,
      x=~yoy_change, y=~reorder(commodity, yoy_change),
      type="bar", orientation="h",
      marker=list(color=colors, line=list(width=0)),
      text=~paste0(ifelse(yoy_change>0,"+",""), yoy_change, "%"),
      textposition="outside",
      hovertemplate="<b>%{y}</b><br>YoY: %{x:.1f}%<extra></extra>"
    ) %>%
    layout(
      xaxis=list(title="YoY Change (%)",
        zeroline=TRUE, zerolinecolor="#E2E8F0", zerolinewidth=2),
      yaxis=list(title=""),
      shapes=list(list(type="line",x0=0,x1=0,y0=0,y1=1,yref="paper",
        line=list(color="#334155", width=1)))
    )
    plotly_config(p)
  })

  output$plot_imp_commodity <- renderPlotly({
    top10 <- head(commodity_import, 10) %>% filter(commodity!="Other") %>% arrange(value_2023)
    p <- plot_ly(top10,
      x=~value_2023, y=~reorder(commodity, value_2023),
      type="bar", orientation="h",
      marker=list(
        color=~value_2023,
        colorscale=list(list(0,"#BFDBFE"), list(1,"#2563EB")),
        showscale=FALSE, line=list(width=0)
      ),
      text=~paste0("$",value_2023,"B"), textposition="outside",
      hovertemplate="<b>%{y}</b><br>$%{x:.1f}B<extra></extra>"
    ) %>%
    layout(xaxis=list(title="Billion USD"), yaxis=list(title=""), bargap=.3)
    plotly_config(p)
  })

  output$plot_imp_category <- renderPlotly({
    cats <- commodity_import %>%
      group_by(category) %>%
      summarise(import=sum(value_2023), .groups="drop")
    p <- plot_ly(cats, labels=~category, values=~import,
      type="pie", hole=.5,
      marker=list(colors=c("#2563EB","#0EA5E9","#6366F1","#8B5CF6","#A78BFA"),
                  line=list(color="white",width=1.5)),
      textinfo="label+percent",
      hovertemplate="<b>%{label}</b><br>$%{value:.1f}B<extra></extra>"
    ) %>%
    layout(
      title=list(text="Import by Category", font=list(size=11)),
      showlegend=FALSE
    )
    plotly_config(p)
  })

  # ── TAB 3: PARTNERS ───────────────────────────────────────
  output$plot_partners <- renderPlotly({
    top10 <- trade_partners %>% filter(country!="Others") %>%
      arrange(desc(total)) %>% head(10)
    p <- plot_ly(top10 %>% arrange(export_2023),
      x=~export_2023, y=~reorder(country, export_2023),
      name="Export", type="bar", orientation="h",
      marker=list(color=COL_PRIMARY, line=list(width=0)),
      text=~paste0("$",export_2023,"B"), textposition="inside",
      insidetextanchor="start"
    ) %>%
    add_trace(x=~import_2023, y=~reorder(country, export_2023),
      name="Import", type="bar", orientation="h",
      marker=list(color=COL_ACCENT, opacity=.8, line=list(width=0)),
      text=~paste0("$",import_2023,"B"), textposition="inside",
      insidetextanchor="start"
    ) %>%
    layout(
      barmode="group", bargap=.3,
      xaxis=list(title="Billion USD"),
      yaxis=list(title=""),
      legend=list(orientation="h", y=1.1)
    )
    plotly_config(p)
  })

  output$plot_balance_partner <- renderPlotly({
    top10 <- trade_partners %>% filter(country!="Others") %>%
      arrange(balance)
    colors <- ifelse(top10$balance>=0, COL_PRIMARY, COL_DANGER)
    p <- plot_ly(top10,
      x=~balance, y=~reorder(country, balance),
      type="bar", orientation="h",
      marker=list(color=colors, line=list(width=0)),
      text=~paste0(ifelse(balance>0,"+",""),"$",round(balance,1),"B"),
      textposition="outside",
      hovertemplate="<b>%{y}</b><br>Balance: $%{x:.1f}B<extra></extra>"
    ) %>%
    layout(
      xaxis=list(title="Trade Balance (Billion USD)",
        zeroline=TRUE, zerolinecolor="#E2E8F0", zerolinewidth=2),
      yaxis=list(title="")
    )
    plotly_config(p)
  })

  output$table_partners <- renderDT({
    trade_partners %>%
      mutate(
        export_2023 = paste0("$", export_2023, "B"),
        import_2023 = paste0("$", import_2023, "B"),
        balance     = paste0(ifelse(balance>=0,"+",""), "$", round(balance,1), "B")
      ) %>%
      rename(Country=country, Export=export_2023, Import=import_2023,
             Balance=balance, `Total Trade`=total) %>%
      datatable(
        rownames=FALSE, options=list(pageLength=14, dom="t"),
        class="stripe hover compact"
      ) %>%
      formatStyle("Balance",
        color=styleInterval(0, c("#DC2626","#059669")),
        fontWeight="bold"
      )
  }, server=FALSE)

  # ── TAB 4: PORTS ──────────────────────────────────────────
  output$map_ports <- renderLeaflet({
    pal <- colorFactor(c("#059669","#3B82F6","#D97706"), ports$type)
    leaflet(ports) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng=~lon, lat=~lat,
        radius=~sqrt(cargo_mt) * 2.5,
        color=~pal(type), fillColor=~pal(type),
        fillOpacity=.75, opacity=1, weight=2,
        popup=~paste0(
          "<strong>", name, "</strong><br>",
          "<em>", city, ", ", province, "</em><br>",
          "Cargo: ", cargo_mt, " Mt/year<br>",
          "Type: ", type,
          ifelse(!is.na(container_teu),
            paste0("<br>Container: ", container_teu, "K TEU"), "")
        ),
        label=~name
      ) %>%
      addLegend("bottomright", pal=pal, values=~type,
        title="Port Type", opacity=.9) %>%
      setView(lng=117, lat=-2, zoom=4.5)
  })

  output$plot_ports <- renderPlotly({
    p <- plot_ly(ports %>% arrange(cargo_mt),
      x=~cargo_mt, y=~reorder(name, cargo_mt),
      type="bar", orientation="h",
      marker=list(
        color=~cargo_mt,
        colorscale=list(list(0,"#BBF7D0"),list(1,"#059669")),
        showscale=FALSE, line=list(width=0)
      ),
      text=~paste0(cargo_mt, " Mt"),
      textposition="outside",
      hovertemplate="<b>%{y}</b><br>%{x} Million Tons<extra></extra>"
    ) %>%
    layout(
      xaxis=list(title="Million Tons/year"),
      yaxis=list(title=""), bargap=.3
    )
    plotly_config(p)
  })

  output$plot_routes <- renderPlotly({
    p <- plot_ly(shipping_routes %>% arrange(cargo_mt),
      x=~cargo_mt, y=~reorder(route, cargo_mt),
      type="bar", orientation="h",
      color=~type, colors=c("Domestic"=COL_PRIMARY,"International"=COL_ACCENT),
      text=~paste0(cargo_mt, " Mt"),
      textposition="outside",
      hovertemplate="<b>%{y}</b><br>%{x:.1f} Mt<extra></extra>"
    ) %>%
    layout(
      xaxis=list(title="Million Tons"), yaxis=list(title=""),
      legend=list(orientation="h", y=1.05, font=list(size=9)),
      bargap=.3
    )
    plotly_config(p)
  })

  output$plot_port_type <- renderPlotly({
    type_sum <- ports %>%
      group_by(type) %>%
      summarise(cargo=sum(cargo_mt), n=n(), .groups="drop")
    p <- plot_ly(type_sum, labels=~type, values=~cargo,
      type="pie", hole=.5,
      marker=list(colors=c(COL_PRIMARY,COL_ACCENT,COL_WARN),
        line=list(color="white",width=2)),
      textinfo="label+percent",
      hovertemplate="<b>%{label}</b><br>%{value:.1f} Mt<extra></extra>"
    ) %>%
    layout(showlegend=TRUE,
      legend=list(orientation="h", y=-.1, font=list(size=9)))
    plotly_config(p)
  })

  # ── TAB 5: PROVINCIAL ─────────────────────────────────────
  output$map_province <- renderLeaflet({
    pal <- colorNumeric(c("#BBF7D0","#059669","#0F172A"), provincial_export$export_usd)
    leaflet(provincial_export) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng=~lon, lat=~lat,
        radius=~sqrt(export_usd) * 2,
        fillColor=~pal(export_usd),
        color="white", weight=1.5,
        fillOpacity=.8,
        popup=~paste0(
          "<strong>", province, "</strong><br>",
          "Rank: #", rank, "<br>",
          "Export: $", export_usd, "B<br>",
          "Share: ", share, "%<br>",
          "Main: ", main_commodity
        ),
        label=~province
      ) %>%
      addLegend("bottomright", pal=pal, values=~export_usd,
        title="Export (Billion USD)", opacity=.9) %>%
      setView(lng=117, lat=-2, zoom=4.5)
  })

  output$plot_province <- renderPlotly({
    p <- plot_ly(provincial_export %>% arrange(export_usd),
      x=~export_usd, y=~reorder(province, export_usd),
      type="bar", orientation="h",
      marker=list(
        color=~export_usd,
        colorscale=list(list(0,"#BBF7D0"),list(1,"#059669")),
        showscale=FALSE, line=list(width=0)
      ),
      text=~paste0("$",export_usd,"B"), textposition="outside",
      hovertemplate="<b>%{y}</b><br>$%{x:.1f}B | %{customdata}",
      customdata=~main_commodity
    ) %>%
    layout(
      xaxis=list(title="Billion USD"), yaxis=list(title=""), bargap=.25
    )
    plotly_config(p)
  })

  output$table_province <- renderDT({
    provincial_export %>%
      select(rank, province, export_usd, share, main_commodity) %>%
      mutate(export_usd = paste0("$",export_usd,"B"),
             share = paste0(share,"%")) %>%
      rename(`#`=rank, Province=province, `Export 2023`=export_usd,
             `Share`=share, `Main Commodity`=main_commodity) %>%
      datatable(rownames=FALSE, options=list(pageLength=15,dom="t"),
        class="stripe hover compact")
  }, server=FALSE)

}

# ════════════════════════════════════════════════════════════
shinyApp(ui=ui, server=server)

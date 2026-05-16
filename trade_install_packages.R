# install_packages.R
# Run this ONCE before launching the dashboard

packages <- c(
  "shiny",    # Web framework
  "ggplot2",  # Static charts
  "plotly",   # Interactive charts
  "dplyr",    # Data manipulation
  "tidyr",    # Data reshaping
  "scales",   # Number formatting
  "leaflet",  # Interactive maps
  "DT"        # Interactive tables
)

install.packages(packages)
cat("✅ All packages installed. Run shiny::runApp() to launch.\n")

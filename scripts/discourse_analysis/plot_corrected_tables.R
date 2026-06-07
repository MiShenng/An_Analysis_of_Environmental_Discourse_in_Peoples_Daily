tables_dir <- file.path("results", "tables")
figures_dir <- file.path("results", "figures")

dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)

plot_yearly_distribution <- function(csv_name, output_name, title, y_label = "Percentage (%)") {
  df <- read.csv(file.path(tables_dir, csv_name), stringsAsFactors = FALSE, fileEncoding = "UTF-8")
  df$year <- as.numeric(df$year)
  df$percentage <- as.numeric(df$percentage)
  df <- df[!is.na(df$year) & !is.na(df$percentage), ]

  categories <- unique(df$category)
  png(file.path(figures_dir, output_name), width = 1800, height = 1100, res = 180)
  par(mar = c(5, 5, 4, 12), xpd = TRUE)

  plot(
    NA,
    xlim = range(df$year, na.rm = TRUE),
    ylim = c(0, max(df$percentage, na.rm = TRUE) * 1.08),
    xlab = "Year",
    ylab = y_label,
    main = title
  )

  line_types <- seq_along(categories)
  shades <- gray(seq(0.15, 0.75, length.out = length(categories)))

  for (i in seq_along(categories)) {
    item <- df[df$category == categories[i], ]
    item <- item[order(item$year), ]
    lines(item$year, item$percentage, col = shades[i], lwd = 2, lty = line_types[i])
    points(item$year, item$percentage, col = shades[i], pch = 16, cex = 0.6)
  }

  legend(
    "right",
    inset = c(-0.34, 0),
    legend = categories,
    col = shades,
    lty = line_types,
    lwd = 2,
    bty = "n",
    cex = 0.8
  )
  dev.off()
}

plot_yearly_distribution(
  "yearly_topic_distribution.csv",
  "yearly_topic_distribution.png",
  "Yearly Topic Distribution"
)

plot_yearly_distribution(
  "yearly_sentiment_distribution.csv",
  "yearly_sentiment_distribution.png",
  "Yearly Sentiment Distribution"
)

plot_yearly_distribution(
  "yearly_genre_distribution.csv",
  "yearly_genre_distribution.png",
  "Yearly Genre Distribution"
)

plot_yearly_distribution(
  "yearly_subject_distribution.csv",
  "yearly_subject_distribution.png",
  "Yearly Subject Distribution"
)


# Bloomroot MMM - model
library(Robyn)
library(readr)

df <- read_csv("data/marketing_weekly_clean.csv")

paid_media_spends <- c(
  "google_brand_spend", "google_nonbrand_spend",
  "meta_prospecting_spend", "meta_retargeting_spend",
  "tiktok_spend", "affiliate_spend"
)

paid_media_vars <- c(
  "google_brand_impressions", "google_nonbrand_impressions",
  "meta_prospecting_impressions", "meta_retargeting_impressions",
  "tiktok_impressions", "affiliate_clicks"
)

InputCollect <- robyn_inputs(
  dt_input          = df,
  dt_holidays       = dt_prophet_holidays,
  date_var          = "week",
  dep_var           = "revenue",
  dep_var_type      = "revenue",
  prophet_vars      = c("trend", "season", "holiday"),
  prophet_country   = "GB",
  paid_media_spends = paid_media_spends,
  paid_media_vars   = paid_media_vars,
  context_vars      = c("promo_active"),
  window_start      = "2024-01-01",
  window_end        = "2025-12-31",
  adstock           = "geometric"
)

# Per-channel adstock and saturation ranges
hyperparameters <- list(
  google_brand_spend_alphas      = c(0.5, 3),
  google_brand_spend_gammas      = c(0.3, 1),
  google_brand_spend_thetas      = c(0, 0.2),
  google_nonbrand_spend_alphas   = c(0.5, 3),
  google_nonbrand_spend_gammas   = c(0.3, 1),
  google_nonbrand_spend_thetas   = c(0, 0.3),
  meta_prospecting_spend_alphas  = c(0.5, 3),
  meta_prospecting_spend_gammas  = c(0.3, 1),
  meta_prospecting_spend_thetas  = c(0.1, 0.4),
  meta_retargeting_spend_alphas  = c(0.5, 3),
  meta_retargeting_spend_gammas  = c(0.3, 1),
  meta_retargeting_spend_thetas  = c(0, 0.2),
  tiktok_spend_alphas            = c(0.5, 3),
  tiktok_spend_gammas            = c(0.3, 1),
  tiktok_spend_thetas            = c(0.1, 0.4),
  affiliate_spend_alphas         = c(0.5, 3),
  affiliate_spend_gammas         = c(0.3, 1),
  affiliate_spend_thetas         = c(0.1, 0.5),
  train_size                     = c(0.5, 0.8)
)

# Calibration from Q4 2024 geo lift tests
calibration_input <- data.frame(
  channel           = c("tiktok_spend", "meta_prospecting_spend"),
  liftStartDate     = as.Date(c("2024-10-01", "2024-11-01")),
  liftEndDate       = as.Date(c("2024-10-31", "2024-11-30")),
  liftAbs           = c(48000, 72000),
  spend             = c(35000, 80000),
  confidence        = c(0.85, 0.80),
  metric            = c("revenue", "revenue"),
  calibration_scope = c("immediate", "immediate")
)

InputCollect <- robyn_inputs(
  InputCollect      = InputCollect,
  hyperparameters   = hyperparameters,
  calibration_input = calibration_input
)

OutputModels <- robyn_run(
  InputCollect  = InputCollect,
  cores         = 4,
  iterations    = 2000,
  trials        = 5,
  ts_validation = TRUE
)

OutputCollect <- robyn_outputs(
  InputCollect, OutputModels,
  pareto_fronts = "auto",
  clusters      = TRUE,
  csv_out       = "pareto",
  plot_folder   = "./output/"
)

# Model selected after reviewing Pareto cluster one-pagers
select_model <- "3_142_1"
robyn_write(InputCollect, OutputCollect, select_model, dir = "./output")

# Optimise Q2 budget — channels constrained to ±30% of last 13 weeks
AllocatorCollect <- robyn_allocator(
  InputCollect       = InputCollect,
  OutputCollect      = OutputCollect,
  select_model       = select_model,
  scenario           = "max_response",
  channel_constr_low = rep(0.7, length(paid_media_spends)),
  channel_constr_up  = rep(1.3, length(paid_media_spends)),
  date_range         = "last_13",
  export             = TRUE
)

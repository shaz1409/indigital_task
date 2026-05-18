# Bloomroot MMM — handover

You've just inherited this small repo. It was built by an analyst at our agency for one of our clients, Bloomroot Wellness (a UK DTC supplements brand, ~£600k/quarter on paid media across six channels). The analyst has since left.

The Head of Growth at Bloomroot wants to use the model's output for Q2 budget planning. We need to advise them.

## What's in the repo

```
brief.md            this file
data_prep.R         cleans the weekly marketing data
data_modelling.R    fits the MMM (Robyn)
run_mmm.py          orchestrates the two R scripts and surfaces the allocator output
```

The input data sits at `data/marketing_weekly.csv` (not in this snapshot). Assume it has, weekly for two years:

- `week`, `revenue`
- One `*_spend` column per channel: `google_brand`, `google_nonbrand`, `meta_prospecting`, `meta_retargeting`, `tiktok`, `affiliate`
- One exposure column per channel (`*_impressions`, except `affiliate_clicks`)
- `promo_flag` — `Y`/`N` for weeks with a site-wide promo running

## What we'd like from you

Spend a few minutes reading through. Then talk us through:

1. **What's happening** — what is this pipeline doing, end to end?
2. **What you recognise** — concepts, libraries, modelling choices you've seen or used before.
3. **What you'd research** — before you'd feel comfortable owning this codebase in production.
4. **What you'd ask the previous analyst** — about decisions you can't infer from the code alone.
5. **What you would add to the codebase** — future optimisation thoughts.

You don't need to run anything. Read it like a code review.

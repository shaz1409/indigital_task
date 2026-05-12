# bloomroot-mmm

Weekly marketing mix model for Bloomroot Wellness. Robyn under the hood.

## Files

| File | Purpose |
|---|---|
| `brief.md` | Client context and what we built this for |
| `data_prep.R` | Cleans `data/marketing_weekly.csv` → `data/marketing_weekly_clean.csv` |
| `data_modelling.R` | Fits the Robyn model, exports the selected solution and an allocator recommendation |
| `run_mmm.py` | Runs both R scripts and prints the budget recommendation |

## Run

```bash
python run_mmm.py
```

Requires R with `Robyn` installed, Python 3.10+, and `pandas`.

## Outputs

- `output/<model_id>/` — Robyn one-pagers, decomposition plots, exported model
- `output/<model_id>/<model_id>_reallocated.csv` — budget recommendation
- `output/pareto_*.csv` — Pareto front candidates

# Bloomroot MMM - orchestrator
import subprocess
import sys
from pathlib import Path

import pandas as pd

OUTPUT_DIR = Path("output")
SELECT_MODEL = "3_142_1"


def run_r_script(script: str) -> None:
    result = subprocess.run(
        ["Rscript", script],
        capture_output=True,
        text=True,
        check=False,
    )
    sys.stdout.write(result.stdout)
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        raise RuntimeError(f"{script} failed")


def main() -> None:
    run_r_script("data_prep.R")
    run_r_script("data_modelling.R")

    allocation = pd.read_csv(
        OUTPUT_DIR / SELECT_MODEL / f"{SELECT_MODEL}_reallocated.csv"
    )
    summary = allocation[[
        "channels", "init_spend_unit", "optm_spend_unit", "optm_response_unit_total"
    ]].rename(columns={
        "init_spend_unit":         "current_weekly_spend",
        "optm_spend_unit":         "recommended_weekly_spend",
        "optm_response_unit_total": "expected_weekly_revenue",
    })
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()

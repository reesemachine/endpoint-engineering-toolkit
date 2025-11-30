#!/usr/bin/env python3
"""
Reads inventory JSON files (Windows/macOS) and flattens them into a single CSV.
"""

import json
import csv
import glob
import sys
from pathlib import Path

def main(input_pattern: str, output_csv: str):
    rows = []
    for path in glob.glob(input_pattern):
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
        rows.append({
            "hostname": data.get("ComputerName") or data.get("hostname"),
            "serial": data.get("SerialNumber") or data.get("serial"),
            "model": data.get("Model") or data.get("model_identifier"),
            "os_version": data.get("OSVersion") or data.get("os_version"),
            "filevault": data.get("filevault", ""),
            "timestamp": data.get("Timestamp") or data.get("timestamp_utc")
        })

    if not rows:
        print("No matching files.")
        return

    keys = rows[0].keys()
    with open(output_csv, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=keys)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Wrote {len(rows)} records to {output_csv}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: inventory_to_csv.py '<input_pattern>' <output.csv>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])

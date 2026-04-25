import pandas as pd

from config import (
    RAW_DATA_FILE,
    ANOMALY_DATA_FILE,
    TEMP_LIMIT,
    PRESSURE_LIMIT,
    VIBRATION_LIMIT,
    OIL_LEVEL_LIMIT,
)


def detect_anomaly(row):
    issues = []

    if row["temperature"] > TEMP_LIMIT:
        issues.append("High Temperature")

    if row["pressure"] > PRESSURE_LIMIT:
        issues.append("High Pressure")

    if row["vibration"] > VIBRATION_LIMIT:
        issues.append("High Vibration")

    if row["oil_level"] < OIL_LEVEL_LIMIT:
        issues.append("Low Oil Level")

    if issues:
        return ", ".join(issues)

    return "Normal"


def run_anomaly_detection():
    df = pd.read_csv(RAW_DATA_FILE)

    df["anomaly_status"] = df.apply(detect_anomaly, axis=1)

    df.to_csv(ANOMALY_DATA_FILE, index=False)

    print(f"Anomaly detection complete: {ANOMALY_DATA_FILE}")


if __name__ == "__main__":
    run_anomaly_detection()
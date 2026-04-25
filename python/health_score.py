import pandas as pd

from config import ANOMALY_DATA_FILE, HEALTH_SCORE_FILE


def calculate_health_score(group):
    total_readings = len(group)
    anomaly_count = (group["anomaly_status"] != "Normal").sum()

    health_score = 100 - ((anomaly_count / total_readings) * 100)

    return round(health_score, 2)


def run_health_score():
    df = pd.read_csv(ANOMALY_DATA_FILE)

    health_scores = (
        df.groupby("equipment_id")
        .apply(calculate_health_score)
        .reset_index(name="health_score")
    )

    health_scores["status"] = health_scores["health_score"].apply(
        lambda score: "Healthy" if score >= 80 else "Needs Maintenance"
    )

    health_scores.to_csv(HEALTH_SCORE_FILE, index=False)

    print(f"Health scores created: {HEALTH_SCORE_FILE}")
    print(health_scores)


if __name__ == "__main__":
    run_health_score()
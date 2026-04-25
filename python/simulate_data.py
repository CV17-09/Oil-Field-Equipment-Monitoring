import csv
import os
from datetime import datetime, timedelta

import random

from config import DATA_DIR, RAW_DATA_FILE


def simulate_sensor_data(rows=500):
    os.makedirs(DATA_DIR, exist_ok=True)

    data = []
    start_time = datetime.now()

    for i in range(rows):
        data.append({
            "equipment_id": random.randint(1, 6),
            "timestamp": start_time + timedelta(minutes=i),
            "temperature": round(random.gauss(80, 10), 2),
            "pressure": round(random.gauss(200, 20), 2),
            "vibration": round(random.gauss(5, 2), 2),
            "oil_level": round(random.gauss(50, 10), 2),
            "runtime_hours": round(random.uniform(100, 1000), 2)
        })

    with open(RAW_DATA_FILE, mode="w", newline="") as csvfile:
        fieldnames = ["equipment_id", "timestamp", "temperature", "pressure", "vibration", "oil_level", "runtime_hours"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for row in data:
            row["timestamp"] = row["timestamp"].isoformat()
            writer.writerow(row)

    print(f"Sensor data created: {RAW_DATA_FILE}")


if __name__ == "__main__":
    simulate_sensor_data()
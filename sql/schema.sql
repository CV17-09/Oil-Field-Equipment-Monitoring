CREATE TABLE equipment_monitoring (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    timestamp DATETIME NOT NULL,
    temperature REAL NOT NULL,
    pressure REAL NOT NULL,
    vibration REAL NOT NULL,
    oil_level REAL NOT NULL,
    runtime_hours REAL NOT NULL,
    anomaly_status TEXT NOT NULL
);

CREATE TABLE equipment_health (
    equipment_id INTEGER PRIMARY KEY,
    health_score REAL NOT NULL,
    status TEXT NOT NULL
);
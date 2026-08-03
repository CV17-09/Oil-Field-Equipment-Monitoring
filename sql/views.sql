-- ============================================================
-- Reusable database views
-- ============================================================


-- ============================================================
-- 1. Complete equipment overview
-- Combines equipment health scores with sensor readings.
-- ============================================================

DROP VIEW IF EXISTS equipment_overview;

CREATE VIEW equipment_overview AS
SELECT
    em.id AS reading_id,
    em.equipment_id,
    em.timestamp,
    em.temperature,
    em.pressure,
    em.vibration,
    em.oil_level,
    em.runtime_hours,
    em.anomaly_status,
    eh.health_score,
    eh.status AS health_status
FROM equipment_monitoring AS em
LEFT JOIN equipment_health AS eh
    ON em.equipment_id = eh.equipment_id;


-- ============================================================
-- 2. Abnormal sensor readings
-- Contains only readings marked as anomalies.
-- ============================================================

DROP VIEW IF EXISTS active_anomalies;

CREATE VIEW active_anomalies AS
SELECT
    id AS reading_id,
    equipment_id,
    timestamp,
    temperature,
    pressure,
    vibration,
    oil_level,
    runtime_hours,
    anomaly_status
FROM equipment_monitoring
WHERE anomaly_status <> 'Normal';


-- ============================================================
-- 3. Equipment performance summary
-- Calculates average and extreme values for each machine.
-- ============================================================

DROP VIEW IF EXISTS equipment_performance_summary;

CREATE VIEW equipment_performance_summary AS
SELECT
    equipment_id,
    COUNT(*) AS total_readings,
    ROUND(AVG(temperature), 2) AS average_temperature,
    ROUND(MIN(temperature), 2) AS minimum_temperature,
    ROUND(MAX(temperature), 2) AS maximum_temperature,
    ROUND(AVG(pressure), 2) AS average_pressure,
    ROUND(MIN(pressure), 2) AS minimum_pressure,
    ROUND(MAX(pressure), 2) AS maximum_pressure,
    ROUND(AVG(vibration), 2) AS average_vibration,
    ROUND(MAX(vibration), 2) AS maximum_vibration,
    ROUND(AVG(oil_level), 2) AS average_oil_level,
    ROUND(MIN(oil_level), 2) AS minimum_oil_level,
    ROUND(MAX(runtime_hours), 2) AS maximum_runtime_hours
FROM equipment_monitoring
GROUP BY equipment_id;


-- ============================================================
-- 4. Anomaly summary by equipment
-- Counts anomalies for each machine.
-- ============================================================

DROP VIEW IF EXISTS equipment_anomaly_summary;

CREATE VIEW equipment_anomaly_summary AS
SELECT
    equipment_id,
    COUNT(*) AS total_readings,
    SUM(
        CASE
            WHEN anomaly_status <> 'Normal' THEN 1
            ELSE 0
        END
    ) AS total_anomalies,
    SUM(
        CASE
            WHEN anomaly_status = 'High Temperature' THEN 1
            ELSE 0
        END
    ) AS high_temperature_events,
    SUM(
        CASE
            WHEN anomaly_status = 'High Pressure' THEN 1
            ELSE 0
        END
    ) AS high_pressure_events,
    SUM(
        CASE
            WHEN anomaly_status = 'High Vibration' THEN 1
            ELSE 0
        END
    ) AS high_vibration_events,
    SUM(
        CASE
            WHEN anomaly_status = 'Low Oil Level' THEN 1
            ELSE 0
        END
    ) AS low_oil_events,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN anomaly_status <> 'Normal' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS anomaly_percentage
FROM equipment_monitoring
GROUP BY equipment_id;


-- ============================================================
-- 5. Equipment risk dashboard
-- Combines health, performance, and anomaly information.
-- ============================================================

DROP VIEW IF EXISTS equipment_risk_dashboard;

CREATE VIEW equipment_risk_dashboard AS
SELECT
    eh.equipment_id,
    eh.health_score,
    eh.status AS health_status,
    eps.total_readings,
    eps.average_temperature,
    eps.average_pressure,
    eps.average_vibration,
    eps.minimum_oil_level,
    eps.maximum_runtime_hours,
    eas.total_anomalies,
    eas.anomaly_percentage,
    CASE
        WHEN eh.health_score < 60
            OR eas.anomaly_percentage >= 30
            THEN 'Critical'

        WHEN eh.health_score < 75
            OR eas.anomaly_percentage >= 15
            THEN 'Warning'

        ELSE 'Low Risk'
    END AS risk_level
FROM equipment_health AS eh
LEFT JOIN equipment_performance_summary AS eps
    ON eh.equipment_id = eps.equipment_id
LEFT JOIN equipment_anomaly_summary AS eas
    ON eh.equipment_id = eas.equipment_id;


-- ============================================================
-- 6. Latest reading for each equipment
-- Uses a correlated subquery to find the newest timestamp.
-- ============================================================

DROP VIEW IF EXISTS latest_equipment_readings;

CREATE VIEW latest_equipment_readings AS
SELECT
    em.id AS reading_id,
    em.equipment_id,
    em.timestamp,
    em.temperature,
    em.pressure,
    em.vibration,
    em.oil_level,
    em.runtime_hours,
    em.anomaly_status
FROM equipment_monitoring AS em
WHERE em.timestamp = (
    SELECT MAX(em2.timestamp)
    FROM equipment_monitoring AS em2
    WHERE em2.equipment_id = em.equipment_id
);
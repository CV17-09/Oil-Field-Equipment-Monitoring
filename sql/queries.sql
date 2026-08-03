-- ============================================================
-- Data analysis queries
-- ============================================================


-- ============================================================
-- 1. View all sensor readings
-- ============================================================

SELECT *
FROM equipment_monitoring
ORDER BY timestamp;


-- ============================================================
-- 2. View all equipment health scores
-- ============================================================

SELECT *
FROM equipment_health
ORDER BY equipment_id;


-- ============================================================
-- 3. View the complete equipment overview
-- ============================================================

SELECT *
FROM equipment_overview
ORDER BY timestamp DESC;


-- ============================================================
-- 4. Count total sensor readings
-- ============================================================

SELECT
    COUNT(*) AS total_sensor_readings
FROM equipment_monitoring;


-- ============================================================
-- 5. Count the number of monitored equipment units
-- ============================================================

SELECT
    COUNT(DISTINCT equipment_id) AS total_equipment
FROM equipment_monitoring;


-- ============================================================
-- 6. Show all abnormal readings
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    temperature,
    pressure,
    vibration,
    oil_level,
    runtime_hours,
    anomaly_status
FROM equipment_monitoring
WHERE anomaly_status <> 'Normal'
ORDER BY timestamp DESC;


-- ============================================================
-- 7. Count each type of anomaly
-- ============================================================

SELECT
    anomaly_status,
    COUNT(*) AS total_occurrences
FROM equipment_monitoring
GROUP BY anomaly_status
ORDER BY total_occurrences DESC;


-- ============================================================
-- 8. Count anomalies by equipment
-- ============================================================

SELECT
    equipment_id,
    COUNT(*) AS total_anomalies
FROM equipment_monitoring
WHERE anomaly_status <> 'Normal'
GROUP BY equipment_id
ORDER BY total_anomalies DESC;


-- ============================================================
-- 9. Calculate average measurements for each equipment unit
-- ============================================================

SELECT
    equipment_id,
    ROUND(AVG(temperature), 2) AS average_temperature,
    ROUND(AVG(pressure), 2) AS average_pressure,
    ROUND(AVG(vibration), 2) AS average_vibration,
    ROUND(AVG(oil_level), 2) AS average_oil_level,
    ROUND(AVG(runtime_hours), 2) AS average_runtime_hours
FROM equipment_monitoring
GROUP BY equipment_id
ORDER BY equipment_id;


-- ============================================================
-- 10. Find high-temperature readings
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    temperature,
    anomaly_status
FROM equipment_monitoring
WHERE anomaly_status = 'High Temperature'
   OR temperature >= 95
ORDER BY temperature DESC;


-- ============================================================
-- 11. Find high-pressure readings
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    pressure,
    anomaly_status
FROM equipment_monitoring
WHERE anomaly_status = 'High Pressure'
   OR pressure >= 240
ORDER BY pressure DESC;


-- ============================================================
-- 12. Find high-vibration readings
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    vibration,
    anomaly_status
FROM equipment_monitoring
WHERE anomaly_status = 'High Vibration'
   OR vibration >= 8
ORDER BY vibration DESC;


-- ============================================================
-- 13. Find low-oil readings
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    oil_level,
    anomaly_status
FROM equipment_monitoring
WHERE anomaly_status = 'Low Oil Level'
   OR oil_level <= 30
ORDER BY oil_level ASC;


-- ============================================================
-- 14. Find the lowest oil level for each equipment unit
-- ============================================================

SELECT
    equipment_id,
    ROUND(MIN(oil_level), 2) AS lowest_oil_level
FROM equipment_monitoring
GROUP BY equipment_id
ORDER BY lowest_oil_level ASC;


-- ============================================================
-- 15. Find maximum runtime for each equipment unit
-- ============================================================

SELECT
    equipment_id,
    ROUND(MAX(runtime_hours), 2) AS maximum_runtime_hours
FROM equipment_monitoring
GROUP BY equipment_id
ORDER BY maximum_runtime_hours DESC;


-- ============================================================
-- 16. Find the equipment with the lowest health score
-- ============================================================

SELECT
    equipment_id,
    health_score,
    status
FROM equipment_health
ORDER BY health_score ASC;


-- ============================================================
-- 17. Find equipment with health scores below 85
-- ============================================================

SELECT
    equipment_id,
    health_score,
    status
FROM equipment_health
WHERE health_score < 85
ORDER BY health_score ASC;


-- ============================================================
-- 18. Overall dashboard statistics
-- ============================================================

SELECT
    COUNT(*) AS total_readings,
    COUNT(DISTINCT equipment_id) AS total_equipment,
    ROUND(AVG(temperature), 2) AS average_temperature,
    ROUND(AVG(pressure), 2) AS average_pressure,
    ROUND(AVG(vibration), 2) AS average_vibration,
    ROUND(AVG(oil_level), 2) AS average_oil_level,
    ROUND(AVG(runtime_hours), 2) AS average_runtime_hours
FROM equipment_monitoring;


-- ============================================================
-- 19. Normal versus abnormal reading percentage
-- ============================================================

SELECT
    anomaly_status,
    COUNT(*) AS total_readings,
    ROUND(
        100.0 * COUNT(*) /
        (
            SELECT COUNT(*)
            FROM equipment_monitoring
        ),
        2
    ) AS percentage_of_readings
FROM equipment_monitoring
GROUP BY anomaly_status
ORDER BY total_readings DESC;


-- ============================================================
-- 20. Top 10 most critical readings
-- Prioritizes anomalies and extreme measurements.
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    anomaly_status,
    temperature,
    pressure,
    vibration,
    oil_level,
    runtime_hours
FROM equipment_monitoring
WHERE anomaly_status <> 'Normal'
ORDER BY
    CASE anomaly_status
        WHEN 'Low Oil Level' THEN 1
        WHEN 'High Temperature' THEN 2
        WHEN 'High Pressure' THEN 3
        WHEN 'High Vibration' THEN 4
        ELSE 5
    END,
    timestamp DESC
LIMIT 10;


-- ============================================================
-- 21. Equipment anomaly summary view
-- ============================================================

SELECT *
FROM equipment_anomaly_summary
ORDER BY total_anomalies DESC;


-- ============================================================
-- 22. Equipment performance summary view
-- ============================================================

SELECT *
FROM equipment_performance_summary
ORDER BY equipment_id;


-- ============================================================
-- 23. Equipment risk dashboard view
-- ============================================================

SELECT *
FROM equipment_risk_dashboard
ORDER BY
    CASE risk_level
        WHEN 'Critical' THEN 1
        WHEN 'Warning' THEN 2
        WHEN 'Low Risk' THEN 3
        ELSE 4
    END,
    health_score ASC;


-- ============================================================
-- 24. Latest reading for every equipment unit
-- ============================================================

SELECT *
FROM latest_equipment_readings
ORDER BY equipment_id;


-- ============================================================
-- 25. Equipment requiring inspection
-- ============================================================

SELECT
    equipment_id,
    health_score,
    health_status,
    total_anomalies,
    anomaly_percentage,
    risk_level
FROM equipment_risk_dashboard
WHERE risk_level IN ('Critical', 'Warning')
ORDER BY
    anomaly_percentage DESC,
    health_score ASC;


-- ============================================================
-- 26. Rank equipment by health score
-- ============================================================

SELECT
    equipment_id,
    health_score,
    status,
    RANK() OVER (
        ORDER BY health_score DESC
    ) AS health_rank
FROM equipment_health;


-- ============================================================
-- 27. Rank equipment by number of anomalies
-- ============================================================

SELECT
    equipment_id,
    total_anomalies,
    anomaly_percentage,
    RANK() OVER (
        ORDER BY total_anomalies DESC
    ) AS anomaly_rank
FROM equipment_anomaly_summary;


-- ============================================================
-- 28. Identify readings with multiple dangerous conditions
-- ============================================================

SELECT
    equipment_id,
    timestamp,
    temperature,
    pressure,
    vibration,
    oil_level,
    anomaly_status,
    (
        CASE WHEN temperature >= 95 THEN 1 ELSE 0 END
        +
        CASE WHEN pressure >= 240 THEN 1 ELSE 0 END
        +
        CASE WHEN vibration >= 8 THEN 1 ELSE 0 END
        +
        CASE WHEN oil_level <= 30 THEN 1 ELSE 0 END
    ) AS dangerous_condition_count
FROM equipment_monitoring
WHERE
    (
        CASE WHEN temperature >= 95 THEN 1 ELSE 0 END
        +
        CASE WHEN pressure >= 240 THEN 1 ELSE 0 END
        +
        CASE WHEN vibration >= 8 THEN 1 ELSE 0 END
        +
        CASE WHEN oil_level <= 30 THEN 1 ELSE 0 END
    ) >= 2
ORDER BY dangerous_condition_count DESC;
## 🚀 Overview

This project is a data monitoring system built using **Python, SQL, and Power BI** to analyze equipment sensor data. It processes raw sensor readings, detects anomalies, and visualizes trends over time to help identify potential equipment issues.

---

## 🧠 Objective

The goal of this project is to simulate a real-world monitoring pipeline used in industries like **oil & gas, manufacturing, and IoT**, where early detection of abnormal behavior is critical for preventing failures and reducing downtime.

---

## 🛠️ Tech Stack

* **Python (Pandas)** – Data preprocessing and anomaly detection
* **SQL (Azure SQL Database)** – Data storage and querying
* **Power BI** – Interactive dashboard and visualization
* **Power Query** – Data transformation within Power BI

---

## 🔄 Data Pipeline

1. **Data Generation / Collection**

   * Sensor data (temperature, pressure, vibration) is generated or collected.

2. **Data Processing (Python)**

   * Cleaned and transformed using Pandas
   * Applied rule-based anomaly detection logic

3. **Data Storage (SQL)**

   * Processed data is stored in a SQL database

4. **Data Visualization (Power BI)**

   * Connected Power BI to SQL
   * Built interactive dashboards to monitor trends and anomalies

---

## 📂 Dataset

The dataset includes:

* `timestamp` – Date and time of the reading
* `equipment_id` – Machine identifier
* `temperature` – Equipment temperature
* `pressure` – Pressure levels
* `vibration` – Vibration intensity
* `anomaly_status` – Indicates normal vs abnormal behavior

---

## 🤖 Anomaly Detection Logic

A simple rule-based approach was implemented in Python:

* High temperature threshold
* High pressure threshold
* High vibration threshold

If any threshold is exceeded, the reading is flagged as an anomaly.

---

## 📈 Features

* 📊 Time-series visualization of multiple sensor metrics
* 🔴 Anomaly detection highlighted directly on charts
* 🔍 Interactive filtering and exploration
* 📉 Multi-signal comparison (temperature, pressure, vibration)
* ⚡ Clean dashboard design for quick insights

---

## 🔥 Key Insights

* Rapid identification of abnormal equipment behavior
* Detection of spikes in pressure or temperature
* Ability to monitor trends over time for predictive maintenance

---

## 📸 Dashboard Preview

*(Add your screenshot here)*

---

## 🚧 Future Improvements

* Implement machine learning-based anomaly detection
* Enable real-time data streaming
* Add automated alerting system
* Deploy dashboard for live monitoring

---

⭐ If you found this project interesting, consider giving it a star!





CREATE DATABASE utility_analytics;

USE utility_analytics;

CREATE TABLE utility_usage (
    Customer_ID VARCHAR(10),
    Month DATE,
    Service_Area VARCHAR(20),
    Customer_Type VARCHAR(30),
    Meter_Type VARCHAR(30),
    Avg_Temperature_F DECIMAL(5,1),
    kWh_Usage DECIMAL(10,1),
    Bill_Amount DECIMAL(10,2),
    Payment_Days_Late INT,
    Outage_Count INT,
    Outage_Minutes INT,
    Service_Calls INT,
    Injected_Usage_Anomaly VARCHAR(3)
);

ALTER TABLE utility_usage
MODIFY Month VARCHAR(10);

SELECT COUNT(*) AS Total_Rows
FROM utility_usage;

SELECT
    Service_Area,
    ROUND(AVG(kWh_Usage), 1) AS Avg_kWh,
    ROUND(AVG(Bill_Amount), 2) AS Avg_Bill
FROM utility_usage
GROUP BY Service_Area
ORDER BY Avg_kWh DESC;

SELECT
    Service_Area,
    SUM(Outage_Count) AS Total_Outages,
    SUM(Outage_Minutes) AS Total_Outage_Minutes
FROM utility_usage
GROUP BY Service_Area
ORDER BY Total_Outage_Minutes DESC;

SELECT
    Customer_ID,
    Service_Area,
    SUM(Outage_Minutes) AS Total_Outage_Minutes
FROM utility_usage
GROUP BY Customer_ID, Service_Area
ORDER BY Total_Outage_Minutes DESC
LIMIT 20;

SELECT
    CASE
        WHEN Outage_Count > 0 THEN 'Outage Month'
        ELSE 'No Outage'
    END AS Outage_Status,
    ROUND(AVG(Service_Calls), 2) AS Avg_Service_Calls
FROM utility_usage
GROUP BY Outage_Status;

SELECT
    Customer_ID,
    COUNT(*) AS Late_Months,
    ROUND(AVG(Payment_Days_Late), 1) AS Avg_Days_Late
FROM utility_usage
WHERE Payment_Days_Late > 0
GROUP BY Customer_ID
HAVING COUNT(*) >= 5
ORDER BY Late_Months DESC, Avg_Days_Late DESC;
# Retail Shrink Analysis – Portfolio Project

## Project Overview
This project analyzes retail shrink (loss of inventory due to theft, damage, or operational errors) using a sample dataset from a Canadian grocery chain. The goal is to provide actionable insights for store operations, inventory management, and loss prevention, demonstrating practical skills in *data cleaning, SQL, and visualization*.

---

## Problem Statement
Retail shrink is a critical metric that affects profitability. High shrink rates can indicate theft, operational inefficiencies, or poor inventory control. This project aims to:

- Analyze shrink across stores, departments, and SKUs  
- Identify trends over time (monthly)  
- Provide recommendations for reducing shrink  

---

## Dataset
The dataset includes data from *3 stores over 3 months* with the following columns:

| Column       | Description                                |
|--------------|--------------------------------------------|
| SKU          | Unique identifier for products             |
| UPC          | Barcode identifier                          |
| Store        | Store number (1, 2, 3)                     |
| Department   | Department name (Bakery, Produce, Seafood) |
| Subcategory  | Product subcategory                         |
| Sales        | Units sold                                  |
| Shrink       | Units lost due to shrink                    |
| Month        | Month number (9 = September, 10 = October, 11 = November) |

*Source:* Synthetic dataset inspired by Canadian grocery retail operations.

---

## Data Cleaning Steps
- Removed anomalies and duplicates  
- Flagged products with *zero sales*  
- Identified products where *shrink > sales* (none in this dataset)  
- Created additional sheets to highlight *anomalous products*  
- Calculated *shrink rate* as:

```text
Shrink Rate = (Shrink / Sales) * 100
```
---

## SQL Analysis
SQL queries were used to extract insights at multiple levels. Each query was executed on the cleaned dataset to answer specific business questions.

### 1: Overall Shrink Metrics
This query calculates the total shrink, total sales, and overall shrink rate across all stores.

```sql
SELECT 
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  SAFE_DIVIDE(SUM(shrink_units),SUM(sold_units))*100 as overall_shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`;
```

### 2: Shrink Rate by SKU
Purpose: Determine shrink rate per SKU to identify products with the highest losses across all stores and months.  

```sql
SELECT 
  sku,
  upc,
  department,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY sku, upc, department, subcategory
ORDER BY shrink_rate DESC;
```

### 3: Top 10 Products by Total Shrink
Purpose: Identify the 10 products with the highest total shrink across all stores to prioritize loss prevention efforts.  

```sql
SELECT 
  sku,
  upc,
  department,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY sku, upc, department, subcategory
ORDER BY total_shrink DESC
LIMIT 10;
```

### 4: Department-Level Shrink
Purpose: Aggregate shrink and shrink rate by department to identify which departments are experiencing the highest inventory losses.  

```sql
SELECT
  department,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY department
ORDER BY shrink_rate DESC;
```

### 5: Subcategory-Level Shrink
Purpose: Analyze shrink by subcategory within departments to identify finer patterns of inventory loss.  

```sql
SELECT
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY subcategory
ORDER BY shrink_rate DESC;
```

### 6: Zero Sales but Shrink
Purpose: Identify products that had no sales but still experienced shrink, indicating potential inventory issues or theft.  

```sql
SELECT
  sku,
  upc,
  department,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY sku, upc, department, subcategory
HAVING total_sales = 0 AND total_shrink > 0
ORDER BY total_shrink DESC;
```

### 7: Shrink Greater Than Sales
Purpose: Detect any products where shrink exceeded sales, which may indicate data errors or extreme inventory losses.  

```sql
SELECT
  sku,
  upc,
  department,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY sku, upc, department, subcategory
HAVING total_sales < total_shrink 
ORDER BY total_shrink DESC;
```

### 8: High Shrink Rate Products (>10%)
Purpose: Highlight products with a shrink rate greater than 10% to focus on high-loss items for loss prevention.  

```sql
SELECT
  sku,
  upc,
  department,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY sku, upc, department, subcategory
HAVING shrink_rate > 10 
ORDER BY shrink_rate DESC;
```

### 9: Store + Department Shrink
Purpose: Examine shrink by department within each store to pinpoint specific areas contributing to inventory losses.   

```sql
SELECT
  store_id,
  department,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY store_id, department 
ORDER BY store_id, shrink_rate DESC;
```

### 10: Store + Subcategory Shrink
Purpose: Analyze shrink by subcategory within each store to identify specific high-loss product categories. 

```sql
SELECT
  store_id,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY store_id,subcategory 
ORDER BY store_id, shrink_rate DESC;
```

### 11:  Monthly Trend Analysis
Purpose: Observe shrink trends over time to detect seasonality or recurring inventory issues.

```sql
SELECT
  EXTRACT(MONTH FROM date) as month,
  SUM(sold_units) as total_sale,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY month
ORDER BY month;
```

### 12:   Store-Level Shrink
Purpose: Aggregate shrink and shrink rate per store to compare overall store performance and identify high-loss locations.  

```sql
SELECT
  store_id,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units),SUM(sold_units))*100, 1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY store_id
ORDER BY shrink_rate DESC;
```
## Notes
- All queries were run on *BigQuery* after uploading the cleaned CSV.  
- Aggregations were done by *store, department, SKU, and month* to provide multi-level insights.  
- The results of these queries were *exported to CSV files* for further visualization in Power BI.

# 📊 Shrink Analysis – Insights & Findings

## Executive Summary
Across three stores over three months, total shrink reached *14,289 units* against *147,867 units sold, resulting in an overall shrink rate of **9.7%*.  
Shrink is consistently high across all locations, with *Bakery* and *Produce* driving the majority of the loss. This represents both operational inefficiencies and potential preventable shrink.

---

## 1. Overall Shrink Performance
- *Total Shrink:* 14,289 units  
- *Total Sales:* 147,867 units  
- *Overall Shrink Rate:* 9.7%  

> This level of shrink is significantly above what is typically acceptable in the grocery retail sector (industry benchmarks are 2–4%), indicating clear opportunities for targeted interventions.

---

## 2. Store-Level Shrink Analysis
Shrink rates were relatively close across all three stores:

| Store   | Shrink Rate |
|---------|------------|
| Store 1 | 9.3%       |
| Store 2 | 10.0%      |
| Store 3 | 9.6%       |

- *Store 2* shows the highest shrink rate (10%), warranting further operational review.  
- The narrow range suggests systemic issues rather than store-specific anomalies.

---

## 3. Department-Level Findings
Shrink is heavily concentrated in a few key departments:

### Top Departments by Shrink (Units & %)
1. *Bakery* – Highest in both shrink units and shrink rate  
   - Shrink Units: ~5,000  
   - Shrink Rate: 39.8%  
   > Bakery alone contributes a disproportionate amount of total shrink, likely due to short shelf life, production planning issues, or waste.  
2. *Produce* – Second highest contributor  
   > Strong shrink presence driven by perishability and handling challenges.  
3. *Seafood*  
   > Elevated shrink driven by spoilage, temperature control requirements, and limited shelf life.

*Additional Notes:*  
- No department recorded shrink > sales.  
  > Indicates no extreme anomalies, though certain departments still show operational inefficiencies.

---

## 4. SKU-Level Insights
Shrink is highly concentrated in specific products:

### Top 10 SKUs by Shrink
- Majority from *Bakery*.  
- One SKU from *Produce* (Citrus) appears in the top 10.  
- Highest-shrink SKU:  
  - *Bread (Bakery)*  
  - Shrink: 196 units  
  - Sales: 589 units  
  > Suggests either overproduction, improper forecasting, or handling issues.

*Additional SKU Findings:*  
- No SKU had shrink > sales.  
- No SKU had zero sales with shrink.  
> All products with shrink had movement, indicating normal operational patterns rather than inventory errors.

---

## 5. Monthly Shrink Trend
Shrink fluctuated slightly month-to-month but remained consistently high:

| Month      | Shrink Rate |
|-----------|------------|
| September | 9.7%       |
| October   | 9.4%       |
| November  | 9.9%       |

> November showed the highest shrink, indicating possible seasonal demand variability, holiday production increases, or staffing challenges.

---

## 📌 Overall Interpretation
- Shrink is consistently elevated across all stores and months.  
- *Bakery* and *Produce* are the highest-risk departments, responsible for the majority of losses.  
- SKU-level concentration suggests targeted action can significantly reduce overall shrink.  
- Store-level differences are minor, highlighting chain-wide processes as the root cause.

## Business Questions Addressed & Answers

1. *Which store has the highest shrink?*  
   - *Answer:* Store 2 has the highest shrink rate at *10%*, followed closely by Store 3 (9.6%) and Store 1 (9.3%).  
   - *Insight:* Minor differences suggest chain-wide operational issues rather than isolated store problems.

2. *Which department is losing the most?*  
   - *Answer:*  
     1. *Bakery* – highest shrink units (~5,000) and shrink rate (39.8%)  
     2. *Produce* – second highest contributor  
     3. *Seafood* – third highest  
   - *Insight:* Bakery and Produce require targeted attention due to perishability, handling, and production planning issues.

3. *Which SKUs contribute to the highest shrink?*  
   - *Answer:* Top 10 SKUs by shrink are mostly from Bakery, with one Produce SKU (Citrus) in the top 10.  
     - Highest-shrink SKU: *Bread (Bakery)* – 196 units lost, 589 units sold.  
   - *Insight:* A small number of SKUs drive a disproportionate amount of shrink, making targeted interventions effective.

4. *What type of shrink is most common?*  
   - *Answer (based on retail operations context):* Likely *spoilage and process errors* dominate, especially in Bakery and Produce, with potential for minor theft.  
   - *Insight:* Operational inefficiencies and product perishability are key contributors.

5. *Are there weekly or monthly patterns?*  
   - *Answer:* Monthly trend shows:  
     - September: 9.7%  
     - October: 9.4%  
     - November: 9.9%  
   - *Insight:* Slight increase in November may indicate seasonal demand variability or staffing/operational changes; more granular weekly data could refine this analysis.

6. *What are the root causes and recommendations?*  
   - *Answer:*  
     - Root Causes: Perishable product spoilage, handling errors, production planning inefficiencies.  
     - Recommendations:  
       - Improve inventory forecasting and production scheduling.  
       - Strengthen handling protocols for perishable items.  
       - Monitor top-loss SKUs closely and implement targeted loss prevention measures.

## Visualizations
The following visualizations were created in *Power BI* using the exported CSV results from BigQuery:

- *Overall Shrink KPI* – Quick snapshot of total shrink and shrink rate.  
- *Store-Level Shrink* – Bar chart showing shrink by store.  
- *Department-Level Shrink* – Bar or pie chart highlighting departments with the highest shrink.  
- *Top 10 SKUs* – Bar chart for SKUs contributing most to shrink.  
- *Subcategory-Level Shrink* – Analysis by product subcategory.  
- *Monthly Trend* – Line chart showing shrink trends over the 3 months.

<img width="1291" height="722" alt="image" src="https://github.com/user-attachments/assets/19141da7-d742-4fa3-aea0-8ccc5c0f0c38" />

<img width="1281" height="693" alt="image" src="https://github.com/user-attachments/assets/9238f225-0b2a-4581-8ae5-996d0cdd7f83" />

---

## Recommendations
Based on the analysis, the following actions are suggested:

- Focus *loss prevention efforts* on *Bakery* and *Produce* departments.  
- Monitor *high-shrink SKUs* individually for operational improvements.  
- Track *monthly shrink trends* to implement timely interventions and reduce losses.

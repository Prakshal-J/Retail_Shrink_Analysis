-- Testing the data

SELECT 
  * 
FROM `culinary-corner-433718.shrink_analysis.shrink_data`;

-- Total sales and shrink for an overview

SELECT 
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  SAFE_DIVIDE(SUM(shrink_units),SUM(sold_units))*100 as overall_shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`;

-- Store level shrink

SELECT
  store_id,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units),SUM(sold_units))*100, 1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY store_id
ORDER BY shrink_rate DESC;

-- Shrink rate by SKU

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

-- Top 10 products by total shrink units

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

-- Department level shrink

SELECT
  department,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY department
ORDER BY shrink_rate DESC;

-- Subcategory level shrink 

SELECT
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY subcategory
ORDER BY shrink_rate DESC;

-- Zero sales but shrink 

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

-- Shrink greater than sales

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

-- High shrink rate products (>10%)

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

-- store + department shrink

SELECT
  store_id,
  department,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY store_id, department 
ORDER BY store_id, shrink_rate DESC;

-- store + subcategory shrink

SELECT
  store_id,
  subcategory,
  SUM(sold_units) as total_sales,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY store_id,subcategory 
ORDER BY store_id, shrink_rate DESC;

-- Monthly trend analysis

SELECT
  EXTRACT(MONTH FROM date) as month,
  SUM(sold_units) as total_sale,
  SUM(shrink_units) as total_shrink,
  ROUND(SAFE_DIVIDE(SUM(shrink_units), SUM(sold_units))*100,1) as shrink_rate
FROM `culinary-corner-433718.shrink_analysis.shrink_data`
GROUP BY month
ORDER BY month;

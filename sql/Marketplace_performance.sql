-- Dashboard 1: Marketplace & Revenue Overview

CREATE VIEW vw_kpi_total_revenue AS
SELECT 
    ROUND(SUM(ttm_revenue), 2) AS total_revenue_ttm
FROM listings
WHERE ttm_revenue IS NOT NULL;


CREATE VIEW vw_kpi_revenue_last_90_days AS
SELECT 
    ROUND(SUM(l90d_revenue), 2) AS revenue_last_90_days
FROM listings
WHERE l90d_revenue IS NOT NULL;


CREATE VIEW vw_kpi_RevPAR AS 
SELECT
    AVG(ttm_revpar) AS avg_revpar_ttm
FROM listings
WHERE ttm_revpar IS NOT NULL;


CREATE VIEW vw_kpi_adjusted_occupancy AS
SELECT 
    ROUND(AVG(ttm_adjusted_occupancy) * 100, 2) AS adjusted_occupancy_percent
FROM listings
WHERE ttm_adjusted_occupancy IS NOT NULL;

CREATE VIEW vw_kpi_revenue_momentumm AS
SELECT
    ROUND(
        (SUM(l90d_revenue) * 4.0 - SUM(ttm_revenue)) / NULLIF(SUM(ttm_revenue),0) * 100, 2
    ) AS revenue_momentum_percent
FROM listings
WHERE  ttm_revenue IS NOT NULL
  AND l90d_revenue IS NOT NULL;


-- Charts

CREATE VIEW vw_monthly_trend AS
SELECT
    DATE(STRFTIME('%Y-%m-01', date)) AS month_date,
    ROUND(SUM(revenue),2) AS total_revenue,
    ROUND(AVG(occupancy)*100,2) AS avg_occupancy_percent
FROM past_calendar
WHERE date IS NOT NULL
GROUP BY month_date
ORDER BY month_date;


DROP VIEW IF EXISTS vw_revpar_vs_occupancy;

CREATE VIEW revpar_vs_occupancy AS
SELECT
    listing_id,
    ROUND(ttm_revpar,2) AS ttm_revpar,
    ROUND(ttm_adjusted_occupancy*100,2) AS adjusted_occupancy_percent,
    room_type,
    listing_type
FROM listings
WHERE ttm_revpar IS NOT NULL
  AND ttm_adjusted_occupancy IS NOT NULL;

  
CREATE VIEW vw_property_type_performance AS
SELECT
    listing_type,
    COUNT(DISTINCT listing_id) AS listings_count,
    ROUND(AVG(ttm_occupancy) * 100, 2) AS avg_occupancy_percent,
    ROUND(AVG(ttm_revpar), 2) AS avg_revpar,
    ROUND(SUM(ttm_revenue), 2) AS total_revenue
FROM listings
WHERE ttm_revenue IS NOT NULL
GROUP BY listing_type;



CREATE VIEW vw_supply_efficiency_heatmap AS
SELECT
    listing_type,
    room_type,
    ROUND(SUM(ttm_revenue)/NULLIF(SUM(ttm_available_days),0),2) AS rev_per_available_day,
    ROUND(AVG(ttm_adjusted_occupancy)*100,2) AS avg_adjusted_occupancy
FROM listings
WHERE ttm_revenue IS NOT NULL AND ttm_available_days > 0
GROUP BY listing_type, room_type
ORDER BY rev_per_available_day DESC;


CREATE VIEW vw_price_vs_occupancy_percentile AS
SELECT
    CASE
        WHEN price_percentile <= 0.33 THEN 'Low Price'
        WHEN price_percentile <= 0.66 THEN 'Mid Price'
        ELSE 'High Price'
    END AS price_segment,

    ROUND(AVG(ttm_adjusted_occupancy) * 100, 2) AS avg_occupancy_percent,
    COUNT(*) AS listings_count

FROM (
    SELECT
        listing_id,
        ttm_avg_rate,
        ttm_adjusted_occupancy,
        PERCENT_RANK() OVER (ORDER BY ttm_avg_rate) AS price_percentile
    FROM listings
    WHERE ttm_avg_rate IS NOT NULL
      AND ttm_adjusted_occupancy IS NOT NULL
) p

GROUP BY price_segment
ORDER BY price_segment;




CREATE VIEW vw_segmentt_revenue_momentum AS
SELECT
    listing_type,
    room_type,
    ROUND((SUM(l90d_revenue) * 4.0 - SUM(ttm_revenue)) / NULLIF(SUM(ttm_revenue),0) * 100,2) AS revenue_momentum_percent,
    CASE
        WHEN (SUM(l90d_revenue) * 4.0 - SUM(ttm_revenue)) / NULLIF(SUM(ttm_revenue),0) >= 10 THEN 'High Growth'
        WHEN (SUM(l90d_revenue) * 4.0 - SUM(ttm_revenue)) / NULLIF(SUM(ttm_revenue),0) BETWEEN 0 AND 10 THEN 'Moderate Growth'
        ELSE 'Declining'
    END AS growth_segment
FROM listings
WHERE ttm_revenue IS NOT NULL AND l90d_revenue IS NOT NULL
GROUP BY listing_type, room_type
ORDER BY revenue_momentum_percent DESC;



CREATE VIEW vw_room_type_scale_vs_efficiency AS
SELECT
    room_type,
    ROUND(AVG(ttm_adjusted_occupancy) * 100, 2) AS avg_adjusted_occupancy,
    ROUND(AVG(ttm_revpar), 2) AS avg_revpar,
    ROUND(SUM(ttm_revenue), 2) AS total_revenue
FROM listings
WHERE ttm_revenue IS NOT NULL
  AND ttm_revpar IS NOT NULL
  AND ttm_adjusted_occupancy IS NOT NULL
GROUP BY room_type;

CREATE VIEW vw_supply_vs_demand AS
SELECT
    ROUND(SUM(ttm_available_days), 0) AS total_available_days,
    ROUND(SUM(ttm_reserved_days), 0) AS total_reserved_days,
    ROUND(
        SUM(ttm_reserved_days) * 1.0 
        / NULLIF(SUM(ttm_available_days), 0) * 100,
        2
    ) AS demand_absorption_percent
FROM listings
WHERE ttm_available_days IS NOT NULL
  AND ttm_reserved_days IS NOT NULL;



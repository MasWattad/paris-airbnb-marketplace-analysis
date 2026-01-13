-- Dashboard 3: Price, Fees & Booking Dynamics

CREATE VIEW vw_kpi_avg_daily_rate AS
SELECT ROUND(AVG(ttm_avg_rate),2) AS avg_daily_rate
FROM listings
WHERE ttm_avg_rate IS NOT NULL;


CREATE VIEW vw_kpi_avg_revpar AS
SELECT ROUND(AVG(ttm_revpar),2) AS avg_revpar
FROM listings
WHERE ttm_revpar IS NOT NULL;


CREATE VIEW vw_kpi_avg_occupancy AS
SELECT ROUND(AVG(ttm_adjusted_occupancy)*100,2) AS avg_occupancy_percent
FROM listings
WHERE ttm_adjusted_occupancy IS NOT NULL;


CREATE VIEW vw_kpi_avg_revenue_per_listing AS
SELECT ROUND(AVG(ttm_revenue),2) AS avg_revenue_per_listing
FROM listings
WHERE ttm_revenue IS NOT NULL;


CREATE VIEW vw_price_vs_occupancy AS
SELECT
  listing_id,
  ttm_avg_rate AS daily_rate,
  ROUND(ttm_adjusted_occupancy * 100, 2) AS occupancy_percent,
  ttm_revpar AS revpar,
  ttm_revenue AS revenue
FROM listings
WHERE ttm_avg_rate IS NOT NULL
  AND ttm_adjusted_occupancy IS NOT NULL;




CREATE VIEW vw_adr_distribution AS
SELECT CASE
           WHEN ttm_avg_rate < 50 THEN 'Under 50'
           WHEN ttm_avg_rate BETWEEN 50 AND 100 THEN '50–100'
           WHEN ttm_avg_rate BETWEEN 100 AND 150 THEN '100–150'
           WHEN ttm_avg_rate BETWEEN 150 AND 250 THEN '150–250'
           ELSE '250+'
       END AS adr_range,
       COUNT(*) AS listing_count
FROM listings
GROUP BY adr_range;


CREATE VIEW vw_cleaning_fee_vs_revpar AS
SELECT
  CASE
    WHEN COALESCE(cleaning_fee,0) = 0 THEN 'No cleaning fee'
    WHEN cleaning_fee < 50 THEN 'Low (<50)'
    WHEN cleaning_fee <= 100 THEN 'Medium (50–100)'
    ELSE 'High (100+)'
  END AS cleaning_fee_level,
  ROUND(AVG(ttm_revpar), 2) AS avg_revpar,
  COUNT(*) AS listings_count
FROM listings
WHERE ttm_revpar IS NOT NULL
GROUP BY cleaning_fee_level
ORDER BY listings_count DESC;


CREATE VIEW vw_extra_guest_fee_vs_occupancy AS
SELECT CASE
           WHEN extra_guest_fee = 0 THEN 'No extra guest fee'
           WHEN extra_guest_fee < 25 THEN 'Low extra guest fee'
           ELSE 'High extra guest fee'
       END AS extra_guest_fee_level,
       ROUND(AVG(ttm_adjusted_occupancy)*100,2) AS avg_occupancy_percent
FROM listings
WHERE ttm_adjusted_occupancy IS NOT NULL
GROUP BY extra_guest_fee_level;



CREATE VIEW vw_lead_time_segments AS
SELECT
  CASE
    WHEN booking_lead_time_avg <= 3 THEN '0–3 days'
    WHEN booking_lead_time_avg <= 7 THEN '4–7 days'
    WHEN booking_lead_time_avg <= 14 THEN '8–14 days'
    WHEN booking_lead_time_avg <= 30 THEN '15–30 days'
    ELSE '31+ days'
  END AS lead_time_segment,
  ROUND(AVG(occupancy) * 100, 2) AS avg_occupancy_percent,
  ROUND(AVG(booked_rate_avg), 2) AS avg_booked_rate,
  ROUND(AVG(revenue), 2) AS avg_daily_revenue,
  COUNT(*) AS day_rows
FROM past_calendar
WHERE booking_lead_time_avg IS NOT NULL
GROUP BY lead_time_segment
ORDER BY day_rows DESC;


CREATE VIEW vw_los_segments AS
SELECT
  CASE
    WHEN length_of_stay_avg <= 2 THEN '1–2 nights'
    WHEN length_of_stay_avg <= 4 THEN '3–4 nights'
    WHEN length_of_stay_avg <= 7 THEN '5–7 nights'
    ELSE '8+ nights'
  END AS los_segment,
  ROUND(AVG(occupancy) * 100, 2) AS avg_occupancy_percent,
  ROUND(AVG(booked_rate_avg), 2) AS avg_booked_rate,
  ROUND(AVG(revenue), 2) AS avg_daily_revenue,
  COUNT(*) AS day_rows
FROM past_calendar
WHERE length_of_stay_avg IS NOT NULL
GROUP BY los_segment
ORDER BY day_rows DESC;


CREATE VIEW vw_min_nights_policy_vs_occupancy AS
SELECT
  CASE
    WHEN min_nights = 1 THEN '1 night'
    WHEN min_nights BETWEEN 2 AND 3 THEN '2–3 nights'
    WHEN min_nights BETWEEN 4 AND 6 THEN '4–6 nights'
    WHEN min_nights BETWEEN 7 AND 13 THEN '1–2 weeks'
    ELSE '14+ nights'
  END AS min_nights_policy,
  ROUND(AVG(ttm_adjusted_occupancy) * 100, 2) AS avg_occupancy_percent,
  ROUND(AVG(ttm_revpar), 2) AS avg_revpar,
  COUNT(*) AS listings_count
FROM listings
WHERE min_nights IS NOT NULL
  AND ttm_adjusted_occupancy IS NOT NULL
  AND ttm_revpar IS NOT NULL
GROUP BY min_nights_policy
ORDER BY listings_count DESC;


CREATE VIEW vw_price_tier_percentiles AS
WITH ranked AS (
  SELECT
    listing_id,
    ttm_avg_rate,
    ttm_revenue,
    NTILE(3) OVER (ORDER BY ttm_avg_rate) AS price_tercile
  FROM listings
  WHERE ttm_avg_rate IS NOT NULL
    AND ttm_revenue IS NOT NULL
)
SELECT
  CASE price_tercile
    WHEN 1 THEN 'Low price (bottom 33%)'
    WHEN 2 THEN 'Mid price (middle 33%)'
    ELSE 'High price (top 33%)'
  END AS price_tier,
  ROUND(AVG(ttm_avg_rate), 2) AS avg_adr,
  ROUND(SUM(ttm_revenue), 2) AS total_revenue,
  COUNT(*) AS listings_count
FROM ranked
GROUP BY price_tercile
ORDER BY price_tercile;


CREATE VIEW vw_cleaning_fee_vs_revpar AS
SELECT
  CASE
    WHEN COALESCE(cleaning_fee,0) = 0 THEN 'No cleaning fee'
    WHEN cleaning_fee < 50 THEN 'Low (<50)'
    WHEN cleaning_fee <= 100 THEN 'Medium (50–100)'
    ELSE 'High (100+)'
  END AS cleaning_fee_level,
  ROUND(AVG(ttm_revpar), 2) AS avg_revpar,
  COUNT(*) AS listings_count
FROM listings
WHERE ttm_revpar IS NOT NULL
GROUP BY cleaning_fee_level
ORDER BY listings_count DESC;

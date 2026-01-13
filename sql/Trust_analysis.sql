-- Dashboard 2: Trust & Performance

CREATE VIEW vw_kpi_marketplace_trust AS
SELECT
  ROUND(
    SUM(rating_overall * num_reviews) /
    NULLIF(SUM(num_reviews), 0),
  2
) AS marketplace_trust_index
FROM listings
WHERE rating_overall IS NOT NULL
  AND num_reviews > 0;

CREATE VIEW vw_kpi_demand_persistence AS
WITH listing_month_counts AS (
  SELECT
    listing_id,
    COUNT(DISTINCT STRFTIME('%Y-%m', date)) AS active_months
  FROM reviews_data
  WHERE COALESCE(num_reviews,0) > 0
  GROUP BY listing_id
)
SELECT
  ROUND(
    100.0 * SUM(CASE WHEN active_months > 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),
  2) AS demand_persistence_percent
FROM listing_month_counts;


CREATE VIEW vw_kpi_occupancy_by_trust AS
SELECT CASE
           WHEN rating_overall < 4.5 THEN 'Low Trust'
           WHEN rating_overall BETWEEN 4.5 AND 4.8 THEN 'Medium Trust'
           ELSE 'High Trust'
       END AS trust_tier,
       ROUND(AVG(ttm_occupancy)*100,2) AS avg_occupancy_percent
FROM listings
WHERE ttm_occupancy IS NOT NULL
GROUP BY trust_tier;

-- KPI 4: Revenue per Available Day
CREATE VIEW vw_kpi_rev_per_available_day AS
SELECT CASE
           WHEN rating_overall < 4.5 THEN 'Low Trust'
           WHEN rating_overall BETWEEN 4.5 AND 4.8 THEN 'Medium Trust'
           ELSE 'High Trust'
       END AS trust_tier,
       ROUND(SUM(ttm_revenue)/SUM(ttm_available_days),2) AS rev_per_available_day_ttm,
       ROUND(SUM(l90d_revenue)/SUM(l90d_available_days),2) AS rev_per_available_day_90d
FROM listings
WHERE rating_overall IS NOT NULL
  AND ttm_revenue IS NOT NULL
  AND l90d_revenue IS NOT NULL
  AND ttm_available_days > 0
  AND l90d_available_days > 0
GROUP BY trust_tier;


CREATE VIEW vw_trust_distribution AS
SELECT ROUND(rating_overall,1) AS rating_bucket,
       COUNT(*) AS listings_count
FROM listings
GROUP BY rating_bucket
ORDER BY rating_bucket;



CREATE VIEW vw_trust_rating_vs_revpar AS
SELECT
  listing_id,
  rating_overall,
  num_reviews,
  ttm_revpar,
  ttm_adjusted_occupancy,
  ttm_revenue
FROM listings
WHERE rating_overall IS NOT NULL
  AND num_reviews IS NOT NULL
  AND ttm_revpar IS NOT NULL
  AND ttm_adjusted_occupancy IS NOT NULL
  AND ttm_revenue IS NOT NULL;



CREATE VIEW vw_revpar_by_trust_tier AS
SELECT
  CASE
    WHEN rating_overall < 4.5 THEN 'Low Trust'
    WHEN rating_overall <= 4.8 THEN 'Medium Trust'
    ELSE 'High Trust'
  END AS trust_tier,
  ROUND(AVG(ttm_revpar),2) AS avg_revpar_ttm,
  ROUND(AVG(l90d_revpar),2) AS avg_revpar_90d
FROM listings
WHERE rating_overall IS NOT NULL
  AND ttm_revpar IS NOT NULL
  AND l90d_revpar IS NOT NULL
GROUP BY trust_tier
ORDER BY
  CASE trust_tier
    WHEN 'Low Trust' THEN 1
    WHEN 'Medium Trust' THEN 2
    ELSE 3
  END;



CREATE VIEW vw_review_trends_by_trust AS
SELECT STRFTIME('%Y-%m', r.date) AS month,
       CASE
           WHEN l.rating_overall < 4.5 THEN 'Low Trust'
           WHEN l.rating_overall BETWEEN 4.5 AND 4.8 THEN 'Medium Trust'
           ELSE 'High Trust'
       END AS trust_tier,
       SUM(r.num_reviews) AS total_reviews,
       ROUND(AVG(l.rating_overall),2) AS avg_rating
FROM reviews_data r
JOIN listings l ON r.listing_id = l.listing_id
GROUP BY month, trust_tier
ORDER BY month, trust_tier;


CREATE VIEW vw_occupancy_by_trust_tier AS
SELECT CASE
           WHEN rating_overall < 4.5 THEN 'Low Trust'
           WHEN rating_overall BETWEEN 4.5 AND 4.8 THEN 'Medium Trust'
           ELSE 'High Trust'
       END AS trust_tier,
       ROUND(AVG(ttm_occupancy)*100,2) AS avg_occupancy_percent
FROM listings
WHERE ttm_occupancy IS NOT NULL
GROUP BY trust_tier;



CREATE VIEW vw_trust_trends_calendar AS
SELECT STRFTIME('%Y-%m', c.date) AS month,
       CASE
           WHEN l.rating_overall < 4.5 THEN 'Low Trust'
           WHEN l.rating_overall BETWEEN 4.5 AND 4.8 THEN 'Medium Trust'
           ELSE 'High Trust'
       END AS trust_tier,
       ROUND(AVG(c.occupancy)*100,2) AS avg_occupancy_percent,
       ROUND(AVG(c.revenue),2) AS avg_revenue,
       ROUND(AVG(c.rate_avg),2) AS avg_daily_rate
FROM past_calendar c
JOIN listings l ON c.listing_id = l.listing_id
GROUP BY month, trust_tier
ORDER BY month, trust_tier;



CREATE VIEW vw_trust_tier_share AS
WITH base AS (
  SELECT
    CASE
      WHEN rating_overall < 4.5 THEN 'Low Trust'
      WHEN rating_overall <= 4.8 THEN 'Medium Trust'
      ELSE 'High Trust'
    END AS trust_tier
  FROM listings
  WHERE rating_overall IS NOT NULL
)
SELECT
  trust_tier,
  COUNT(*) AS listings_count,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM base), 2) AS pct_of_listings
FROM base
GROUP BY trust_tier
ORDER BY
  CASE trust_tier
    WHEN 'Low Trust' THEN 1
    WHEN 'Medium Trust' THEN 2
    ELSE 3
  END;


CREATE VIEW vw_trust_impact_vs_market AS
WITH tier_perf AS (
  SELECT
    CASE
      WHEN rating_overall < 4.5 THEN 'Low Trust'
      WHEN rating_overall <= 4.8 THEN 'Medium Trust'
      ELSE 'High Trust'
    END AS trust_tier,
    AVG(ttm_revpar) AS tier_revpar,
    AVG(ttm_adjusted_occupancy) AS tier_adj_occ,
    SUM(ttm_revenue) / NULLIF(SUM(ttm_available_days),0) AS tier_rev_per_avail_day
  FROM listings
  WHERE rating_overall IS NOT NULL
    AND ttm_revpar IS NOT NULL
    AND ttm_adjusted_occupancy IS NOT NULL
    AND ttm_revenue IS NOT NULL
    AND ttm_available_days > 0
  GROUP BY trust_tier
),
market AS (
  SELECT
    AVG(ttm_revpar) AS market_revpar,
    AVG(ttm_adjusted_occupancy) AS market_adj_occ,
    SUM(ttm_revenue) / NULLIF(SUM(ttm_available_days),0) AS market_rev_per_avail_day
  FROM listings
  WHERE rating_overall IS NOT NULL
    AND ttm_revpar IS NOT NULL
    AND ttm_adjusted_occupancy IS NOT NULL
    AND ttm_revenue IS NOT NULL
    AND ttm_available_days > 0
)
SELECT
  t.trust_tier,
  ROUND(100.0 * (t.tier_revpar / m.market_revpar - 1.0), 2) AS revpar_delta_pct,
  ROUND(100.0 * (t.tier_adj_occ / m.market_adj_occ - 1.0), 2) AS adj_occ_delta_pct,
  ROUND(100.0 * (t.tier_rev_per_avail_day / m.market_rev_per_avail_day - 1.0), 2) AS rev_per_avail_day_delta_pct
FROM tier_perf t
CROSS JOIN market m
ORDER BY
  CASE t.trust_tier
    WHEN 'Low Trust' THEN 1
    WHEN 'Medium Trust' THEN 2
    ELSE 3
  END;

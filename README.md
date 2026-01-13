Paris Airbnb Marketplace Analytics (SQL + Power BI)

This analysis reviews the Paris Airbnb short-term rental marketplace using listing-level data, trailing-twelve-month performance metrics, and historical calendar aggregates. The objective is to evaluate 
marketplace performance, understand how demand and revenue behave across the market, and assess how different characteristics and policies relate to variations in revenue efficiency and demand stability.

Technology Stack

- SQL (SQLite)
- DB Browser for SQLite (local development and query execution)
- Power BI (dashboarding and visualization)

Scope of Analysis

The analysis is structured around three connected areas, each addressed through a dedicated dashboard.

1. Marketplace performance

Provides an overview of overall marketplace activity and structure.

Revenue and occupancy behavior over time

Distribution of revenue across listings and room types

Balance between available and booked supply

2. Trust & guest experience impact

Explores how guest trust relates to marketplace performance.

Ratings and reviews in relation to revenue and occupancy

Performance differences across trust levels

Stability of demand across listings

3. Pricing, fees & booking behavior 

Examines how pricing and booking settings relate to performance.

Pricing levels and revenue outcomes

Booking rules and stay patterns

Fees and their relationship to revenue and occupancy

Project Components

Power BI Dashboards

Marketplace Performance: Supply, Demand & Revenue Efficiency

Trust Drives Demand

Price, Fees & Booking Dynamics

SQL (SQLite)

Table creation & data preparation script  
Creates base tables, cleans and casts data, and produces the final listings table.

Marketplace Performance SQL  
Views supporting Marketplace Performance: Supply, Demand & Revenue Efficiency.

Trust Analysis SQL  
Views supporting Trust Drives Demand.

Pricing & Booking Dynamics SQL  
Views supporting Price, Fees & Booking Dynamics.

Repository Structure

Power BI dashboards: ./powerbi/

SQL scripts: ./sql/

Data Structure & Sources

This analysis is based on a structured short-term rental dataset covering Airbnb listings in Paris, combining listing-level attributes with historical and forward-looking booking data.

The core dataset consists of four related tables:

Listings  
Contains one row per listing with static attributes (property type, room type, capacity, amenities, fees) and aggregated performance metrics, including trailing-twelve-month (TTM) revenue, occupancy, RevPAR,
and last-90-day indicators.  
This table serves as the primary reference for all segment-level analysis.

Past Calendar  
Monthly aggregated historical booking data for the past 12 months at the listing level.  
Used to analyze revenue and occupancy trends over time, booking lead time, length of stay, and demand stability.

Future Calendar  
Forward-looking monthly booking aggregates for the next 12 months.  
Included for completeness but not used in the core dashboards of this analysis.

Reviews Data  
Monthly review counts per listing.  
Used to evaluate demand persistence and the relationship between guest trust signals and performance.

All tables are linked through the shared listing_id, allowing listing-level attributes to be combined with historical booking behavior and review activity.

Data Source

The data was sourced from a publicly available Airbnb short-term rental market dataset providing listings, calendar, and review aggregates for the Paris market.

Dataset source: https://www.airroi.com/data-portal/markets/paris-france

Overview of Findings

The analysis shows that Paris Airbnb revenue is driven primarily by demand quality rather than listing availability, with revenue closely tracking occupancy and exhibiting clear seasonality. Performance is highly
concentrated in a small number of dominant listing segments, meaning overall marketplace outcomes are shaped mainly by changes within these segments rather than offset by growth in smaller categories. Trust and 
booking dynamics further differentiate performance, as higher-trust listings consistently achieve stronger occupancy and materially higher revenue efficiency, while pricing differences affect revenue primarily 
through efficiency rather than booking volume.

Key Insights — Marketplace Performance (Dashboard 1)

Revenue closely tracks demand over time.  
Monthly revenue and adjusted occupancy move in tandem across the year, with peak months reaching €1.13M in revenue at 56.45% occupancy and low-demand months falling below €0.45M with occupancy under 25%. 
There is no sustained upward or downward trend, indicating that performance fluctuations are driven by seasonality rather than structural growth or decline.

Marketplace performance is constrained by demand conversion rather than inventory availability.  
Across the trailing twelve months, the market shows 58.6% demand absorption, with 40,463 reserved days out of 69,037 available days. This indicates that available supply exceeds realized demand, and revenue 
outcomes are more sensitive to booking conversion and demand quality than to listing availability.

Revenue is highly concentrated in a small number of listing segments.  
Entire rental units account for the majority of marketplace revenue, generating €6.62M out of €8.71M total TTM revenue (~76%), despite having average adjusted occupancy levels similar to other segments.
Smaller listing types contribute marginal revenue even when occupancy is strong, reinforcing that scale, not occupancy alone, drives revenue impact.

High occupancy does not necessarily translate into high revenue contribution.  
Room-type analysis shows that private and shared rooms can achieve high adjusted occupancy (often above 70%), yet generate significantly lower RevPAR and total revenue compared to entire homes. 
Entire-home listings combine moderate occupancy with materially higher RevPAR, resulting in the dominant share of total revenue.

Pricing tier does not materially change booking volume at the market level.  
Average adjusted occupancy remains consistent across price tiers (36–37% for low, mid, and high price segments), indicating that higher pricing does not reduce booking frequency at an aggregate level. 
Revenue differences across tiers are therefore driven primarily by price and RevPAR, not by demand volume.

Recent revenue momentum pressure is concentrated in the largest revenue-driving segments.  
Most major listing and room-type segments show negative revenue momentum, including entire rental units at −16.4%, while segments with positive momentum represent a relatively small share of total revenue. 
As a result, short-term marketplace performance is primarily influenced by changes within dominant segments rather than offset by growth in smaller categories.

Marketplace Trust & Guest Experience Insights (Dashboard 2)

1. Marketplace trust level is high, but performance varies meaningfully by trust tier  
The Marketplace Trust Index is 4.74, indicating that the average listing in the market is highly rated. However, the tiered performance visuals show that this aggregate masks substantial differences in occupancy
 and revenue efficiency between High, Medium, and Low Trust listings.

3. Demand persistence is strong overall, but does not offset trust-related performance gaps  
The Demand Persistence KPI shows that 87.45% of listings receive reviews in more than one month, indicating repeat demand at the market level. Despite this, trust-tier charts show that listings with lower trust
consistently underperform on revenue efficiency and occupancy, suggesting persistence alone does not equal strong monetization.

5. Occupancy differs materially across trust tiers  
The Occupancy by Trust Tier chart shows that High Trust listings have visibly higher average occupancy than Low Trust listings, with Medium Trust closely tracking High Trust. The gap is most pronounced between
Low Trust and the other tiers, indicating that lower trust is associated with weaker demand conversion.

(This insight is drawn directly from the trust-tier occupancy bar chart, not from additional calculations.)

4. Revenue efficiency increases steadily with trust level  
Both the RevPAR by Trust Tier and Revenue per Available Day visuals show a clear ordering:  
High Trust listings generate the highest RevPAR and revenue per available day  
Medium Trust listings perform materially better than Low Trust  
Low Trust listings consistently sit at the bottom of both metrics  

This pattern indicates that higher trust is associated with more efficient revenue generation from available inventory.

5. Low Trust listings underperform on revenue efficiency despite contributing supply  
The Revenue per Available Day and Trust Impact vs Market visuals show that Low Trust listings generate significantly lower revenue per available day than the market average. This indicates that simply being
available in the marketplace does not translate into revenue without sufficient trust signals.

7. Trust-related performance gaps persist relative to the market baseline  
The Trust Impact vs Market chart shows that:  
High Trust listings outperform the market average on RevPAR, adjusted occupancy, and revenue per available day  
Medium Trust listings perform slightly below market levels  
Low Trust listings show a clear negative delta across all three metrics  

This confirms that trust is not only correlated with performance, but is associated with systematic performance differences relative to the overall market.

7. Review activity reinforces the trust–performance relationship  
The Review Trends by Trust Tier chart shows that High and Medium Trust listings consistently receive more reviews per month than Low Trust listings. This aligns with higher observed occupancy and revenue
 efficiency, reinforcing the link between guest engagement and performance outcomes.

Pricing, Fees & Booking Dynamics Insights (Dashboard 3)

1. Market-wide revenue efficiency is moderate relative to pricing levels  
The average daily rate across the market is €216, while average RevPAR is €79.3 at an average adjusted occupancy of 36.7%. This gap indicates that a large portion of listed price is not realized due to partial
occupancy, highlighting that revenue outcomes are driven by both pricing and demand realization rather than price alone.

3. Higher-priced listings account for a disproportionate share of total revenue  
The Price Tier Percentiles chart shows that the top price tercile (average ADR €381) generates €4.94M in total revenue, compared to €2.45M for the middle tier and €1.32M for the lowest tier.
This indicates that higher-priced listings contribute the majority of marketplace revenue despite representing a similar number of listings.

5. Occupancy remains relatively stable across pricing tiers  
Adjusted occupancy is similar across low, mid, and high price tiers, clustering around the mid-30% range. This suggests that, at the aggregate level, higher prices do not materially suppress booking volume, and revenue differences across tiers are primarily driven by price and RevPAR rather than demand frequency.

6. Cleaning fee levels are associated with meaningful differences in revenue efficiency  
The Cleaning Fee vs RevPAR chart shows a clear gradient in revenue efficiency. Listings with high cleaning fees (100+) achieve the highest average RevPAR (€154), while listings with no or low cleaning fees
cluster around €56–57 RevPAR. This indicates that higher cleaning fees tend to appear alongside listings that generate materially higher revenue per available day.

8. Extra guest fees show limited impact on occupancy outcomes  
The Extra Guest Fee vs Occupancy chart shows only minor variation in adjusted occupancy across fee levels, with occupancy remaining in a narrow range regardless of whether an extra guest fee is applied.
 This suggests that extra guest fees do not materially influence booking likelihood at the market level.

10. Booking lead time is strongly associated with demand quality  
The Lead Time Segments chart shows that bookings made 31+ days in advance achieve the highest average occupancy (65.4%) and strong daily revenue, while last-minute bookings (0–3 days) show substantially lower
occupancy (26.4%). This indicates that earlier bookings are associated with more stable and predictable demand outcomes.

12. Longer stays are associated with higher occupancy and revenue per day  
The Length of Stay Segments chart shows that bookings of 8+ nights achieve the highest average occupancy (68.5%) and the highest average daily revenue (€4,695), while short stays of 1–2 nights show materially
lower occupancy and revenue. This indicates that longer stays contribute to both demand stability and stronger revenue realization.

14. Minimum-night policies reflect a trade-off between occupancy and revenue efficiency  
The Minimum Nights Policy chart shows that listings with stricter minimum-night requirements (14+ nights) achieve relatively high occupancy (~39%) but significantly lower RevPAR (€35), while short minimum-night
listings (1 night) show higher RevPAR (€94) but lower occupancy (~24%). Mid-range minimum-night policies (2–6 nights) balance occupancy and RevPAR more effectively at the market level.

Business Recommendations

1. Prioritize demand conversion over expanding supply  
With only 58.6% of available days converting into reserved days, marketplace performance is constrained by booking conversion rather than inventory scarcity. Efforts should focus on improving demand quality and
conversion (e.g., trust, pricing clarity, booking policies) rather than increasing listing volume.

3. Focus performance optimization on dominant revenue segments  
Entire rental units generate approximately 76% of total marketplace revenue, yet also exhibit declining short-term revenue momentum. Because these segments drive the majority of revenue, even small improvements
in pricing, trust, or booking efficiency within them are likely to have a larger impact than growth initiatives targeting smaller segments.

5. Use differentiated success metrics by segment rather than uniform targets  
Occupancy and RevPAR vary meaningfully by room type, trust tier, and pricing tier. Applying a single performance benchmark across all listings risks misinterpreting results. Segment-specific benchmarks
   (separate targets for entire homes vs private rooms) would better reflect underlying economic differences.

7. Treat trust as a revenue efficiency lever, not just a quality metric  
High Trust listings consistently outperform the market on RevPAR, occupancy, and revenue per available day, while Low Trust listings underperform across all metrics. Improving trust signals
(ratings, review volume, guest experience consistency) should be viewed as a revenue optimization lever rather than solely a reputation metric.

9. Evaluate pricing strategy using revenue efficiency, not occupancy alone  
Pricing tiers show similar occupancy levels across the market, while revenue differences are driven by price and RevPAR. Pricing decisions should therefore be evaluated primarily on revenue per available day
rather than booking volume, to avoid optimizing for occupancy at the expense of revenue.

11. Encourage booking behaviors associated with demand stability  
Bookings made further in advance and longer stays are associated with higher occupancy and stronger daily revenue. Where possible, policies and pricing structures that support earlier bookings and longer stays
can help stabilize demand and improve revenue predictability.

13. Reassess minimum-night and fee policies with a trade-off lens  
Minimum-night requirements and cleaning fees show clear trade-offs between occupancy and revenue efficiency. Mid-range minimum-night policies and appropriately positioned fees appear to balance demand and
revenue more effectively than extremes, suggesting these policies should be reviewed with both metrics in mind rather than in isolation.

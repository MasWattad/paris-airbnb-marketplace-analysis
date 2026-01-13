
CREATE TABLE listings (
    listing_id TEXT,
    listing_name TEXT,
    listing_type TEXT,
    room_type TEXT,
    cover_photo_url TEXT,
    photos_count TEXT,
    host_id TEXT,
    host_name TEXT,
    cohost_ids TEXT,
    cohost_names TEXT,
    superhost TEXT,

    latitude TEXT,
    longitude TEXT,

    guests TEXT,
    bedrooms TEXT,
    beds TEXT,
    baths TEXT,

    registration TEXT,
    amenities TEXT,
    instant_book TEXT,
    professional_management TEXT,

    min_nights TEXT,
    cancellation_policy TEXT,
    currency TEXT,

    cleaning_fee TEXT,
    extra_guest_fee TEXT,
    num_reviews TEXT,

    rating_overall TEXT,
    rating_accuracy TEXT,
    rating_checkin TEXT,
    rating_cleanliness TEXT,
    rating_communication TEXT,
    rating_location TEXT,
    rating_value TEXT,

    ttm_revenue TEXT,
    ttm_revenue_native TEXT,
    ttm_avg_rate TEXT,
    ttm_avg_rate_native TEXT,
    ttm_occupancy TEXT,
    ttm_adjusted_occupancy TEXT,
    ttm_revpar TEXT,
    ttm_revpar_native TEXT,
    ttm_adjusted_revpar TEXT,
    ttm_adjusted_revpar_native TEXT,

    ttm_reserved_days TEXT,
    ttm_blocked_days TEXT,
    ttm_available_days TEXT,
    ttm_total_days TEXT,

    l90d_revenue TEXT,
    l90d_revenue_native TEXT,
    l90d_avg_rate TEXT,
    l90d_avg_rate_native TEXT,
    l90d_occupancy TEXT,
    l90d_adjusted_occupancy TEXT,
    l90d_revpar TEXT,
    l90d_revpar_native TEXT,
    l90d_adjusted_revpar TEXT,
    l90d_adjusted_revpar_native TEXT,

    l90d_reserved_days TEXT,
    l90d_blocked_days TEXT,
    l90d_available_days TEXT,
    l90d_total_days TEXT
);


CREATE TABLE past_calendar (
    listing_id INTEGER,
    date TEXT,
    vacant_days INTEGER,
    reserved_days INTEGER,
    occupancy REAL,
    revenue REAL,
    rate_avg REAL,
    booked_rate_avg REAL,
    booking_lead_time_avg INTEGER,
    length_of_stay_avg INTEGER,
    min_nights_avg INTEGER,
    native_booked_rate_avg REAL,
    native_rate_avg REAL,
    native_revenue REAL
);
CREATE TABLE future_calendar (
    listing_id INTEGER,
    date TEXT,
    vacant_days INTEGER,
    reserved_days INTEGER,
    occupancy REAL,
    revenue REAL,
    rate_avg REAL,
    booked_rate_avg REAL,
    booking_lead_time_avg INTEGER,
    length_of_stay_avg INTEGER,
    min_nights_avg INTEGER,
    native_booked_rate_avg REAL,
    native_rate_avg REAL,
    native_revenue REAL
);

CREATE TABLE reviews_data (
    listing_id INTEGER,
    date TEXT,
    num_reviews INTEGER,
    reviewers TEXT
);


CREATE TABLE listings_cleaned (
    listing_id INTEGER,
    listing_name TEXT,
    listing_type TEXT,
    room_type TEXT,
    cover_photo_url TEXT,
    photos_count INTEGER,

    host_id INTEGER,
    host_name TEXT,
    cohost_ids TEXT,
    cohost_names TEXT,
    superhost INTEGER,
    latitude REAL,
    longitude REAL,

    guests INTEGER,
    bedrooms INTEGER,
    beds INTEGER,
    baths REAL,

    registration TEXT,
    amenities TEXT,
    instant_book INTEGER,
    professional_management INTEGER,
    min_nights INTEGER,
    cancellation_policy TEXT,
    currency TEXT,
    cleaning_fee REAL,
    extra_guest_fee REAL,

    num_reviews INTEGER,
    rating_overall REAL,
    rating_accuracy REAL,
    rating_checkin REAL,
    rating_cleanliness REAL,
    rating_communication REAL,
    rating_location REAL,
    rating_value REAL,

    ttm_revenue REAL,
    ttm_revenue_native REAL,
    ttm_avg_rate REAL,
    ttm_avg_rate_native REAL,
    ttm_occupancy REAL,
    ttm_adjusted_occupancy REAL,
    ttm_revpar REAL,
    ttm_revpar_native REAL,
    ttm_adjusted_revpar REAL,
    ttm_adjusted_revpar_native REAL,
    ttm_reserved_days INTEGER,
    ttm_blocked_days INTEGER,
    ttm_available_days INTEGER,
    ttm_total_days INTEGER,

    l90d_revenue REAL,
    l90d_revenue_native REAL,
    l90d_avg_rate REAL,
    l90d_avg_rate_native REAL,
    l90d_occupancy REAL,
    l90d_adjusted_occupancy REAL,
    l90d_revpar REAL,
    l90d_revpar_native REAL,
    l90d_adjusted_revpar REAL,
    l90d_adjusted_revpar_native REAL,
    l90d_reserved_days INTEGER,
    l90d_blocked_days INTEGER,
    l90d_available_days INTEGER,
    l90d_total_days INTEGER
);

-- Insert & cast from raw listings

INSERT INTO listings_cleaned
SELECT
    CAST(NULLIF(listing_id,'') AS INTEGER),
    listing_name,
    listing_type,
    room_type,
    cover_photo_url,
    CAST(NULLIF(photos_count,'') AS INTEGER),

    CAST(NULLIF(host_id,'') AS INTEGER),
    host_name,
    cohost_ids,
    cohost_names,
    CASE WHEN LOWER(NULLIF(superhost,'')) IN ('true') THEN 1 ELSE 0 END,

    CAST(NULLIF(latitude,'') AS REAL),
    CAST(NULLIF(longitude,'') AS REAL),

    CAST(NULLIF(guests,'') AS INTEGER),
    CAST(NULLIF(bedrooms,'') AS INTEGER),
    CAST(NULLIF(beds,'') AS INTEGER),
    CAST(NULLIF(baths,'') AS REAL),

    registration,
    amenities,
    CASE WHEN instant_book IS NULL OR instant_book = '' OR LOWER(instant_book) = 'false' THEN 0 ELSE 1 END,
    CASE  WHEN professional_management IS NULL OR professional_management = '' OR LOWER(professional_management) = 'false' THEN 0 ELSE 1 END,
    CAST(NULLIF(min_nights,'') AS INTEGER),
    cancellation_policy,
    currency,
    CAST(NULLIF(cleaning_fee,'') AS REAL),
    CAST(NULLIF(extra_guest_fee,'') AS REAL),

    CAST(NULLIF(num_reviews,'') AS INTEGER),
    CAST(NULLIF(rating_overall,'') AS REAL),
    CAST(NULLIF(rating_accuracy,'') AS REAL),
    CAST(NULLIF(rating_checkin,'') AS REAL),
    CAST(NULLIF(rating_cleanliness,'') AS REAL),
    CAST(NULLIF(rating_communication,'') AS REAL),
    CAST(NULLIF(rating_location,'') AS REAL),
    CAST(NULLIF(rating_value,'') AS REAL),

    CAST(NULLIF(ttm_revenue,'') AS REAL),
    CAST(NULLIF(ttm_revenue_native,'') AS REAL),
    CAST(NULLIF(ttm_avg_rate,'') AS REAL),
    CAST(NULLIF(ttm_avg_rate_native,'') AS REAL),
    CAST(NULLIF(ttm_occupancy,'') AS REAL),
    CAST(NULLIF(ttm_adjusted_occupancy,'') AS REAL),
    CAST(NULLIF(ttm_revpar,'') AS REAL),
    CAST(NULLIF(ttm_revpar_native,'') AS REAL),
    CAST(NULLIF(ttm_adjusted_revpar,'') AS REAL),
    CAST(NULLIF(ttm_adjusted_revpar_native,'') AS REAL),
    CAST(NULLIF(ttm_reserved_days,'') AS INTEGER),
    CAST(NULLIF(ttm_blocked_days,'') AS INTEGER),
    CAST(NULLIF(ttm_available_days,'') AS INTEGER),
    CAST(NULLIF(ttm_total_days,'') AS INTEGER),

    CAST(NULLIF(l90d_revenue,'') AS REAL),
    CAST(NULLIF(l90d_revenue_native,'') AS REAL),
    CAST(NULLIF(l90d_avg_rate,'') AS REAL),
    CAST(NULLIF(l90d_avg_rate_native,'') AS REAL),
    CAST(NULLIF(l90d_occupancy,'') AS REAL),
    CAST(NULLIF(l90d_adjusted_occupancy,'') AS REAL),
    CAST(NULLIF(l90d_revpar,'') AS REAL),
    CAST(NULLIF(l90d_revpar_native,'') AS REAL),
    CAST(NULLIF(l90d_adjusted_revpar,'') AS REAL),
    CAST(NULLIF(l90d_adjusted_revpar_native,'') AS REAL),
    CAST(NULLIF(l90d_reserved_days,'') AS INTEGER),
    CAST(NULLIF(l90d_blocked_days,'') AS INTEGER),
    CAST(NULLIF(l90d_available_days,'') AS INTEGER),
    CAST(NULLIF(l90d_total_days,'') AS INTEGER)
FROM listings;


DROP TABLE IF EXISTS listings;
ALTER TABLE listings_cleaned RENAME TO listings;










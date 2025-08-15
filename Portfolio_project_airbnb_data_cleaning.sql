-- This SQL cleans the airbnb listings dataset 
-- Source: Database contains houses and hosts data

SELECT *
FROM [portfolio].[dbo].[airbnb_listings]


--standardize date format
SELECT host_since, CONVERT (Date, host_since)
FROM [portfolio].[dbo].[airbnb_listings]

ALTER TABLE airbnb_listings
ADD host_since_converted Date;

Update airbnb_listings
SET host_since_converted = CONVERT (Date, host_since)

SELECT host_since_converted
FROM [portfolio].[dbo].[airbnb_listings]


--
SELECT last_scraped, CONVERT (Date, last_scraped)
FROM [portfolio].[dbo].[airbnb_listings]

ALTER TABLE portfolio.dbo.airbnb_listings
ADD last_scraped_converted Date;

Update portfolio.dbo.airbnb_listings
SET last_scraped_converted = CONVERT (Date, last_scraped)

SELECT last_scraped_converted
FROM [portfolio].[dbo].[airbnb_listings]

--

SELECT calendar_last_scraped, CONVERT (Date, calendar_last_scraped)
FROM [portfolio].[dbo].[airbnb_listings]

ALTER TABLE portfolio.dbo.airbnb_listings
ADD calendar_last_scraped_converted Date;

Update portfolio.dbo.airbnb_listings
SET calendar_last_scraped_converted = CONVERT (Date, calendar_last_scraped)

SELECT calendar_last_scraped_converted
FROM [portfolio].[dbo].[airbnb_listings]

--checking essential amineties (true or false)
-- checking wifi
ALTER TABLE portfolio.dbo.airbnb_listings
ADD has_wifi nvarchar(225)







--standardize id format
SELECT *
FROM [portfolio].[dbo].[airbnb_listings]
order by [id] desc

SELECT [id], CAST(CAST(id AS float) AS bigint)
FROM [portfolio].[dbo].[airbnb_listings]

ALTER TABLE airbnb_listings
ADD id_converted bigint;

Update airbnb_listings
SET id_converted = CAST(CAST(id AS float) AS bigint)

SELECT id_converted
FROM [portfolio].[dbo].[airbnb_listings]

--change f to false, t to true
select host_is_superhost, host_has_profile_pic, host_identity_verified, instant_bookable, has_availability
FROM [portfolio].[dbo].[airbnb_listings]

UPDATE [portfolio].[dbo].[airbnb_listings]
SET host_is_superhost = CASE WHEN host_is_superhost = 't' THEN 'TRUE' WHEN host_is_superhost = 'f' THEN 'FALSE' ELSE host_is_superhost END,
    host_has_profile_pic = CASE WHEN host_has_profile_pic = 't' THEN 'TRUE' WHEN host_has_profile_pic = 'f' THEN 'FALSE' ELSE host_has_profile_pic END,
    host_identity_verified = CASE WHEN host_identity_verified = 't' THEN 'TRUE' WHEN host_identity_verified = 'f' THEN 'FALSE' ELSE host_identity_verified END,
    instant_bookable = CASE WHEN instant_bookable = 't' THEN 'TRUE' WHEN instant_bookable = 'f' THEN 'FALSE' ELSE instant_bookable END,
    has_availability = CASE WHEN has_availability = 't' THEN 'TRUE' WHEN has_availability = 'f' THEN 'FALSE' ELSE has_availability END

--



-- fill bathrooms column with numbers taken from bathroom_text column

SELECT bathrooms, bathrooms_text
FROM [portfolio].[dbo].[airbnb_listings]

UPDATE [portfolio].[dbo].[airbnb_listings]
SET bathrooms = TRY_CAST(
    LEFT(bathrooms_text, PATINDEX('%[^0-9.]%', bathrooms_text + ' ') - 1)
    AS DECIMAL(5,2)
)
WHERE bathrooms IS NULL
     AND PATINDEX('%[0-9]%', bathrooms_text) = 1;


--checking essential amineties (true or false)
-- checking wifi
ALTER TABLE portfolio.dbo.airbnb_listings
ADD has_wifi nvarchar(225)

UPDATE portfolio.dbo.airbnb_listings
SET has_wifi = CASE
                 WHEN LOWER(amenities) LIKE '%wifi%' THEN 'TRUE'
                 ELSE 'FALSE'
              END;

select has_wifi
from portfolio.dbo.airbnb_listings

-- removing duplicates

with row_num_CTE as(
Select *, 
    ROW_NUMBER() OVER(
    Partition by [host_id],
                 [room_type],
                 [latitude],
                 [longitude],
                 [property_type],
                 [price]                 
                 ORDER BY id_converted)
                 row_num
from portfolio.dbo.airbnb_listings
--order by [host_id]
)
--delete
select * 
from row_num_CTE
where row_num>1
order by latitude

-- drop unused columns

SELECT *
  FROM [portfolio].[dbo].[airbnb_listings]

ALTER TABLE [portfolio].[dbo].[airbnb_listings]
DROP COLUMN scrape_id, last_scraped, host_since, calendar_last_scraped
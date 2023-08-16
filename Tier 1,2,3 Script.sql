SELECT
    first_name,
    last_name,
    Gender,
    past_3_years_bike_related_purchases,
    DOB,
    job_title,
    job_industry_category,
    wealth_segment,
    deceased_indicator,
    owns_car,
    tenure,
    address,
    postcode,
    state,
    country,
    property_valuation,
    `Rank`,
    Value,
    IF((2023 - CAST(RIGHT(DOB, 4) AS UNSIGNED)) BETWEEN 45 AND 55
             AND state = 'QLD'
             AND past_3_years_bike_related_purchases >= 60
             AND owns_car = 'Yes'
             OR (job_industry_category = 'Financial Services' OR job_industry_category = 'Health')
             OR wealth_segment = 'Affluent Customer'
             AND property_valuation BETWEEN 9 AND 11,
        'Tier 1',
        IF((2023 - CAST(RIGHT(DOB, 4) AS UNSIGNED)) BETWEEN 30 AND 50
             AND (state = 'NSW' OR state = 'VIC')
             AND past_3_years_bike_related_purchases BETWEEN 20 AND 40
             AND owns_car = 'Yes'
             OR wealth_segment = 'Mass Customer',
        'Tier 2',
        'Tier 3')) AS customer_tier
FROM
    kpmg.new_customers;

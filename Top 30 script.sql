SELECT
    CONCAT(cust.first_name, ' ', cust.last_name) AS full_name,
    t.customer_id,
    cust.gender,
    cust.past_3_years_bike_related_purchases,
    cust.DOB,
    2023 - CAST(RIGHT(cust.DOB, 4) AS UNSIGNED) AS age,
    cust.job_title,
    cust.job_industry_category,
    cust.wealth_segment,
    cust.owns_car,
    addr.state,
    addr.property_valuation,
    COUNT(CASE WHEN t.order_status = 'Approved' THEN t.transaction_id END) AS approved_transaction_count,
    SUM(CASE WHEN t.order_status = 'Approved' THEN t.list_price END) AS approved_total_amount_spent,
    pc.most_common_product_class AS popular_purchase_class
FROM
    kpmg.transactions t
JOIN
    kpmg.customer_demographic cust ON t.customer_id = cust.customer_id
JOIN (
    SELECT
        customer_id,
        MAX(most_common_product_class) AS most_common_product_class
    FROM (
        SELECT
            customer_id,
            product_class AS most_common_product_class,
            COUNT(product_class) AS class_count
        FROM
            kpmg.transactions
        WHERE
            order_status = 'Approved'
        GROUP BY
            customer_id, product_class
    ) class_counts
    GROUP BY
        customer_id
) pc ON t.customer_id = pc.customer_id
JOIN kpmg.customer_address addr ON cust.customer_id = addr.customer_id -- Joining customer_address table
GROUP BY
    cust.first_name, cust.last_name, t.customer_id, pc.most_common_product_class,
    cust.gender, cust.past_3_years_bike_related_purchases, cust.DOB, cust.job_title,
    cust.job_industry_category, cust.wealth_segment, cust.deceased_indicator, cust.owns_car,
    addr.state, addr.property_valuation -- Adding state and property_valuation to the GROUP BY clause
ORDER BY
    approved_total_amount_spent DESC
LIMIT 30;

SELECT COUNT(*) AS total_sessions
FROM prime_cart_sessions;

--Query 1 — Overall Conversion Rate


SELECT
    COUNT(*) AS total_sessions,
    SUM(CASE
        WHEN Drop_off_Stage = 'Success' THEN 1
        ELSE 0
    END) AS successful_sessions,
    ROUND(
        SUM(CASE
            WHEN Drop_off_Stage = 'Success' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS conversion_rate_percentage
FROM prime_cart_sessions;


-- Query 2: Sessions ending at each stage

SELECT
    Drop_off_Stage,
    COUNT(*) AS sessions
FROM prime_cart_sessions
GROUP BY Drop_off_Stage
ORDER BY sessions DESC;

-- Query 3: Cart abandonment rate

SELECT
    COUNT(*) AS cart_sessions,
    SUM(Is_Abandoned) AS abandoned_sessions,
    ROUND(
        SUM(Is_Abandoned) * 100.0 / COUNT(*),
        2
    ) AS cart_abandonment_rate
FROM prime_cart_sessions
WHERE Is_Cart_Session = 1;

-- Query 4: Cart abandonment rate by Prime membership

SELECT
    Prime_Member_Status,
    COUNT(*) AS cart_sessions,
    SUM(Is_Abandoned) AS abandoned_sessions,
    ROUND(
        SUM(Is_Abandoned) * 100.0 / COUNT(*),
        2
    ) AS abandonment_rate
FROM prime_cart_sessions
WHERE Is_Cart_Session = 1
GROUP BY Prime_Member_Status
ORDER BY abandonment_rate DESC;

-- Query 5: Cart abandonment rate by device type

SELECT
    Device_Type,
    COUNT(*) AS cart_sessions,
    SUM(Is_Abandoned) AS abandoned_sessions,
    ROUND(
        SUM(Is_Abandoned) * 100.0 / COUNT(*),
        2
    ) AS abandonment_rate
FROM prime_cart_sessions
WHERE Is_Cart_Session = 1
GROUP BY Device_Type
ORDER BY abandonment_rate DESC;

-- Query 6: Cart abandonment rate by traffic source

SELECT
    Traffic_source,
    COUNT(*) AS cart_sessions,
    SUM(Is_Abandoned) AS abandoned_sessions,
    ROUND(
        SUM(Is_Abandoned) * 100.0 / COUNT(*),
        2
    ) AS abandonment_rate
FROM prime_cart_sessions
WHERE Is_Cart_Session = 1
GROUP BY Traffic_source
ORDER BY abandonment_rate DESC;

-- Query 7: Revenue at risk by traffic source

SELECT
    Traffic_source,
    COUNT(*) AS abandoned_sessions,
    ROUND(SUM(Total_Cart_Value), 2) AS revenue_at_risk
FROM prime_cart_sessions
WHERE Is_Abandoned = 1
    AND Value_Flag = 'OK'
    AND Value_Missing = 0
GROUP BY Traffic_source
ORDER BY revenue_at_risk DESC;

-- Query 8: Average session duration by outcome

SELECT
    Drop_off_Stage,
    COUNT(*) AS total_sessions,
    ROUND(AVG(Session_Duration_Mins), 2) AS avg_session_duration
FROM prime_cart_sessions
WHERE Session_Duration_Mins IS NOT NULL
    AND Duration_Flag = 'OK'
GROUP BY Drop_off_Stage
ORDER BY avg_session_duration DESC;

-- Query 9: Customer segment analysis

SELECT
    Segment,
    COUNT(*) AS total_sessions,
    ROUND(SUM(Total_Cart_Value), 2) AS total_cart_value
FROM prime_cart_sessions
WHERE Value_Flag = 'OK'
    AND Value_Missing = 0
GROUP BY Segment
ORDER BY total_cart_value DESC;

-- Query 10: Checkout and payment abandonment

SELECT
    Drop_off_Stage,
    COUNT(*) AS total_sessions,
    SUM(Is_Abandoned) AS abandoned_sessions,
    ROUND(
        SUM(Is_Abandoned) * 100.0 / COUNT(*),
        2
    ) AS abandonment_rate
FROM prime_cart_sessions
WHERE Drop_off_Stage IN ('Checkout', 'Payment')
GROUP BY Drop_off_Stage
ORDER BY Stage_Order;
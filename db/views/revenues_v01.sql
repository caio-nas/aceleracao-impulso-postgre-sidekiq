WITH last_month_of_the_year AS (
    SELECT concat(extract('YEAR' FROM CURRENT_DATE), '-', '12', '-', '01')::date as "last_month"
), months AS (
    select months::date as "month"
    from generate_series('2018-01-01'::date, (select "last_month" from last_month_of_the_year), '1 month') as months
), sells AS (
    SELECT *
    FROM months mm
             LEFT OUTER JOIN sales s ON date_trunc('month', s.closed_at) = mm.month
             LEFT OUTER JOIN car_value_references cvr ON s.car_value_reference_id = cvr.id
)

SELECT SUM(COALESCE(ss.value, 0)) as "value", ss.month as competency
FROM sells ss GROUP BY ss.month
ORDER BY ss.month ASC

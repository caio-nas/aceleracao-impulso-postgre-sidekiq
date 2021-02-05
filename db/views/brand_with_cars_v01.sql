SELECT bb.*, (
    SELECT array_to_json(array_agg(cvr)) FROM (
        SELECT cars.id, cars.name, (
            SELECT car_value_references.value FROM car_value_references
            WHERE car_value_references.car_id = cars.id
            ORDER BY car_value_references.competency DESC,
            car_value_references.created_at DESC LIMIT 1
        ) as "value"
    FROM cars WHERE cars.brand_id = bb.id) cvr
) AS cars
FROM brands AS bb
GROUP BY bb.id
HAVING (select count(*) from cars where cars.brand_id = bb.id) > 0
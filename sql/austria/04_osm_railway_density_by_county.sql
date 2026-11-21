-- Query 3: Cycleway Density by District
-- Purpose: Calculate cycleway density (km per sq km) in each district

-- Requirements:
-- - Use adminareas_a for districts (fclass = 'admin_level6')
-- - Use cycleways for line features
-- - Use ST_Intersects to match cycleways to districts
-- - Use ST_Intersection to clip cycleway segments to district boundaries
-- - Use ST_Length(geom::geography) for accurate cycleway lengths
-- - Convert meters to kilometers (divide by 1,000)
-- - Use ST_Area(geom::geography) for district area
-- - Convert square meters to square kilometers (divide by 1,000,000)
-- - Use a CTE to calculate intermediate metrics
-- - Calculate cycleway density = total_cycleway_length_km / district_area_sq_km
-- - Order results by cycleway density (highest first)

-- Expected Output:
-- - district_name
-- - total_cycleway_length_km
-- - district_area_sq_km
-- - cycleway_density_km_per_sq_km
-- - geom

WITH district_metrics AS (
    SELECT
        aa.name AS district_name,
        SUM(ST_Length(ST_Intersection(r.geom, aa.geom)::geography)) / 1000 AS total_cycleway_length_km,
        ST_Area(aa.geom::geography) / 1000000 AS district_area_sq_km,
        aa.geom
    FROM
        adminareas_a AS aa
    JOIN
        roads AS r ON ST_Intersects(aa.geom, r.geom)
    WHERE
        aa.fclass = 'admin_level6'
        AND r.fclass = 'cycleway'
    GROUP BY
        aa.name, aa.geom
)

SELECT
    district_name,
    total_cycleway_length_km,
    district_area_sq_km,
    total_cycleway_length_km / district_area_sq_km AS cycleway_density_km_per_sq_km,
    geom
FROM
    district_metrics
ORDER BY
    cycleway_density_km_per_sq_km DESC;
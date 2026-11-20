-- Query 2: Farmland by Region
-- Purpose: Calculate the total area of farmland in each region

-- Requirements:
-- - Use places_a for regions (fclass = 'region')
-- - Use landuse_a for farmland (fclass = 'farmland')
-- - Use ST_Intersects to join farmland to regions
-- - Use ST_Intersection to clip farmland geometries to region boundaries
-- - Use ST_Area(geom::geography) for accurate measurements on WGS84
-- - Convert square meters to square kilometers (divide by 1,000,000)
-- - Group results by region name
-- - Include geom column for spatial visualization

-- Expected Output:
-- - region_name
-- - farm_area_sq_km
-- - geom

SELECT
    pl.name AS region_name,
    SUM(ST_Area(ST_Intersection(l.geom, pl.geom)::geography)) / 1000000 AS farm_area_sq_km,
    pl.geom
FROM
    places_a AS pl
JOIN
    landuse_a AS l ON ST_Intersects(pl.geom, l.geom)
WHERE
    pl.fclass = 'region'
    AND l.fclass = 'farmland'
GROUP BY
    pl.name, pl.geom
ORDER BY
    farm_area_sq_km DESC;
-- Query 2: Vineyards by Region
-- Purpose: Calculate the total area of vineyards in each region

-- Requirements:
-- - Use places_a for regions (fclass = 'region')
-- - Use landuse_a for vineyard (fclass = 'vineyard')
-- - Use ST_Intersects to join vineyard to regions
-- - Use ST_Intersection to clip vineyard geometries to region boundaries
-- - Use ST_Area(geom::geography) for accurate measurements on WGS84
-- - Convert square meters to square kilometers (divide by 1,000,000)
-- - Group results by region name
-- - Include geom column for spatial visualization

-- Expected Output:
-- - region_name
-- - vineyard_area_sq_km
-- - geom

SELECT
    pl.name AS region_name,
    SUM(ST_Area(ST_Intersection(l.geom, pl.geom)::geography)) / 1000000 AS vineyard_area_sq_km,
    pl.geom
FROM
    places_a AS pl
JOIN
    landuse_a AS l ON ST_Intersects(pl.geom, l.geom)
WHERE
    pl.fclass = 'region'
    AND l.fclass = 'vineyard'
GROUP BY
    pl.name, pl.geom
ORDER BY
    vineyard_area_sq_km DESC;
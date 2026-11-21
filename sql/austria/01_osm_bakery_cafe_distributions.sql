-- Query 1: Bakeries and Cafes Locations
-- Purpose: Extract name and geometry of bakeries and cafes for geospatial analysis

-- Requirements:
-- - Use pois for point features
-- - Filter POIs where fclass = 'bakery' OR fclass = 'cafe'
-- - Return business name and raw point geometries
-- - (Optional) Clip to a specific region if needed

-- Expected Output:
-- - name, geom

SELECT
    name, geom
FROM
    pois
WHERE
    fclass IN ('bakery', 'cafe');


SELECT DISTINCT fclass
FROM landuse_a
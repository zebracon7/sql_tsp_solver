DROP TABLE team00;
CREATE TABLE team00 (
    point1 VARCHAR,
    point2 VARCHAR,
    cost NUMERIC
);
INSERT INTO team00
VALUES ('a', 'b', 10),
    ('b', 'a', 10),
    ('a', 'c', 15),
    ('c', 'a', 15),
    ('a', 'd', 20),
    ('d', 'a', 20),
    ('b', 'c', 35),
    ('c', 'b', 35),
    ('b', 'd', 25),
    ('d', 'b', 25),
    ('c', 'd', 30),
    ('d', 'c', 30);
WITH RECURSIVE rec AS (
    SELECT point1,
        point2,
        cost,
        point1 || ',' || point2 AS tour,
        1 AS level,
        ARRAY [point1, point2] AS visited_cities
    FROM team00
    UNION ALL
    SELECT r.point1,
        t.point2,
        r.cost + t.cost,
        r.tour || ',' || t.point2,
        r.level + 1 AS level,
        r.visited_cities || t.point2
    FROM rec r
        JOIN team00 t ON r.point2 = t.point1
    WHERE r.level < 3
        AND t.point2 != ALL(r.visited_cities)
),
final_paths AS (
    SELECT r.point1,
        r.point1 AS point2,
        r.cost + t.cost AS cost,
        r.tour || ',' || r.point1 AS tour,
        r.level + 1 AS level,
        r.visited_cities
    FROM rec r
        JOIN team00 t ON r.point2 = t.point1
    WHERE r.level = 3
        AND t.point2 = r.point1
),
min_cost_paths AS (
    SELECT cost AS min_cost
    FROM final_paths
    WHERE level = 4
    ORDER BY cost
    LIMIT 1
)
SELECT cost AS total_cost,
    ('{' || tour || '}') AS tour
FROM final_paths
WHERE level = 4
    AND LEFT(tour, 1) = 'a'
    AND cost = (
        SELECT min_cost
        FROM min_cost_paths
    )
ORDER BY cost,
    tour;
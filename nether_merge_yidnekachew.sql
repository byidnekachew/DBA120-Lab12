-- Biruk Yidnekachew on November 17, 2025 --

-- Q1
SELECT mob_name
    FROM fortress1
    WHERE spawns = (SELECT MAX(spawns) FROM fortress1);

-- Q2
SELECT mob_name
    FROM fortress1
    WHERE spawns >ANY (SELECT spawns FROM fortress2);

-- Q3
SELECT mob_name, biome_id
    FROM fortress1
    WHERE (mob_name, biome_id) IN (SELECT mob_name, biome_id FROM fortress2);

-- Q4
SELECT f1.mob_name, f1.biome_id, f1.spawns, 
        (SELECT AVG(spawns) FROM fortress1 g WHERE g.biome_id = f1.biome_id) AS biome_average, 
        CASE
            WHEN f1.spawns > (SELECT AVG(spawns) FROM fortress1 g WHERE g.biome_id = f1.biome_id)
            THEN 'Above biome spawns average'
            ELSE 'Below biome spawns average'
            END AS status
    FROM fortress1 f1;

-- Q5 (asked AI for how to calculate average of columns from multiple tables)
SELECT mob_name
    FROM fortress1 f1
    WHERE spawns > (SELECT AVG(spawns) FROM (SELECT spawns FROM fortress1 if1 WHERE f1.biome_id = if1.biome_id UNION ALL SELECT spawns FROM fortress2 if2 WHERE f1.biome_id = if2.biome_id));

-- Q6 (used AI to debug, didn't know I needed an AS for subquery columns)
WITH biome_summary AS(
    SELECT b.biome_id, b.biome_name,
    (SELECT AVG(spawns) FROM fortress1 f1 WHERE f1.biome_id = b.biome_id) AS fortress1_average,
    (SELECT AVG(spawns) FROM fortress2 f2 WHERE f2.biome_id = b.biome_id) AS fortress2_average
        FROM biomes b
)

SELECT * FROM biome_summary ORDER BY biome_id;

-- Q7
INSERT INTO fortress1
    SELECT * FROM fortress2 f2
    WHERE NOT EXISTS(SELECT mob_name FROM fortress1 f1 WHERE f1.mob_name = f2.mob_name);

-- Q8 (had to use AI to debug, figured out I can't use insert into)
MERGE INTO fortress1 f1
    USING fortress2 f2
    ON (f1.mob_name = f2.mob_name)
    WHEN MATCHED THEN
        UPDATE SET f1.spawns = f2.spawns, f1.last_seen = f2.last_seen
    WHEN NOT MATCHED THEN
        INSERT(mob_name, spawns, last_seen, biome_id)
            VALUES(f2.mob_name, f2.spawns, f2.last_seen, f2.biome_id);

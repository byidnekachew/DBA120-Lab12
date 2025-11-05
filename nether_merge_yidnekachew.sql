SELECT * FROM fortress1;
SELECT * FROM fortress2;
SELECT * FROM biomes;

-- 8
SELECT COUNT(*) AS start_count_f1 FROM fortress1;

-- Q1
SELECT MOB_NAME
    FROM fortress1
    WHERE spawns = (SELECT MAX(spawns) FROM fortress1);

-- Q2
SELECT MOB_NAME
    FROM fortress1
    WHERE spawns >ANY (SELECT spawns FROM fortress2);

-- Q3
SELECT mob_name, biome_id
    FROM fortress1
    WHERE (mob_name, biome_id) IN (SELECT mob_name, biome_id FROM fortress2);

-- Q4
SELECT f1.mob_name, f1.biome_id, f1.spawns, (SELECT AVG(spawns) FROM fortress1 g WHERE g.biome_id = f1.biome_id) AS biome_average
    FROM fortress1 f1;

-- Q5

-- Active: 1747423147344@@127.0.0.1@5432@conservation_db@public
CREATE Table rangers(
    ranger_id SERIAL UNIQUE,
    name VARCHAR(100),
    region VARCHAR(20)
)



CREATE Table species(
    species_id SERIAL UNIQUE,
    common_name VARCHAR(50),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
)


CREATE Table sightings(
    sighting_id SERIAL UNIQUE,
    ranger_id int REFERENCES rangers(ranger_id) on delete CASCADE,
    species_id int REFERENCES species(species_id) on delete set NULL,
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes TEXT
)

INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01 00:00:00', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01 00:00:00', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01 00:00:00', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01 00:00:00', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

SELECT * FROM sightings;

INSERT INTO rangers(name, region) VALUES ('Derek Fox', 'Coastal Plains');

SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;


SELECT *
FROM sightings
WHERE location LIKE '%Pass%';

SELECT r.name, count(s.sighting_id) as total_sighting
from rangers r
left JOIN sightings s on 
r.ranger_id=s.ranger_id
GROUP BY r.ranger_id,r.name
ORDER BY total_sighting DESC;



SELECT sp.common_name
FROM species sp
WHERE NOT EXISTS (
    SELECT 1 FROM sightings si WHERE si.species_id = sp.species_id
);

SELECT sp.common_name,s.sighting_time,r.name
FROM sightings s
JOIN species sp on s.species_id=sp.species_id
JOIN rangers r ON r.ranger_id=s.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;


UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

SELECT 
  sighting_id,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 5 AND 11 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 17 AND 20 THEN 'Evening'
    ELSE 'Night'
  END AS time_of_day
FROM sightings;

DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);

-- Pet Adoption System: selected queries recovered from pgAdmin history.
-- Read-only examples. Run after schema.sql and sample_data.sql.
-- Examples 1, 2 and 20 were adjusted for correct joins or deterministic ordering.

-- Joins

-- 1. Pets with their breed
SELECT pet_id,
       Pet.name AS pet_name,
       Breed.name AS breed_name,
       age, gender, status
FROM Pet
JOIN Breed ON Pet.breed_id = Breed.breed_id;

-- 2. Breeds with their species
SELECT breed_id,
       Breed.name AS breed_name,
       Species.name AS species_name
FROM Breed
JOIN Species ON Breed.species_id = Species.species_id;

-- 3. Applications with a recorded adoption
SELECT application_id,
       adopter_id,
       pet_id,
       application_date,
       status,
       adoption_date
FROM Application
  NATURAL JOIN Adoption;

-- 4. Pairs of pets in the same shelter
SELECT p1.name AS pet1,
       p2.name AS pet2,
       p1.shelter_id
FROM Pet p1
  INNER JOIN Pet p2
    ON p1.shelter_id = p2.shelter_id
   AND p1.pet_id < p2.pet_id;

-- 5. Pairs of pets with the same breed ID
SELECT p1.name  AS pet1_name,
       p2.name  AS pet2_name,
       p1.breed_id
FROM Pet p1
  INNER JOIN Pet p2
    ON p1.breed_id = p2.breed_id
   AND p1.pet_id < p2.pet_id;

-- 6. Pairs of applications submitted on the same date
SELECT a1.application_id AS app1,
       a1.adopter_id     AS adopter1,
       a2.application_id AS app2,
       a2.adopter_id     AS adopter2,
       a1.application_date
FROM Application a1
  INNER JOIN Application a2
    ON a1.application_date = a2.application_date
   AND a1.application_id  < a2.application_id;

-- 7. All combinations of breeds and shelters
SELECT b.name  AS breed,
       sh.name AS shelter
FROM Breed b
  CROSS JOIN Shelter sh
ORDER BY sh.name, b.name;

-- Aggregation

-- 8. Total pet age by shelter
SELECT shelter_id, SUM(age) AS total_age
FROM Pet
GROUP BY shelter_id
ORDER BY total_age DESC;

-- 9. Average pet age by shelter and status
SELECT shelter_id, status, AVG(age) AS avg_age
FROM Pet
GROUP BY shelter_id, status;

-- 10. Applicants with more than one application
SELECT adopter_id, COUNT(application_id) AS total_apps
FROM Application
GROUP BY adopter_id
HAVING COUNT(application_id) > 1;

-- 11. Number of pets by breed
SELECT b.name AS breed, COUNT(p.pet_id) AS total_pets
FROM Pet p
    JOIN Breed b ON p.breed_id = b.breed_id
GROUP BY b.name
ORDER BY total_pets DESC;

-- Subqueries

-- 12. Pets older than the overall average
SELECT pet_id, name, age
FROM Pet
WHERE age > (SELECT AVG(age) FROM Pet);

-- 13. Applicants who submitted an application
SELECT adopter_id, first_name, last_name
FROM Adopter
WHERE adopter_id IN (SELECT adopter_id FROM Application);

-- 14. Pets with at least one approved application
SELECT pet_id, name
FROM Pet p
WHERE (
    SELECT COUNT(*) FROM Application a
    WHERE a.pet_id = p.pet_id AND a.status = 'Approved'
) > 0;

-- 15. Applicants with at least one approved application
SELECT adopter_id, first_name, last_name
FROM Adopter a
WHERE EXISTS (
    SELECT 1 FROM Application ap
    WHERE ap.adopter_id = a.adopter_id AND ap.status = 'Approved'
);

-- 16. Pets older than every pet in shelter 2
SELECT pet_id, name, age
FROM Pet
WHERE age > ALL (SELECT age FROM Pet WHERE shelter_id = 2);

-- 17. Match an applicant using a row-valued subquery
SELECT adopter_id, first_name, last_name
FROM Adopter
WHERE (adopter_id, first_name) = (
    SELECT adopter_id, first_name FROM Adopter WHERE adopter_id = 1
);

-- Window functions

-- 18. Rank pets by age within each shelter
SELECT pet_id, name, shelter_id, age,
    RANK() OVER (PARTITION BY shelter_id ORDER BY age DESC) AS age_rank
FROM Pet;

-- 19. Compare each pet age with the preceding pet in its shelter
SELECT pet_id, name, shelter_id,
    age AS current_age,
    LAG(age) OVER (PARTITION BY shelter_id ORDER BY pet_id) AS prev_age,
    age - LAG(age) OVER (PARTITION BY shelter_id ORDER BY pet_id) AS diff
FROM Pet;

-- 20. Moving average of pet age over the last three applications by status
SELECT app.application_id, app.application_date, app.status, p.age,
    ROUND(AVG(p.age) OVER (
        PARTITION BY app.status
        ORDER BY app.application_date, app.application_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg
FROM Application app
    JOIN Pet p ON app.pet_id = p.pet_id;

-- 21. Overall average age and share of total pet age
SELECT pet_id, name, age,
    ROUND(AVG(age) OVER (), 2) AS avg_age,
    ROUND(age * 100.0 / SUM(age) OVER (), 2) AS pct_of_total
FROM Pet;

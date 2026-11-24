# Pet Adoption System

A PostgreSQL relational database for managing animal shelters, pets, adoption applications and adoption records. Developed as part of my Computer Science coursework at Astana IT University in 2026.

## Database structure

The database contains 7 tables, 117 sample records, 7 primary keys and 6 foreign keys.

```mermaid
erDiagram
    SPECIES ||--o{ BREED : includes
    BREED ||--o{ PET : classifies
    SHELTER ||--o{ PET : houses
    ADOPTER ||--o{ APPLICATION : submits
    PET ||--o{ APPLICATION : receives
    APPLICATION ||--o{ ADOPTION : leads_to

    SPECIES {
        int species_id PK
        varchar name
    }
    BREED {
        int breed_id PK
        varchar name
        int species_id FK
    }
    SHELTER {
        int shelter_id PK
        varchar name
        varchar address
        varchar phone
    }
    PET {
        int pet_id PK
        varchar name
        int breed_id FK
        int shelter_id FK
        int age
        varchar gender
        varchar status
    }
    ADOPTER {
        int adopter_id PK
        varchar first_name
        varchar last_name
        varchar contact_phone
    }
    APPLICATION {
        int application_id PK
        int adopter_id FK
        int pet_id FK
        date application_date
        varchar status
    }
    ADOPTION {
        int adoption_id PK
        int application_id FK
        timestamp adoption_date
    }
```

| Table | Records |
| --- | ---: |
| species | 3 |
| breed | 6 |
| shelter | 5 |
| pet | 30 |
| adopter | 30 |
| application | 33 |
| adoption | 10 |

## SQL examples

`queries.sql` includes 21 read-only examples covering:

- INNER, NATURAL, CROSS and self joins
- Aggregation with `COUNT`, `SUM`, `AVG`, `GROUP BY` and `HAVING`
- Subqueries, `IN`, `EXISTS` and `ALL`
- Window functions: `RANK`, `LAG` and moving averages

## Getting started

Requires PostgreSQL and pgAdmin (or the `psql` command-line client).

1. Create a new empty database named `pet_adoption`.
2. Open Query Tool for that database and execute `schema.sql`.
3. Execute `sample_data.sql` in the same database.
4. Open `queries.sql`, select an example and execute it to see the results.

Alternatively, run these commands after creating the empty database:

```sh
psql -X -v ON_ERROR_STOP=1 -d pet_adoption -f schema.sql
psql -X -v ON_ERROR_STOP=1 -d pet_adoption -f sample_data.sql
psql -X -v ON_ERROR_STOP=1 -d pet_adoption -f queries.sql
```

## Project notes

This portfolio version retains the original coursework schema and uses selected queries recovered from pgAdmin history. Contact information was replaced with fictional placeholders. Sample breed labels, one adoption date, seven pet statuses and one application status were adjusted for consistency. Two natural joins were changed to explicit foreign-key joins, and a tie-breaker was added to the moving-average query. The project was originally exported from PostgreSQL 18.1. It is an academic database, not a production application.

# Pet Adoption System

A PostgreSQL database for managing animal shelters, pets and adoption applications.

## Database structure

7 tables with 117 sample records.

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

## SQL queries

[queries.sql](queries.sql) contains 21 examples covering:

- Joins
- Aggregation and grouping
- Subqueries
- Window functions (`RANK`, `LAG`, moving averages)

## Run

1. Create an empty PostgreSQL database named `pet_adoption`.
2. Run `schema.sql` in pgAdmin Query Tool.
3. Run `sample_data.sql` in the same database.
4. Select and run examples from `queries.sql`.

Or use psql after creating the database:

```sh
psql -X -v ON_ERROR_STOP=1 -d pet_adoption -f schema.sql
psql -X -v ON_ERROR_STOP=1 -d pet_adoption -f sample_data.sql
psql -X -v ON_ERROR_STOP=1 -d pet_adoption -f queries.sql
```

Based on my database coursework. Sample data was anonymized and corrected for consistency, and a few queries were adjusted.

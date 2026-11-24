-- Pet Adoption System: database schema.

BEGIN;

CREATE TABLE public.species (
    species_id integer NOT NULL,
    name character varying(50) NOT NULL
);

CREATE TABLE public.breed (
    breed_id integer NOT NULL,
    name character varying(50) NOT NULL,
    species_id integer NOT NULL
);

CREATE TABLE public.shelter (
    shelter_id integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(200) NOT NULL,
    phone character varying(20) NOT NULL
);

CREATE TABLE public.pet (
    pet_id integer NOT NULL,
    name character varying(50) NOT NULL,
    breed_id integer NOT NULL,
    shelter_id integer NOT NULL,
    age integer NOT NULL,
    gender character varying(20) NOT NULL,
    status character varying(10),
    CONSTRAINT chk_positive_age CHECK ((age >= 0))
);

CREATE TABLE public.adopter (
    adopter_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    contact_phone character varying(20) NOT NULL
);

CREATE TABLE public.application (
    application_id integer NOT NULL,
    adopter_id integer NOT NULL,
    pet_id integer NOT NULL,
    application_date date NOT NULL,
    status character varying(20) NOT NULL
);

CREATE TABLE public.adoption (
    adoption_id integer NOT NULL,
    application_id integer NOT NULL,
    adoption_date timestamp without time zone NOT NULL
);

ALTER TABLE ONLY public.adopter
    ADD CONSTRAINT adopter_pkey PRIMARY KEY (adopter_id);

ALTER TABLE ONLY public.adoption
    ADD CONSTRAINT adoptionrecord_pkey PRIMARY KEY (adoption_id);

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (application_id);

ALTER TABLE ONLY public.breed
    ADD CONSTRAINT breed_pkey PRIMARY KEY (breed_id);

ALTER TABLE ONLY public.pet
    ADD CONSTRAINT pet_pkey PRIMARY KEY (pet_id);

ALTER TABLE ONLY public.shelter
    ADD CONSTRAINT shelter_pkey PRIMARY KEY (shelter_id);

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (species_id);

ALTER TABLE ONLY public.adoption
    ADD CONSTRAINT adoptionrecord_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.application(application_id);

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_adopter_id_fkey FOREIGN KEY (adopter_id) REFERENCES public.adopter(adopter_id);

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pet(pet_id);

ALTER TABLE ONLY public.breed
    ADD CONSTRAINT breed_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(species_id);

ALTER TABLE ONLY public.pet
    ADD CONSTRAINT pet_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.breed(breed_id);

ALTER TABLE ONLY public.pet
    ADD CONSTRAINT pet_shelter_id_fkey FOREIGN KEY (shelter_id) REFERENCES public.shelter(shelter_id);

COMMIT;

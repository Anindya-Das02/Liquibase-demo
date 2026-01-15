--liquibase formatted sql

--changeset anindya:create-type-pd_type
--comment: creating a type called pd_type
CREATE TYPE pd_type AS ENUM (
    'ELECTRONICS',
    'CLOTHING',
    'FURNITURE',
    'GROCERY',
    'STATIONERY'
);
--rollback DROP TYPE pd_type;
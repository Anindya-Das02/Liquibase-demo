--liquibase formatted sql

--changeset anindya:create-products
--comment: creating products table
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2)
);

--rollback DROP TABLE products;

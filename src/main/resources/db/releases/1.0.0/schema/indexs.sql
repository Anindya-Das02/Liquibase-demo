--liquibase formatted sql

--changeset anindya:idx_products_name
--comment: creating index for name
CREATE INDEX idx_products_name ON products(name);

--rollback DROP INDEX idx_products_name;
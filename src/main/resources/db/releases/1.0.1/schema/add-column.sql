--liquibase formatted sql

--changeset anindya:add-new-columns-to-products-table
ALTER TABLE products
ADD COLUMN type pd_type,
ADD COLUMN mfg_origin VARCHAR(255);

--rollback
--rollback ALTER TABLE products DROP COLUMN mfg_origin;
--rollback ALTER TABLE products DROP COLUMN type;

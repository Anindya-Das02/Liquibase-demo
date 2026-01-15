# Liquibase Demo (Spring boot + YAML + SQL)
Liquibase is an open-source, **database-independent library used to track, manage, and automate database schema changes**. It essentially acts as **version control for your database**, similar to how Git works for application code. It ensures that database updates are consistent, repeatable, and safe across all environments (Dev, QA, Production).

In this project, we will demonstrate how to implement automated database schema management using Spring Boot (Maven) and Liquibase. To showcase the flexibility of the tool, we will implement a multi-format approach utilizing:
- **YAML Master Changelogs:** To handle high-level organization and file inclusion logic.
- **SQL Formatted Liquibase:** To write native, optimized & easy to read database scripts while maintaining Liquibase’s version control features.

This demo will cover the end-to-end workflow—from configuring the pom.xml dependencies to executing changesets automatically during the application startup.

### Tech Stack
* Framework: Spring Boot 3.x
* Build Tool: Maven
* Database: Postgresql
* Database Migration: Liquibase 5.x
* Formats: YAML (Configuration) + SQL (Schema scripts / Incremental changes)
* Docker

### Core Components
#### Changelog File
This is the heart of Liquibase. It is a file (YAML, XML, JSON, or SQL) that acts as a master list of all your database changes. It doesn't contain the current state of the database; rather, it contains the history of how to get to the current state.

For this project, the entry point for all database migrations is the master changelog located at `src/main/resources/db/changelog/db.changelog-master.yaml`. As the project's root migration file, it is explicitly configured in `liquibase.properties` to serve as the starting point for all schema changes.

#### Changeset
A changeset is a single unit of work. For example, creating a users table is one changeset. Adding an index to that table would be a second changeset.
* **Atomic:** Each changeset should ideally represent one logical change.
* **Unique Identity:** Every changeset is identified by the combination of an id, an author, and the file path.

Eg: `src/main/resources/db/releases/1.0.0/schema/indexs.sql` & `src/main/resources/db/releases/1.0.0/schema/products.sql`

#### DATABASECHANGELOG Table
When Liquibase runs against a database for the first time, it automatically creates this table. It tracks:
* Which changesets have been executed.
* The date/time of execution.
* A MD5Sum (hash) of the changeset. If you change the code of a changeset after it has already run, Liquibase will throw an error to prevent inconsistent data.

#### DATABASECHANGELOGLOCK Table
This prevents multiple people or services from updating the database at once. It’s a simple "flag" table that ensures only one Liquibase instance has control of the schema at a time.

### How to Run:
1. Once the project is cloned, build the project using the command:
    ```shell
    mvn clean package
    ```
   ** **_NOTE:_** you'll always need to run this command after you make any changes inside `src/main/resources/db/**` or else your changes won't be reflected in the output.
2. We need a database ready. In this demonstration we'll be using Docker to spin up a Postgresql Database. To run it execute 
    ```shell
    docker-compose -f docker-db/docker-compose.yaml up -d
    ```
3. Run the `liquibase:update` command to update the schemas. Since we are using maven in this case, the command will be
    ```shell
    mvn liquibase:update -Dliquibase.propertyFile=src/main/resources/liquibase.properties
    ```


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

For this project, the entry point for all database migrations is the master changelog located at `src/main/resources/db/changelog/db.changelog-master.yaml`. As the project's root migration file, it is explicitly configured in `liquibase-local.properties` to serve as the starting point for all schema changes.

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
3. **Updating DB:** Database schema updates are managed using Liquibase via Maven profiles.
   To apply schema changes, run the `liquibase:update` goal along with the appropriate Maven profile `(-P<profile>)`. Since this project uses Maven and the goal is to update the schema in the local environment, we run:
    ```shell
    mvn liquibase:update -Plocal
    ```
   The spring boot application will start & the liquibase scripts will run, updating the database. You'll see log like given below:
   ```
   [INFO] Scanning for projects...
   [INFO] 
   [INFO] -----------------------< in.das:liquibase-proj >------------------------
   [INFO] Building liquibase-proj 0.0.1-SNAPSHOT
   [INFO]   from pom.xml
   [INFO] --------------------------------[ jar ]---------------------------------
   [INFO] 
   [INFO] --- liquibase:5.0.1:update (default-cli) @ liquibase-proj ---
   [WARNING]  Parameter 'promptOnNonLocalDatabase' (user property 'liquibase.promptOnNonLocalDatabase') is deprecated: No longer prompts
   [INFO] ------------------------------------------------------------------------
   [INFO] Parsing Liquibase Properties File
   [INFO]   File: src/main/resources/liquibase-local.properties
   [INFO] ------------------------------------------------------------------------
   [INFO] ####################################################
   ##   _     _             _ _                      ##
   ##  | |   (_)           (_) |                     ##
   ##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
   ##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
   ##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
   ##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
   ##              | |                               ##
   ##              |_|                               ##
   ##                                                ## 
   ##  Get documentation at docs.liquibase.com       ##
   ##  Get certified courses at learn.liquibase.com  ## 
   ##                                                ##
   ####################################################
   Starting Liquibase at 00:19:17 using Java 21.0.2 (version 5.0.1 #9400 built at 2025-10-03 17:37+0000)
   [INFO] Settings
   ----------------------------
   [INFO]     driver: org.postgresql.Driver
   [INFO]     url: jdbc:postgresql://localhost:5434/liquibasedb
   [INFO]     username: *****
   [INFO]     password: *****
   [INFO]     use empty password: false
   [INFO]     properties file: src/main/resources/liquibase-local.properties
   [INFO]     properties file will override? true
   [INFO]     clear checksums? false
   [INFO]     changeLogDirectory: null
   [INFO]     changeLogFile: db/changelog/db.changelog-master.yaml
   [INFO]     context(s): local
   [INFO]     label(s): null
   [INFO]     number of changes to apply: 0
   [INFO]     drop first? false
   [INFO] ------------------------------------------------------------------------
   [INFO] Set default schema name to public
   [INFO] Parsing Liquibase Properties File src/main/resources/liquibase-local.properties for changeLog parameters
   [INFO] Executing on Database: jdbc:postgresql://localhost:5434/liquibasedb
   [INFO] Creating database changelog table with name: databasechangelog
   [INFO] Reading from databasechangelog
   [INFO] Creating snapshot
   [INFO] Successfully acquired change log lock
   [INFO] Using deploymentId: 8675757006
   [INFO] Reading from databasechangelog
   [INFO] Running Changeset: db/releases/1.0.0/schema/products.sql::create-products::anindya
   [INFO] Custom SQL executed
   [INFO] ChangeSet db/releases/1.0.0/schema/products.sql::create-products::anindya ran successfully in 26ms
   [INFO] Running Changeset: db/releases/1.0.0/schema/indexs.sql::idx_products_name::anindya
   [INFO] Custom SQL executed
   [INFO] ChangeSet db/releases/1.0.0/schema/indexs.sql::idx_products_name::anindya ran successfully in 15ms
   [INFO] Running Changeset: db/releases/1.0.0/changelog-release.yaml::tag-1.0.0::anindya
   [INFO] Tag '1.0.0' applied to database
   [INFO] ChangeSet db/releases/1.0.0/changelog-release.yaml::tag-1.0.0::anindya ran successfully in 29ms
   [INFO] Running Changeset: db/releases/1.0.1/schema/create-types.sql::create-type-pd_type::anindya
   [INFO] Custom SQL executed
   [INFO] ChangeSet db/releases/1.0.1/schema/create-types.sql::create-type-pd_type::anindya ran successfully in 9ms
   [INFO] Running Changeset: db/releases/1.0.1/schema/add-column.sql::add-new-columns-to-products-table::anindya
   [INFO] Custom SQL executed
   [INFO] ChangeSet db/releases/1.0.1/schema/add-column.sql::add-new-columns-to-products-table::anindya ran successfully in 7ms
   [INFO] Running Changeset: db/releases/1.0.1/changelog-release.yaml::tag-1.0.1::anindya
   [INFO] Tag '1.0.1' applied to database
   [INFO] ChangeSet db/releases/1.0.1/changelog-release.yaml::tag-1.0.1::anindya ran successfully in 3ms
   
   UPDATE SUMMARY
   Run:                          6
   Previously run:               0
   Filtered out:                 0
   -------------------------------
   Total change sets:            6
   
   [INFO] UPDATE SUMMARY
   [INFO] Run:                          6
   [INFO] Previously run:               0
   [INFO] Filtered out:                 0
   [INFO] -------------------------------
   [INFO] Total change sets:            6
   [INFO] Update summary generated
   [INFO] Update command completed successfully.
   [INFO] Liquibase: Update has been successful. Rows affected: 0
   [INFO] Successfully released change log lock
   [INFO] Command execution complete
   [INFO] ------------------------------------------------------------------------
   [INFO] 
   [INFO] ------------------------------------------------------------------------
   [INFO] BUILD SUCCESS
   [INFO] ------------------------------------------------------------------------
   [INFO] Total time:  5.487 s
   [INFO] Finished at: 2026-01-18T00:19:19+05:30
   [INFO] ------------------------------------------------------------------------
   
   Process finished with exit code 0
   ```
   ---
   **Side Note #1: (Optional)**  
   Multiple Maven profiles can be defined to support different environments (eg: local, dev, prod, etc).
   Each profile points to a dedicated `liquibase-<env>.properties` file containing environment-specific database configuration. To create new profile, modify the `pom.xml` following the below example:
   ```xml
   <profiles>
      <profile>
         <id>local</id>
         <properties>
             <liquibase.propertyFile>src/main/resources/liquibase-local.properties</liquibase.propertyFile>
         </properties>
      </profile>
      <profile>
         <id>[new profile]</id>
         <properties>
             <liquibase.propertyFile>[path to .properties file]</liquibase.propertyFile>
         </properties>
      </profile>
      <!-- Additional profiles such as qa, uat, stage, prod can be added here -->
   </profiles>
   ```
   ---
   **Side Note #2: (Optional)**  
   If you prefer not to define Maven profiles in `pom.xml`, you can directly specify the Liquibase properties file as a command-line argument. For this run the following command:
   ```shell
   mvn liquibase:update -Dliquibase.propertyFile=src/main/resources/liquibase-local.properties
   ```
   _** This approach can be useful for quick local testing or one-off executions, without modifying the project’s Maven configuration._
4. **Performing Rollbacks:** Liquibase supports rolling back database changes to a specific version using tags. To roll back the database to a previously tagged version _(in this case rolling back to version 1.0.0 from version 1.0.1)_, we run:
   ```shell
   mvn liquibase:rollback -Dliquibase.rollbackTag=1.0.0 -Plocal
   ```
   The rollback logs are as follows:
   ```
   [INFO] Scanning for projects...
   [INFO] 
   [INFO] -----------------------< in.das:liquibase-proj >------------------------
   [INFO] Building liquibase-proj 0.0.1-SNAPSHOT
   [INFO]   from pom.xml
   [INFO] --------------------------------[ jar ]---------------------------------
   [INFO] 
   [INFO] --- liquibase:5.0.1:rollback (default-cli) @ liquibase-proj ---
   [WARNING]  Parameter 'promptOnNonLocalDatabase' (user property 'liquibase.promptOnNonLocalDatabase') is deprecated: No longer prompts
   [INFO] ------------------------------------------------------------------------
   [INFO] Parsing Liquibase Properties File
   [INFO]   File: src/main/resources/liquibase-local.properties
   [INFO] ------------------------------------------------------------------------
   [INFO] ####################################################
   ##   _     _             _ _                      ##
   ##  | |   (_)           (_) |                     ##
   ##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
   ##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
   ##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
   ##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
   ##              | |                               ##
   ##              |_|                               ##
   ##                                                ## 
   ##  Get documentation at docs.liquibase.com       ##
   ##  Get certified courses at learn.liquibase.com  ## 
   ##                                                ##
   ####################################################
   Starting Liquibase at 00:24:21 using Java 21.0.2 (version 5.0.1 #9400 built at 2025-10-03 17:37+0000)
   [INFO] Settings
   ----------------------------
   [INFO]     driver: org.postgresql.Driver
   [INFO]     url: jdbc:postgresql://localhost:5434/liquibasedb
   [INFO]     username: *****
   [INFO]     password: *****
   [INFO]     use empty password: false
   [INFO]     properties file: src/main/resources/liquibase-local.properties
   [INFO]     properties file will override? true
   [INFO]     clear checksums? false
   [INFO]     changeLogDirectory: null
   [INFO]     changeLogFile: db/changelog/db.changelog-master.yaml
   [INFO]     context(s): local
   [INFO]     label(s): null
   [INFO]     rollback Count: -1
   [INFO]     rollback Date: null
   [INFO]     rollback Tag: 1.0.0
   [INFO] ------------------------------------------------------------------------
   [INFO] Set default schema name to public
   [INFO] Parsing Liquibase Properties File src/main/resources/liquibase-local.properties for changeLog parameters
   [INFO] Executing on Database: jdbc:postgresql://localhost:5434/liquibasedb
   [INFO] Reading from databasechangelog
   [INFO] Successfully acquired change log lock
   [INFO] Reading from databasechangelog
   [INFO] Rolling Back Changeset: db/releases/1.0.1/changelog-release.yaml::tag-1.0.1::anindya
   [INFO] Rolling Back Changeset: db/releases/1.0.1/schema/add-column.sql::add-new-columns-to-products-table::anindya
   [INFO] Rolling Back Changeset: db/releases/1.0.1/schema/create-types.sql::create-type-pd_type::anindya
   [INFO] Rolling Back Changeset: db/releases/1.0.0/changelog-release.yaml::tag-1.0.0::anindya
   [INFO] Rollback command completed successfully.
   [INFO] Successfully released change log lock
   [INFO] Command execution complete
   [INFO] ------------------------------------------------------------------------
   [INFO] 
   [INFO] ------------------------------------------------------------------------
   [INFO] BUILD SUCCESS
   [INFO] ------------------------------------------------------------------------
   [INFO] Total time:  3.797 s
   [INFO] Finished at: 2026-01-18T00:24:23+05:30
   [INFO] ------------------------------------------------------------------------
   
   Process finished with exit code 0
   ```
### Important Points

- When applying database updates, Liquibase executes changesets sequentially from **top to bottom** as defined in the `changelog-release.yaml` file.
- Similarly, during a rollback, Liquibase reverts changesets in reverse order **(bottom to top)** of their execution, based on the rollback logic defined in the changelog.

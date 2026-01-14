# Denodo-to-Snowflake Logic Migration Tool

## 1. Project Overview
This project provides an automated pipeline to extract, clean, and refactor data transformation logic from **Denodo Virtual Data Port (VDP)** into **Snowflake-native SQL**. 

Instead of manual "copy-paste" migration, this tool uses Python and JDBC to interface with Denodo’s metadata catalog. This ensures a repeatable, version-controlled process that minimizes human error and significantly reduces migration time.

## 2. Architecture: Virtualization to Materialization
The migration shifts the "Transformation" (T) in ELT from a virtualization layer to a cloud data warehouse:

* **Source:** Denodo Virtual Views (VQL) – Logic executed "on-the-fly" against source systems.
* **Target:** Snowflake Views/Dynamic Tables – Logic executed natively on data landed by Informatica.



---

## 3. The Migration Workflow
The tool follows a four-stage process to ensure logic parity and code cleanliness:

### Phase 1: Metadata Extraction
Using the Denodo JDBC driver, the script queries Denodo’s internal stored procedures:
* `GET_VIEWS()`: Retrieves the SQL definition (VQL) for all virtual artifacts.
* `VIEW_DEPENDENCIES()`: Maps the lineage to ensure views are created in the correct order in Snowflake (e.g., Base Layer -> Integration Layer -> Presentation Layer).

### Phase 2: Logic Cleaning (The "Refactor")
Denodo VQL contains proprietary metadata that Snowflake cannot interpret. The Python cleaning engine automatically:
* **Strips Contextual Hints:** Removes `CONTEXT ('i18n' = 'us_est', ...)`
* **Removes Cache Settings:** Removes `ALTER VIEW ... CACHE ...`
* **Cleans Layout Metadata:** Removes coordinate and folder metadata comments.
* **Maps Syntax:** Converts Denodo-specific types (e.g., `int8`, `text`) to Snowflake types (`NUMBER`, `VARCHAR`).

### Phase 3: Schema Mapping
The script identifies Denodo folder paths (e.g., `trusted.`, `presentation.`) and maps them to the corresponding Snowflake Databases and Schemas provided by the Informatica engineering team.

### Phase 4: Validation
Generates a "Summary Report" comparing column counts and data types between the source Denodo view and the newly created Snowflake view to ensure 1:1 parity.

---

## 4. Technical Setup

### Prerequisites
* **Python 3.8+**
* **Denodo VDP JDBC Driver** (`denodo-vdp-jdbcdriver.jar`)
* **Python Libraries:** `jaydebeapi`, `pandas`, `re`

### Folder Structure
```text
├── drivers/                # Denodo JDBC .jar files
├── scripts/
│   ├── extract_vql.py      # Main extraction logic via JDBC
│   ├── clean_logic.py      # Regex module for SQL refactoring
│   └── mapping_config.csv  # Mapping Denodo Folders -> Snowflake Schemas
├── output/
│   ├── raw_vql/            # Unmodified Denodo exports
│   └── snowflake_sql/      # Refactored, ready-to-deploy Snowflake SQL
└── README.md
#import "template.typ": *

#show: project.with(
  title: "Denodo Logic Extraction",
  authors: "Robinson Ryan"
)



#major-heading[Phase 1: Denodo Logic Extraction]


To begin with we will extract the logic from Denodo programatically. This is to reduce human error and make this process repeatable if additional Denodo views are required to be added later. 

To work with this programmatically we will use the 
#link("https://community.denodo.com/drivers/jdbc/9")[Denodo JDBC driver] 
which allows working with Denodo in Python.


- The 

Use the Denodo JDBC driver, the script queries Denodo's internal stored procedures:

- `GET_VIEWS()`: Retrieves the SQL definition (VQL) for all virtual artifacts.
- `VIEW_DEPENDENCIES()`: Maps the lineage to ensure views are created in the correct order in Snowflake (e.g., Base Layer -> Integration Layer -> Presentation Layer).

#major-heading[Phase 2: Logic Cleaning (Refactor)]
Denodo VQL contains proprietary metadata that Snowflake cannot interpret. The Python cleaning engine automatically:

- **Strips Contextual Hints:** Removes `CONTEXT ('i18n' = 'us_est', ...)`
- **Removes Cache Settings:** Removes `ALTER VIEW ... CACHE ...`
- **Cleans Layout Metadata:** Removes coordinate and folder metadata comments.
- **Maps Syntax:** Converts Denodo-specific types (e.g., `int8`, `text`) to Snowflake types (`NUMBER`, `VARCHAR`).

#major-heading[Architecture: Virtualization to Materialization]
The migration shifts the "Transformation" (T) in ELT from a virtualization layer to a cloud data warehouse:

- *Source:* Denodo Virtual Views (VQL) – Logic executed "on-the-fly" against source systems.
- *Target:* Snowflake Views/Dynamic Tables – Logic executed natively on data landed by Informatica.
#import "template.typ": *

#show: project.with(
  title: "Denodo Logic Extraction",
  authors: "Robinson Ryan"
)



#major-heading[Phase 1: Denodo Logic Extraction]

#section-heading[Summary]
We will automate the extraction of transformation logic from Denodo for accuracy and repeatability. Instead of manually copying SQL code, a script will connect to the Denodo system and download the extract the metadata directly. 

This will reduce the potential for human error when copying the extremely large number of views and integration logic. 

Denodo views are built in layers; starting from the raw base layers, progressing in complexity as more integration logic is used to maniupate these base views and create more views on top of them forming a hierarchical strcuture. 

To simplify this complexity, we will programmatically capture a views dependencies by using built in Denodo functions and then ordering the views by their dependencies. In this way we can recreate the views in the correct order within snowflake,.


#section-heading[Technical Implementation]

We can use the
#link("https://community.denodo.com/drivers/odbc/9")[Denodo ODBC driver] combined with the 
#link("https://github.com/blue-yonder/turbodbc")[turbodbc] 
library to connect to Denodo. This allows for OAUTH integration, which is necessary as the current Denodo environment does not allow plain-text password gerneration for security. 

The extraction script will use this ODBC connection to query Denodo's internal stored procedures:

- #link("https://community.denodo.com/docs/html/browse/9.3/en/vdp/vql/stored_procedures/predefined_stored_procedures/view_dependencies")[`GET_VIEWS()`]: Gets the VQL definition for virtual Denodo scripts. VQL being Denodo-specific SQL.
- #link("https://community.denodo.com/docs/html/browse/9.3/en/vdp/vql/stored_procedures/predefined_stored_procedures/view_dependencies")[`VIEW_DEPENDENCIES()`]: Maps the lineage to ensure views are recreated in the correct order in Snowflake. There will be an additional sorting algorithm that we will use to ensure views are ordered correctly.

#major-heading[Phase 2: Logic Cleaning (Refactor)]

#section-heading[Summary]



The SQL code exported from Denodo (VQL) is not directly compatible with Snowflake. It contains Denodo-specific metadata and their own syntax. 

To rewrite these VQL scripts in Snowflake SQL we can automate some of the cleaning up by replacing Denodo functions and syntax with their Snowflake equivalents by using a mapping dictionary. 

As well as this we will create a Raw Srouce to Denodo Name Mapping. Since Snowflake will now hold the raw data as it was landed from the source, we must account for naming discrepancies to make sure that the refactored SQL correctly points to the appropriate Snowflake objects while maintaining the busines naming conventions established in Denodo. 

There may of course still be some manual work required in the cases where a function doesn't map 1-1 to a Snowflake equivalent. These functions that are not easily replaceable can be flagged with a script, so that manual attention can be given to them. 

#major-heading[Creation in Snowflake]
The migration shifts the "Transformation" (T) in ELT from a virtualization layer to a cloud data warehouse:

- *Source:* Denodo Virtual Views (VQL) – Logic executed "on-the-fly" against source systems.
- *Target:* Snowflake Views/Dynamic Tables – Logic executed natively on data landed by Informatica.

#major-heading[Validation of Created Views]

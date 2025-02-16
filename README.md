---

# MyWorkplace

## NOTES

### Clarification on MS SQL Server Version 15 Compatibility
- There is no such version as "MS SQL Server version 15" unless it refers to build `15.X.XXXX.X`, which corresponds to **SQL Server 2019**.

---

### Data Quality Issues

1. **Mismatch between `id` and `parent_id`**:
   - There are **63 rows** where the `parent_id` value does not exist in the `id` column.
   - This inconsistency affects the database architecture.

2. **Insertion Issues**:
   - Even after excluding these 63 rows, data cannot be inserted into the table due to the presence of special characters that prevent the operation.

3. **Categorization in `phoenix.csv`**:
   - The columns defining categories and subcategories in the `phoenix.csv` file could be separated into dedicated tables.
   - However, this would require significant data refinement.

4. **Invalid Polygons**:
   - Some polygons are invalid. They can be identified using the following query:
     ```sql
     SELECT * FROM pois
     WHERE WKTPolygon.STIsValid() = 0;
     ```
   - The data can be corrected using the following script:
     ```sql
     UPDATE pois
     SET WKTPolygon = WKTPolygon.MakeValid()
     WHERE WKTPolygon.STIsValid() = 0;
     ```

---

## INSTRUCTIONS

### 1. Download Files
Download the files from the following location:  
[MyWorkplace GitHub Repository](https://github.com/vladimir-antovic/MyWorkplace)

- **`CityGuideDB.full.bak`**: This is the database backup file.
- **`README.txt`**: This file contains notes and instructions.
- **`CreateGeojson.sql`**: This script generates GeoJSON.

---

### 2. Restore the Database
Restore the database (named `CityGuideDB`) using the following script:

```sql
USE [master]
RESTORE DATABASE [CityGuideDB] FROM  DISK = N'D:\billups project\CityGuideDB.full.bak' WITH  FILE = 1,  
MOVE N'CityGuideDB' TO N'C:\your\path\CityGuide.mdf',  
MOVE N'CityGuide_data' TO N'C:\your\path\CityGuide_data.ndf',  
MOVE N'CityGuideDB_log' TO N'C:\your\path\CityGuide_log.ldf',  
NOUNLOAD,  STATS = 5
GO
```

---

### 3. Database Diagram
After restoring the database, you can view the table structures in the database diagram named **`Diagram_0`**.

---

### 4. Stored Procedure
The stored procedure **`dbo.FindPOIs`** can be found under:  
**Programmability > Stored Procedures**.

---

### 5. Execute the Stored Procedure
Run the following scripts to execute the stored procedure (modify the JSON parameter values as needed):

#### Example 1: All Criteria Filled
```sql
DECLARE @Criteria NVARCHAR(MAX);
SET @Criteria = '{
    "CountryCode": "US",
    "RegionCode": "MD",
    "CityID": 1,
    "Latitude": 39.467884,
    "Longitude": -76.576101,
    "Radius": 200,
    "WKTPolygon": "POLYGON ((-112.11565892899995 33.58791448100004, -112.11564258099997 33.58768658400004, -112.11562633599999 33.587687378000055, -112.11561239199995 33.58749299600004, -112.11570173599995 33.58748863000005, -112.11570029299997 33.58746852200005, -112.11578151499998 33.587464554000064, -112.11577959099998 33.587437743000066, -112.11586893499998 33.587433377000025, -112.11587133799998 33.587466892000066, -112.11596068199998 33.587462526000024, -112.11596933799996 33.587583177000056, -112.115993705 33.58758198600003, -112.11600284099995 33.58770934100005, -112.11595410799998 33.58771172200005, -112.11596276299997 33.587832373000026, -112.11574346499998 33.58784308700007, -112.11574827299995 33.587910116000046, -112.11565892899995 33.58791448100004))",
    "TopCategory": "Personal Care Services",
    "SubCategory": "Diet and Weight Reducing Centers",
    "LocationName": "Eileen McMahon MS RDN LDN"
}';

EXEC FindPOIs @SearchCriteria = @Criteria;
```

#### Example 2: Find All Objects in a 200-Meter Radius (Current Location)
```sql
DECLARE @Criteria NVARCHAR(MAX);
SET @Criteria = '{
    "CountryCode": null,
    "RegionCode": null,
    "CityID": null,
    "Latitude": null,
    "Longitude": null,
    "Radius": null,
    "WKTPolygon": null,
    "TopCategory": null,
    "SubCategory": null,
    "LocationName": null
}';

EXEC FindPOIs @SearchCriteria = @Criteria;
```

#### Example 3: Find All Objects in a 200-Meter Radius (Specific Location)
```sql
DECLARE @Criteria NVARCHAR(MAX);
SET @Criteria = '{
    "CountryCode": null,
    "RegionCode": null,
    "CityID": null,
    "Latitude": 41.610450,
    "Longitude": -87.631808,
    "Radius": 200,
    "WKTPolygon": null,
    "TopCategory": null,
    "SubCategory": null,
    "LocationName": null
}';

EXEC FindPOIs @SearchCriteria = @Criteria;
```

#### Example 4: Find All Objects in a Given Polygon
```sql
DECLARE @Criteria NVARCHAR(MAX);
SET @Criteria = '{
    "CountryCode": null,
    "RegionCode": null,
    "CityID": null,
    "Latitude": null,
    "Longitude": null,
    "Radius": null,
    "WKTPolygon": "POLYGON ((-112.11565892899995 33.58791448100004, -112.11564258099997 33.58768658400004, -112.11562633599999 33.587687378000055, -112.11561239199995 33.58749299600004, -112.11570173599995 33.58748863000005, -112.11570029299997 33.58746852200005, -112.11578151499998 33.587464554000064, -112.11577959099998 33.587437743000066, -112.11586893499998 33.587433377000025, -112.11587133799998 33.587466892000066, -112.11596068199998 33.587462526000024, -112.11596933799996 33.587583177000056, -112.115993705 33.58758198600003, -112.11600284099995 33.58770934100005, -112.11595410799998 33.58771172200005, -112.11596276299997 33.587832373000026, -112.11574346499998 33.58784308700007, -112.11574827299995 33.587910116000046, -112.11565892899995 33.58791448100004))",
    "TopCategory": null,
    "SubCategory": null,
    "LocationName": null
}';

EXEC FindPOIs @SearchCriteria = @Criteria;
```

#### Example 5: Find All Grocery Stores in a Given Polygon
```sql
DECLARE @Criteria NVARCHAR(MAX);
SET @Criteria = '{
    "CountryCode": null,
    "RegionCode": null,
    "CityID": null,
    "Latitude": null,
    "Longitude": null,
    "Radius": null,
    "WKTPolygon": "POLYGON ((-112.11565892899995 33.58791448100004, -112.11564258099997 33.58768658400004, -112.11562633599999 33.587687378000055, -112.11561239199995 33.58749299600004, -112.11570173599995 33.58748863000005, -112.11570029299997 33.58746852200005, -112.11578151499998 33.587464554000064, -112.11577959099998 33.587437743000066, -112.11586893499998 33.587433377000025, -112.11587133799998 33.587466892000066, -112.11596068199998 33.587462526000024, -112.11596933799996 33.587583177000056, -112.115993705 33.58758198600003, -112.11600284099995 33.58770934100005, -112.11595410799998 33.58771172200005, -112.11596276299997 33.587832373000026, -112.11574346499998 33.58784308700007, -112.11574827299995 33.587910116000046, -112.11565892899995 33.58791448100004))",
    "TopCategory": "Grocery Stores",
    "SubCategory": null,
    "LocationName": null
}';

EXEC FindPOIs @SearchCriteria = @Criteria;
```

---

### 6. Generate GeoJSON
Execute the **`CreateGeojson.sql`** script to generate the GeoJSON.

---

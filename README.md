MyWorkplace

NOTES:
Clarification on MS SQL Server Version 15 Compatibility:
There is no such version as "MS SQL Server version 15" unless it refers to build 15.X.XXXX.X, which corresponds to SQL Server 2019.

Data Quality Issues:

Mismatch between id and parent_id:
There are 63 rows where the parent_id value does not exist in the id column. This inconsistency affects the database architecture.

Insertion Issues:
Even after excluding these 63 rows, I am unable to insert data into the table due to the presence of special characters that prevent the operation.

Categorization in phoenix.csv:
The columns defining categories and subcategories in the phoenix.csv file could be separated into dedicated tables. However, this would require significant data refinement.

Invalid Polygons:
Some polygons are invalid. I identified them using the following query:


SELECT * FROM pois
WHERE WKTPolygon.STIsValid() = 0;
I corrected the data using the following script:


UPDATE pois
SET WKTPolygon = WKTPolygon.MakeValid()
WHERE WKTPolygon.STIsValid() = 0;


INSTRUCTIONS:
Download Files:
Download the files from the following location:
https://github.com/vladimir-antovic/MyWorkplace

CityGuideDB.full.bak: This is the database backup file.

README.txt: This file contains notes and instructions.

CreateGeojson.sql: This script generates GeoJSON.

Restore the Database:
Restore the database (named CityGuideDB) using the following script:

USE [master]
RESTORE DATABASE [CityGuideDB] FROM  DISK = N'D:\billups project\CityGuideDB.full.bak' WITH  FILE = 1,  
MOVE N'CityGuideDB' TO N'C:\your\path\CityGuide.mdf',  
MOVE N'CityGuide_data' TO N'C:\your\path\CityGuide_data.ndf',  
MOVE N'CityGuideDB_log' TO N'C:\your\path\CityGuide_log.ldf',  
NOUNLOAD,  STATS = 5
GO

Database Diagram:
After restoring the database, you can view the table structures in the database diagram named Diagram_0.

Stored Procedure:
The stored procedure dbo.FindPOIs can be found under Programmability > Stored Procedures.

Execute the Stored Procedure:
Run the following scripts to execute the stored procedure (modify the JSON parameter values as needed):

--all criteria are filled
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

go

-- find all objects in 200 meters radius, current location
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

go

--find all objects in 200 meters radius. specific location
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

go

--find all objects in given polygon
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

go

--find all Grocery Stores in given polygon
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



Generate GeoJSON:
Execute the CreateGeojson.sql script to generate the GeoJSON.
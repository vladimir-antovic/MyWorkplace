# MyWorkplace

-- potrebno mi je da razjasnimo šta je (MS SQL Server version 15 compatible)
takva verzija sql servera ne postoji osim ako se misli na build 15.X.XXXX.X 
a to je verzija SQL Server 2019

upitan je kvalitet podataka

1. id i parent_id se ne slažu. ima 63 reda gde ono što je u parent_id ne postoji u id
2. čak i kada isključim ta  63 reda ne mogu da insertujem u tabelu. postoji neki spec karakter koji to ne dozvoljava
3. nisam siguran, ali treba i proveriti da li se slažu latitude i longitude sa poligonom (procedura ne radi baš kako treba). ja nemam dovoljno iskustva sa ovim, možda mi je potreban samo neki hint
4. takodje ima nevalidnih poligona 
   select* from pois
   WHERE WKTPolygon.STIsValid() = 0;

Instructions:

1. download files from https://github.com/vladimir-antovic/MyWorkplace
   CityGuideDB.full.bak  --this is the backup file of the database
   README.txt            --this is the  file with instructions

2. restore the database (database name is CityGuideDB)
   restore script is the following

	USE [master]
	RESTORE DATABASE [CityGuideDB] FROM  DISK = N'D:\billups project\CityGuideDB.full.bak' WITH  FILE = 1,  
	MOVE N'CityGuideDB' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CityGuide.mdf',  
	MOVE N'CityGuide_data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CityGuide_data.ndf',  
	MOVE N'CityGuideDB_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CityGuide_log.ldf',  
	NOUNLOAD,  STATS = 5

	GO

3. you can see the table structures in database diagram (after restoring database you will find the diagram in Database Diagrams. Name is Diagram_0

4. you can find stored procedure dbo.FindPOIs in Programability > Stored procedures

5. you can execute stored procedure running the script (change the value of parameter in json if you need)

	DECLARE @Criteria NVARCHAR(MAX);
	SET @Criteria = '{
	    "CountryCode": "US",
	    "RegionCode": "MD",
	    "CityID": 1,
	    "Latitude": 39.467884,
	    "Longitude": -76.576101,
	    "Radius": 200,
	    "WKTPolygon": null,
	    "TopCategory": "Personal Care Services",
	    "SubCategory": "Diet and Weight Reducing Centers",
	    "LocationName": "Eileen McMahon MS RDN LDN"
	}';

	EXEC FindPOIs @SearchCriteria = @Criteria;



6. you can get the GeoJSON by executing following script
   CreateGeojson.sql
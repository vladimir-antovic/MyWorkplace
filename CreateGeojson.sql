USE [CityGuideDB]

drop table if exists #t
CREATE TABLE #t(
	[Id] [varchar](50) NOT NULL,
	[ParentID] [varchar](50) NULL,
	[CountryCode] [varchar](3) NULL,
	[RegionCode] [varchar](50) NULL,
	[CityName] [varchar](500) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Category] [varchar](500) NULL,
	[SubCategory] [varchar](500) NULL,
	[WKTPolygon] [geography] NULL,
	[LocationName] [varchar](255) NULL,
	[PostalCode] [varchar](20) NULL,
	[OperationHours] [varchar](1000) NULL)


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

insert into #t
EXEC FindPOIs @SearchCriteria = @Criteria;


SELECT 
    'Feature' AS type,
    JSON_QUERY((
        SELECT 
            Id,
            ParentId,
            CountryCode,
            RegionCode,
            CityName,
            Latitude,
            Longitude,
            Category,
            SubCategory,
            WKTPolygon.ToString() AS WKTPolygon,
            LocationName,
            PostalCode,
            OperationHours
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )) AS properties,
    JSON_QUERY((
        SELECT 
            'Point' AS type,
            JSON_QUERY(CONCAT('[', Longitude, ',', Latitude, ']')) AS coordinates
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )) AS geometry
FROM 
    #t
FOR JSON PATH;
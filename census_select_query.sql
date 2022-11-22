USE [census_demo]
GO
 
SELECT [CENSUS_YEAR]
      ,[GEO_CODE (POR)]
      ,[GEO_LEVEL]
      ,[GEO_NAME]
      ,[GNR]
      ,[GNR_LF]
      ,[DATA_QUALITY_FLAG]
      ,[ALT_GEO_CODE]
      ,[DIM  Profile of Dissemination Areas (2247)]
      ,[Member ID  Profile of Dissemination Areas (2247)]
      ,[Notes  Profile of Dissemination Areas (2247)]
      ,[Dim  Sex (3)  Member ID   1   Total - Sex]
      ,[Dim  Sex (3)  Member ID   2   Male]
      ,[Dim  Sex (3)  Member ID   3   Female]
  FROM [dbo].[census_raw]

GO



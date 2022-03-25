CREATE VIEW [dbo].[View_ModeBrandDetails]
	AS
SELECT        t1.SubProductID, t1.BrandID, t2.BrandName, t1.ModelNo
FROM            dbo.tblProductWiseModelNo AS t1 INNER JOIN
                         dbo.BrandMaster AS t2 ON t1.BrandID = t2.BrandID

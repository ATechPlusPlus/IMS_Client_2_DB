CREATE VIEW [dbo].[View_SalesDetails]
	AS 
    SELECT        s1.InvoiceID, p1.ProductName, s1.QTY, s1.Rate, sm.Size, c1.ColorName
FROM            dbo.SalesDetails AS s1 INNER JOIN
                         dbo.ProductMaster AS p1 ON s1.ProductID = p1.ProductID INNER JOIN
                         dbo.SizeMaster AS sm ON sm.SizeID = s1.SizeID INNER JOIN
                         dbo.ColorMaster AS c1 ON c1.ColorID = s1.ColorID

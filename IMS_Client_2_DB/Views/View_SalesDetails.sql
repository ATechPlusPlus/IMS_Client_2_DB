CREATE VIEW [dbo].[View_SalesDetails]
	AS 
      
     SELECT  s1.InvoiceID, p1.ProductID, ps.BarcodeNo, p1.ProductName, s1.QTY, s1.Rate, sm.Size
     , c1.ColorName, p1.CategoryID, s1.SubProductID, pwm.ModelNo
     FROM dbo.SalesDetails AS s1 
     INNER JOIN dbo.ProductMaster AS p1 ON s1.ProductID = p1.ProductID
     INNER JOIN dbo.SizeMaster AS sm ON sm.SizeID = s1.SizeID 
     INNER JOIN dbo.ColorMaster AS c1 ON c1.ColorID = s1.ColorID 
     INNER JOIN dbo.ProductStockColorSizeMaster AS ps ON s1.SubProductID = ps.SubProductID AND s1.ProductID = ps.ProductID 
     AND s1.ColorID = ps.ColorID AND s1.SizeID = ps.SizeID 
     AND ps.StoreID=(SELECT shopeid FROM SalesInvoiceDetails WHERE id=s1.InvoiceID)
     INNER JOIN dbo.tblProductWiseModelNo AS pwm ON s1.SubProductID = pwm.SubProductID
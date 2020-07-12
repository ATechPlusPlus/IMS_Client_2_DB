CREATE PROCEDURE [dbo].[sp_GetReplaceReturnDetails]
	@InvoiceID int = 0,
	@BarCode nvarchar(50)
AS
	
	
select * from (select InvoiceID, ProductID,
(select ProductName from ProductMaster where ProductID=s1.ProductID) as ProductName,
QTY,Rate,ColorID,
(select ColorName from ColorMaster where ColorID=s1.ColorID) as Color,
(select Size from SizeMaster where SizeID=s1.SizeID) as Size,SizeID,
(select BarcodeNo from ProductStockMaster where ColorID=s1.ColorID and 
SizeID=s1.SizeID and ProductID=s1.ProductID ) as BarCode from SalesDetails s1
 where InvoiceID=@InvoiceID) as tb where BarCode=@BarCode


RETURN 0

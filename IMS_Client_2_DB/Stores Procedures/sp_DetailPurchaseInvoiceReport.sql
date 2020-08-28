-- =============================================
-- Author:		<MATEEN KHAN>
-- Create date: <5th JULY 2020>
-- Update date:	<27th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC sp_DetailPurchaseInvoiceReport '0006'
CREATE PROCEDURE [dbo].[sp_DetailPurchaseInvoiceReport]
@BillNo as NVARCHAR(50)

AS
BEGIN
	
	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@BillNo

	SELECT PurchaseInvoiceID,SupplierBillNo,ShipmentNo,
	(SELECT DISTINCT SupplierName FROM SupplierMaster WHERE SupplierID=p1.SupplierID) AS Supplier,
	BillDate,(CASE p1.IsInvoiceDone WHEN 1 THEN 'Posted' WHEN 0 THEN 'Not Posted' END)IsInvoiceDone,TotalQTY,BillValue,Discount,ForeignExp,GrandTotal,LocalValue,LocalExp
	FROM [dbo].[PurchaseInvoice] AS p1 WHERE p1.PurchaseInvoiceID=@BillNo
	
	
	SELECT PurchaseInvoiceID, 
	(SELECT DISTINCT  item.ProductName FROM ProductMaster AS item WHERE item.ProductID=p1.ProductID) AS [Item Name],ModelNo [StyleNo],
	(SELECT DISTINCT BrandName FROM BrandMaster AS b WHERE b.BrandID=p1.BrandID) AS Brand,
	QTY,Rate,Sales_Price [EndUser Price],AddedRatio,SuppossedPrice
	FROM [dbo].[PurchaseInvoiceDetails] AS p1 WHERE  p1.PurchaseInvoiceID=@BillNo
	
	
	SELECT PurchaseInvoiceID,
	(SELECT DISTINCT item.ProductName FROM ProductMaster as item WHERE item.ProductID=p1.ProductID) AS [Item Name],ModelNo [StyleNo],
	(SELECT DISTINCT StoreName FROM StoreMaster AS S1 WHERE S1.StoreID=p1.StoreID) AS StoreName,
	BarcodeNo, 
	(SELECT DISTINCT ColorName FROM ColorMaster WHERE ColorID=p1.ColorID) AS Color,
	(SELECT DISTINCT Size FROM SizeMaster WHERE SizeID=p1.SizeID) AS Size,
	QTY, Rate
	FROM [dbo].[ProductStockMaster] AS p1 
	WHERE p1.PurchaseInvoiceID=@BillNo
	AND p1.QTY > 0

	END TRY
	
	BEGIN CATCH
	INSERT [dbo].[ERROR_Log]
	(
	ERR_NUMBER
	, ERR_SEVERITY
	, ERR_STATE
	, ERR_LINE
	, ERR_MESSAGE
	, ERR_PROCEDURE
	, PARAMERES
	)
	SELECT  
	ERROR_NUMBER() 
	,ERROR_SEVERITY() 
	,ERROR_STATE() 
	,ERROR_LINE()
	,ERROR_MESSAGE()
	,ERROR_PROCEDURE()
	,@PARAMERES

	END CATCH

END
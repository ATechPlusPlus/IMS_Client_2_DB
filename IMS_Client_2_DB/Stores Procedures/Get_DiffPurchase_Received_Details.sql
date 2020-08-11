-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <12th MARCH 2020>
-- Update date: <12th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_DiffPurchase_Received_Details 1
CREATE PROCEDURE [dbo].[Get_DiffPurchase_Received_Details]
@PurchaseInvoiceID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET NOCOUNT ON;
	
	SET @PARAMERES=@PurchaseInvoiceID

	SELECT p2.SubProductID,p2.ProductID,p1.SupplierBillNo,p1.BillDate,p1.SupplierID, sm.CountryID, pm.ProductName [ItemName],pwm.Photo,cm.CategoryName
	, p2.ModelNo [Style No],p2.Sales_Price [Sales Price],CAST((p1.LocalBillValue/p1.BillValue) AS DECIMAL(18,3)) AS [New Rate]
	,p2.Rate AS [Cost Price] ,p2.QTY AS [Bill QTY],TotalQTY
	,CAST((p1.LocalBillValue/p1.TotalQTY) AS DECIMAL(18,3)) AS [Local Cost]
	,SUM(pd3.Total) AS [Receive QTY],(SUM(pd3.Total)-p2.QTY) AS [Diff QTY]
	,(SUM(pd3.Total)-p2.QTY) * CAST((p1.LocalBillValue/p1.TotalQTY) AS	DECIMAL(18,3)) AS [Diff Value]
	FROM [dbo].[PurchaseInvoice] p1
	INNER JOIN [dbo].[PurchaseInvoiceDetails] p2 ON p1.PurchaseInvoiceID=p2.PurchaseInvoiceID
	INNER JOIN ProductMaster pm ON p2.ProductID=pm.ProductID
	INNER JOIN [dbo].[CategoryMaster] cm ON pm.CategoryID=cm.CategoryID
	
	INNER JOIN DeliveryPurchaseBill1 pd1 ON p2.PurchaseInvoiceID=pd1.PurchaseInvoiceID AND pd1.ProductID=p2.ProductID
	AND p2.SubProductID=pd1.SubProductID

	INNER JOIN DeliveryPurchaseBill2 pd2 ON pd1.DeliveryPurchaseID1=pd2.DeliveryPurchaseID1
	INNER JOIN DeliveryPurchaseBill3 pd3 ON pd2.DeliveryPurchaseID2=pd3.DeliveryPurchaseID2
	INNER JOIN tblProductWiseModelNo pwm ON pd1.SubProductID=pwm.SubProductID AND pd1.ProductID=pwm.ProductID
	INNER JOIN SupplierMaster sm ON p1.SupplierID=sm.SupplierID
	WHERE p1.PurchaseInvoiceID=@PurchaseInvoiceID
	GROUP BY p2.SubProductID,p2.ProductID,pm.ProductName,pwm.Photo,p2.ModelNo, pd1.ModelNo
	,p2.Sales_Price ,p2.Rate,p2.QTY,cm.CategoryName,p1.LocalBillValue,p1.TotalQTY
	,p1.SupplierBillNo,p1.SupplierID,sm.CountryID,p1.BillValue,p1.BillDate

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
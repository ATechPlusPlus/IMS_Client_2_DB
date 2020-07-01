-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <03 MARCH 2020>
-- Modify date: <08 MARCH 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_Posting_Delivery_QTY 1
CREATE PROCEDURE [dbo].[Get_Posting_Delivery_QTY]
@PurchaseInvoiceID INT = 0

AS
BEGIN
--DECLARE @SupplierID INT=0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@PurchaseInvoiceID

	SELECT pd1.StoreID
	,SUM(pd3.Total) Total
	FROM DeliveryPurchaseBill1 pd1
	INNER JOIN DeliveryPurchaseBill2 pd2 ON pd2.DeliveryPurchaseID1=pd1.DeliveryPurchaseID1
	INNER JOIN DeliveryPurchaseBill3 pd3 ON pd2.DeliveryPurchaseID2=pd3.DeliveryPurchaseID2
	INNER JOIN ColorMaster clr ON pd3.ColorID=clr.ColorID
	WHERE 
	pd1.PurchaseInvoiceID = @PurchaseInvoiceID
	GROUP BY pd1.StoreID

	--SELECT pd1.ProductID,pd1.StoreID,SUM(pd3.Total) Total
	--FROM DeliveryPurchaseBill1 pd1
	--INNER JOIN DeliveryPurchaseBill2 pd2 ON pd2.DeliveryPurchaseID1=pd1.DeliveryPurchaseID1
	--INNER JOIN DeliveryPurchaseBill3 pd3 ON pd2.DeliveryPurchaseID2=pd3.DeliveryPurchaseID2
	--INNER JOIN ColorMaster clr ON pd3.ColorID=clr.ColorID
	--WHERE 
	--pd1.PurchaseInvoiceID = @PurchaseInvoiceID
	--GROUP BY pd1.ProductID,pd1.StoreID

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
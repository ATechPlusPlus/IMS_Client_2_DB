-- =============================================
-- Author:		<AAMIR>
-- Create date: <02nd March 2020>
-- Update date: <18th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Delete_PurchaseInvoice_Color_Size 2
CREATE PROCEDURE [dbo].[Delete_PurchaseInvoice_Color_Size]
@DeliveryPurchaseID INT =0
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES = @DeliveryPurchaseID
	
	DECLARE @ColorID AS INT=0
	DECLARE @DeliveryPurchaseID1 AS INT=0
	DECLARE @PurchaseInvoiceID AS INT=0
	DECLARE @ProductID AS INT=0
	DECLARE @SubProductID AS INT=0
	DECLARE @StoreID AS INT=0

	BEGIN TRANSACTION

	SELECT @DeliveryPurchaseID1=DeliveryPurchaseID1, @ColorID=ColorID
	FROM DeliveryPurchaseBill3 WITH(NOLOCK) WHERE DeliveryPurchaseID3=@DeliveryPurchaseID

	SELECT @PurchaseInvoiceID=PurchaseInvoiceID, @ProductID=ProductID, @SubProductID=SubProductID
	, @StoreID=StoreID
	FROM DeliveryPurchaseBill1 WITH(NOLOCK) WHERE DeliveryPurchaseID1=@DeliveryPurchaseID1

	UPDATE ProductStockMaster SET
	QTY=0, PrintCount=0
	WHERE PurchaseInvoiceID=@PurchaseInvoiceID
	AND ProductID=@ProductID
	AND SubProductID=@SubProductID
	AND StoreID=@StoreID
	AND ColorID=@ColorID

	DELETE FROM DeliveryPurchaseBill3 WHERE DeliveryPurchaseID3=@DeliveryPurchaseID

	--DELETE FROM DeliveryPurchaseBill3 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	--DELETE FROM DeliveryPurchaseBill2 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	--DELETE FROM DeliveryPurchaseBill1 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	
	SELECT 1 -- means its deleted
	
	COMMIT
	END TRY

	BEGIN CATCH
    ROLLBACK
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
-- =============================================
-- Author:		<AAMIR>
-- Create date: <6th July 2020>
-- Update date: <>
-- Description:	<Deleting Purchase invoice from refrence tables entry>
-- =============================================
-- EXEC SPR_Delete_PurchaseInvoice 2
CREATE PROCEDURE SPR_Delete_PurchaseInvoice
@PurchaseInvoiceID INT =0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @PARAMERES VARCHAR(MAX)=''
		DECLARE @DeliveryPurchaseID INT=0
		BEGIN TRANSACTION
	SET @PARAMERES = @PurchaseInvoiceID;

	SELECT @DeliveryPurchaseID=ISNULL(pid1.DeliveryPurchaseID1,0)
	FROM PurchaseInvoice [pi]
	LEFT OUTER JOIN DeliveryPurchaseBill1 pid1 ON [pi].PurchaseInvoiceID=pid1.PurchaseInvoiceID
	WHERE [pi].PurchaseInvoiceID=@PurchaseInvoiceID

	DELETE FROM DeliveryPurchaseBill3 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	DELETE FROM DeliveryPurchaseBill2 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	DELETE FROM DeliveryPurchaseBill1 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	
	DELETE FROM PurchaseInvoiceDetails WHERE PurchaseInvoiceID=@PurchaseInvoiceID
	DELETE FROM PurchaseInvoice WHERE PurchaseInvoiceID=@PurchaseInvoiceID
	
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
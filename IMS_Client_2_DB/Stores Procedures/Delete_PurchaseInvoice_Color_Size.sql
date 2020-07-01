-- =============================================
-- Author:		<AAMIR>
-- Create date: <02 March 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Delete_PurchaseInvoice_Color_Size 1
CREATE PROCEDURE [dbo].[Delete_PurchaseInvoice_Color_Size]
@DeliveryPurchaseID INT =0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @PARAMERES VARCHAR(MAX)=''
		BEGIN TRANSACTION
	SET @PARAMERES = @DeliveryPurchaseID;

	DELETE FROM DeliveryPurchaseBill3 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	DELETE FROM DeliveryPurchaseBill2 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	DELETE FROM DeliveryPurchaseBill1 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID
	
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
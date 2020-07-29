-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <29th JULY 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Delete_Delivering_PurchaseBill 2
CREATE PROCEDURE SPR_Delete_Delivering_PurchaseBill
@PurchaseInvoiceID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @DeliveryPurchaseID1 INT=0

	BEGIN TRANSACTION
	SET @PARAMERES = @PurchaseInvoiceID;
	
	IF @PurchaseInvoiceID > 0
	BEGIN

		DECLARE ColorSize_CURSOR CURSOR 
		FOR
	
		SELECT DeliveryPurchaseID1
		FROM dbo.DeliveryPurchaseBill1 WITH(NOLOCK)
		WHERE PurchaseInvoiceID=@PurchaseInvoiceID

		OPEN ColorSize_CURSOR 
		
		FETCH NEXT FROM ColorSize_CURSOR INTO @DeliveryPurchaseID1
		
		WHILE @@FETCH_STATUS <> -1
		BEGIN

			DELETE FROM DeliveryPurchaseBill2 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID1
			DELETE FROM DeliveryPurchaseBill3 WHERE DeliveryPurchaseID1=@DeliveryPurchaseID1

			FETCH NEXT FROM ColorSize_CURSOR INTO @DeliveryPurchaseID1
		END

		CLOSE ColorSize_CURSOR;
		DEALLOCATE ColorSize_CURSOR;

		DELETE FROM DeliveryPurchaseBill1 WHERE PurchaseInvoiceID=@PurchaseInvoiceID
	END

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
-- =============================================
-- Author:		<AAMIR>
-- Create date: <03 MARCH 2020>
-- Update date: <03 SEPT 2020>
-- Description:	<NOT USED>
-- =============================================
--EXEC Insert_Posting_Delivery 1,1,1,1,'PURINV01',1 --NOT USED
CREATE PROCEDURE [dbo].[Insert_Posting_Delivery]
@ProductID INT=0
,@StoreID INT=0
,@QTY INT=0
,@EntryType INT=0
,@SupplierBillNo VARCHAR(50)
,@CreatedBy INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	BEGIN TRANSACTION
	SET @PARAMERES=CONCAT(@ProductID,',',@StoreID,',',@QTY,',',@EntryType,',',@SupplierBillNo,',',@CreatedBy)

	INSERT INTO [dbo].[PostingDeliveryEntry]
	(
	EntryType, SupplierBillNo, StoreID, PostingStatus, TotalQTY, CreatedBy
	)
	VALUES
	(
	@EntryType, @SupplierBillNo, @StoreID, 1, @QTY, @CreatedBy
	)

	IF EXISTS(SELECT 1 FROM ProductStockMaster WITH(NOLOCK) WHERE ProductID = @ProductID AND StoreID=@StoreID)
	BEGIN
	
		UPDATE ProductStockMaster
		SET QTY = QTY + @QTY
		,UpdatedBy = @CreatedBy
		,UpdatedOn = getdate()
		WHERE 
		ProductID = @ProductID 
		AND StoreID=@StoreID

		SELECT 1

	END

	ELSE
	BEGIN

		INSERT INTO ProductStockMaster
		(
			ProductID, QTY, StoreID, CreatedBy
		)
		VALUES
		(
			@ProductID, @QTY, @StoreID, @CreatedBy
		)

		SELECT 1

	END

	UPDATE PurchaseInvoice SET IsInvoiceDone = 1
	WHERE SupplierBillNo = @SupplierBillNo

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
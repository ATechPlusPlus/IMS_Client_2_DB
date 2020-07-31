-- =============================================
-- Author:		<Author,,Name>
-- Create date: <24th JULY 2020>
-- Update date: <31th JULY 2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPR_Insert_StoreTransferItemDetails_Voilet]
@TransferItemID			INT=0
,@StoreBillDetailsID	INT=0
,@ProductID				INT=0
,@SubProductID			INT=0
,@ModelNo				NVARCHAR(MAX)=''
,@Barcode				NVARCHAR(MAX)=''
,@Rate					DECIMAL(18,3)=0
,@BillQTY				INT=0
,@EnterQTY				INT=0
,@ColorID				INT=0
,@SizeID				INT=0
,@Total					DECIMAL(18,3)=0
,@StoreID				INT=0
,@CreatedBy				INT=0
,@CellColor				VARCHAR(MAX)=''
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@TransferItemID,',',@StoreBillDetailsID,',',@ProductID,',',@SubProductID,',',@Barcode,',',@Rate,',',@BillQTY
	,',',@EnterQTY,',',@ColorID,',',@SizeID,',',@Total,',',@StoreID,',',@CreatedBy,',',@CellColor)

	BEGIN TRANSACTION

	IF @CellColor='Violet'
	
	BEGIN
	
	DELETE FROM tblStoreTransferItemDetails_Voilet
	WHERE StoreID=@StoreID

	INSERT tblStoreTransferItemDetails_Voilet
	(
	TransferItemID
	,StoreBillDetailsID
	,ProductID
	,SubProductID
	,ModelNo
	,Barcode
	,Rate
	,BillQTY
	,EnterQTY
	,ColorID
	,SizeID
	,Total
	,StoreID
	,CreatedBy
	)
	VALUES
	(
	 @TransferItemID
	,@StoreBillDetailsID
	,@ProductID
	,@SubProductID
	,@ModelNo
	,@Barcode
	,@Rate
	,@BillQTY
	,@EnterQTY
	,@ColorID
	,@SizeID
	,@Total
	,@StoreID
	,@CreatedBy
	)
	END

	ELSE
	
	BEGIN

	UPDATE tblStoreTransferItemDetails
	SET EnterQTY = @EnterQTY
	,UpdatedBy=@CreatedBy
	,UpdatedOn=GETDATE()
	WHERE TransferItemID=@TransferItemID

	END
	
	SELECT 1 -- means its Saved
	
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
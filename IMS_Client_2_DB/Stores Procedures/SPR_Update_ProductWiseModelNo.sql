-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <29th JULY 2020>
-- Update date: <15th AUGUST 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Update_ProductWiseModelNo 
CREATE PROCEDURE [dbo].[SPR_Update_ProductWiseModelNo]
@ProductID INT=0
,@ModelNo NVARCHAR(MAX)=0
,@BrandID INT=0
,@StoreID INT=0
,@EndUser DECIMAL(18,3)=0
,@CreatedBy INT=0
,@SubProductID INT=0
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @PARAMERES VARCHAR(MAX)=''
	
	BEGIN TRANSACTION

	SET @PARAMERES=CONCAT(@ProductID,',',@ModelNo,',',@BrandID,',',@StoreID,',',@EndUser,',',@CreatedBy,',',@SubProductID)
	
	UPDATE tblProductWiseModelNo SET 
	 EndUser=@EndUser
	,ModelNo=@ModelNo
	,UpdatedBy=@CreatedBy
	,UpdatedOn=GETDATE()
	WHERE SubProductID=@SubProductID
	AND ProductID=@ProductID
	--AND StoreID=@StoreID

	IF EXISTS(SELECT 1 FROM DeliveryPurchaseBill1 WITH(NOLOCK) WHERE SubProductID=@SubProductID 
	AND ProductID=@ProductID AND StoreID=@StoreID)
	BEGIN

		UPDATE DeliveryPurchaseBill1 SET ModelNo=@ModelNo
		WHERE SubProductID=@SubProductID 
		AND ProductID=@ProductID AND StoreID=@StoreID

	END

	IF EXISTS(SELECT 1 FROM ProductStockMaster WITH(NOLOCK) WHERE SubProductID=@SubProductID 
	AND ProductID=@ProductID AND StoreID=@StoreID)
	BEGIN

		UPDATE ProductStockMaster SET ModelNo=@ModelNo
		WHERE SubProductID=@SubProductID 
		AND ProductID=@ProductID AND StoreID=@StoreID

	END

	IF EXISTS(SELECT 1 FROM tblStoreTransferItemDetails_Voilet WITH(NOLOCK) WHERE SubProductID=@SubProductID 
	AND ProductID=@ProductID AND StoreID=@StoreID)
	BEGIN

		UPDATE tblStoreTransferItemDetails_Voilet SET ModelNo=@ModelNo
		WHERE SubProductID=@SubProductID 
		AND ProductID=@ProductID AND StoreID=@StoreID

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
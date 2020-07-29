-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <28th JULY 2020>
-- Update date: <29th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Insert_ProductWiseModelNo
CREATE PROCEDURE [dbo].[SPR_Insert_ProductWiseModelNo]
@ProductID INT=0
,@ModelNo NVARCHAR(MAX)=0
,@BrandID INT=0
,@StoreID INT=0
,@EndUser DECIMAL(18,3)=0
,@CreatedBy INT=0
,@SubProductID INT=0 OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @PARAMERES VARCHAR(MAX)=''

	SET @PARAMERES=CONCAT(@ProductID,',',@ModelNo,',',@BrandID,',',@StoreID,',',@EndUser,',',@CreatedBy,',',@SubProductID)
	
	BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM tblProductWiseModelNo WITH(NOLOCK) WHERE ModelNo=@ModelNo AND BrandID=@BrandID AND ProductID=@ProductID AND StoreID=@StoreID)
		BEGIN

		INSERT tblProductWiseModelNo
		(
		ProductID
		,ModelNo
		,BrandID
		,StoreID
		,EndUser
		,CreatedBy
		)
		VALUES
		(
		 @ProductID
		,@ModelNo
		,@BrandID
		,@StoreID
		,@EndUser
		,@CreatedBy
		)

		SELECT @SubProductID=SCOPE_IDENTITY()

		END

		ELSE
		BEGIN

		SELECT @SubProductID=0

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <29th JULY 2020>
-- Update date: <02nd AUGUST 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_IsModelBrandExists
CREATE PROCEDURE [dbo].[SPR_IsModelBrandExists]
@ProductID INT=0
,@ModelNo NVARCHAR(MAX)=0
,@BrandID INT=0
,@StoreID INT=0
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @IsAdd BIT=0
	DECLARE @SubProductID INT=0
	DECLARE @EndUser DECIMAL(18,3)=0
	DECLARE @ProductName VARCHAR(MAX)=''
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@ProductID,',',@ModelNo,',',@BrandID,',',@StoreID)
	
	IF EXISTS(SELECT 1 FROM tblProductWiseModelNo WITH(NOLOCK) WHERE ModelNo=@ModelNo AND BrandID=@BrandID --AND StoreID=@StoreID
	)
	BEGIN

		IF EXISTS(SELECT 1 FROM tblProductWiseModelNo WITH(NOLOCK) WHERE ModelNo=@ModelNo AND BrandID=@BrandID AND ProductID=@ProductID --AND StoreID=@StoreID
		)
		BEGIN

		SET @IsAdd=1
		
		SELECT @SubProductID=SubProductID,@EndUser=EndUser
		FROM tblProductWiseModelNo WITH(NOLOCK) WHERE ModelNo=@ModelNo 
		AND BrandID=@BrandID 
		AND ProductID=@ProductID
		--AND StoreID=@StoreID
		
		SELECT @IsAdd [IsAdd], @SubProductID [SubProductID],@EndUser [EndUser]

		END

		ELSE
		BEGIN

		SET @IsAdd=0
		
		SELECT @ProductID=ProductID
		FROM tblProductWiseModelNo WITH(NOLOCK) WHERE ModelNo=@ModelNo 
		AND BrandID=@BrandID 
		--AND StoreID=@StoreID

		SELECT @ProductName=ProductName FROM ProductMaster WITH(NOLOCK) WHERE ProductID=@ProductID
		SELECT @IsAdd [IsAdd],'ModelNo. '+@ModelNo+' is already exists for Item '+@ProductName [Msg]

		END

	END
	
	ELSE
	BEGIN

	SET @IsAdd=1 --first time insert
	SELECT @IsAdd [IsAdd],@SubProductID [SubProductID],0 [EndUser]

	END

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
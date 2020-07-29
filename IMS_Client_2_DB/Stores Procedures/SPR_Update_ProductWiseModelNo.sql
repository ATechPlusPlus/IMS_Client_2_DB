-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <29th JULY 2020>
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
	
	UPDATE tblProductWiseModelNo SET EndUser=@EndUser
	,UpdatedBy=@CreatedBy
	,UpdatedOn=GETDATE()
	WHERE SubProductID=@SubProductID
	AND ProductID=@ProductID
	AND StoreID=@StoreID

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
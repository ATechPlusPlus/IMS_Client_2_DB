-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <29th AUGUST 2020>
-- Description:	<>
-- =============================================
-- EXEC SPR_Update_EndUser_Price 1,'9.500',2
CREATE PROCEDURE SPR_Update_EndUser_Price
@SubProductID INT=0
,@ProductID INT=0
,@EndUser DECIMAL(18,3)=0
,@UpdatedBy INT=0

AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE @PARAMERES VARCHAR(MAX)=''
		SET @PARAMERES=CONCAT(@SubProductID,',',@ProductID,',',@EndUser,',',@UpdatedBy)

	BEGIN TRANSACTION
	
		UPDATE tblProductWiseModelNo SET 
		EndUser=@EndUser
		,UpdatedBy=@UpdatedBy
		,UpdatedOn=GETDATE()
		WHERE SubProductID=@SubProductID

		UPDATE ProductStockMaster SET
		Rate=@EndUser
		,UpdatedBy=@UpdatedBy
		,UpdatedOn=GETDATE()
		WHERE SubProductID=@SubProductID
		AND ProductID=@ProductID

	COMMIT
	
	SELECT 1 AS Flag,'EndUser Price is Updated..' as Msg -- Means Data saved successfully

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

		SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured

	END CATCH
END
GO
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <18th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_StoreTransfer_ListItems
CREATE PROCEDURE SPR_Get_StoreTransfer_ListItems

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @StoreID AS INT=0

	BEGIN TRY

	SELECT @StoreID=StoreID FROM DefaultStoreSetting WITH(NOLOCK) WHERE MachineName=HOST_NAME()

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
GO
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <21st JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_PettyCashAmt 1
CREATE PROCEDURE [dbo].[SPR_Get_PettyCashAmt]
@StoreID INT=0

AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@StoreID

	SELECT PettyCashExpID,Particulars,TransactionDate,PettyCashAmt 
	FROM tblPettyCashExpensesDetails WITH(NOLOCK)
	WHERE StoreID=@StoreID
	AND PettyCashAmt > 0
	AND TransactionDate = CONVERT(DATE,GETDATE())

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <21st JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Insert_PettyCashAmt
CREATE PROCEDURE [dbo].[SPR_Insert_PettyCashAmt]
@PettyCashAmt DECIMAL(18,3)=0
,@StoreID INT=0
,@CreatedBy INT=0
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@PettyCashAmt,',',@StoreID,',',@CreatedBy)

	IF @PettyCashAmt > 0
	BEGIN

	INSERT INTO tblPettyCashExpensesDetails
	(
	  MasterCashClosingID
	 ,Particulars
	 ,TransactionDate
	 ,PettyCashAmt
	 ,ExpensesAmt
	 ,StoreID
	 ,CreatedBy	
	)
	VALUES
	(
	 0
	,'Cash Received'
	,CONVERT(DATE,GETDATE())
	,@PettyCashAmt
	,0
	,@StoreID
	,@CreatedBy
	)
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
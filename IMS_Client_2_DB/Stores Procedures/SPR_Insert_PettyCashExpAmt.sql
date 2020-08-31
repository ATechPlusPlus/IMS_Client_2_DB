-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <21st JULY 2020>
-- Update date: <31st AUGUST 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Insert_PettyCashExpAmt
CREATE PROCEDURE [dbo].[SPR_Insert_PettyCashExpAmt]
@PettyCashExpAmt DECIMAL(18,3)=0
,@StoreID INT=0
,@Particulars NVARCHAR(400)='0'
,@MasterCashClosingID INT=0
,@CreatedBy INT=0
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @TransactionDate Date

	SET @PARAMERES=CONCAT(@PettyCashExpAmt,',',@StoreID,',',@Particulars,',',@MasterCashClosingID,',',@CreatedBy)
	
	BEGIN TRANSACTION

	IF @PettyCashExpAmt > 0
	BEGIN
	
	SELECT @TransactionDate=CashBoxDate FROM tblMasterCashClosing WITH(NOLOCK) 
		WHERE MasterCashClosingID=@MasterCashClosingID

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
	@MasterCashClosingID
	,@Particulars
	,CONVERT(DATE,@TransactionDate)--CONVERT(DATE,GETDATE())
	,0
	,@PettyCashExpAmt
	,@StoreID
	,@CreatedBy
	)
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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <23rd JULY 2020>
-- Update date: <23rd JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_PettyCashExpAmt '2020-07-21','2020-07-23',2
CREATE PROCEDURE [dbo].[SPR_Get_PettyCashExpAmt]
@FromDate DATE=NULL
,@ToDate DATE=NULL
,@StoreID INT=0
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@FromDate,',',@ToDate,',',@StoreID)

	SELECT cd.PettyCashExpID, cd.MasterCashClosingID, ccm.CashNo, cd.Particulars, cd.TransactionDate,
	cd.PettyCashAmt, cd.ExpensesAmt, cd.StoreID, cd.CreatedBy,usr.Name
	FROM [dbo].[tblPettyCashExpensesDetails] cd
	LEFT OUTER JOIN 
	(
		SELECT emp.Name,usr.EmployeeID,usr.UserID FROM UserManagement usr
		INNER JOIN EmployeeDetails emp ON usr.EmployeeID=emp.EmpID
	) usr ON cd.CreatedBy=usr.UserID
	LEFT OUTER JOIN tblMasterCashClosing ccm ON cd.MasterCashClosingID=ccm.MasterCashClosingID
	WHERE cd.StoreID=@StoreID
	AND cd.TransactionDate BETWEEN ISNULL(@FromDate,cd.TransactionDate) 
	AND ISNULL(@ToDate,cd.TransactionDate)

	SELECT PettyCashID, TotalPettyCashAmt, TotalPettyCashExpAmt
	, PettyCashBalance, StoreID 
	FROM [dbo].[tblTotalPettyCashExpenses] WITH(NOLOCK)
	WHERE StoreID=@StoreID

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <13th JULY 2020>
-- Update date: <25th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_CashClosing_Details 1,1,0
CREATE PROCEDURE [dbo].[SPR_Get_CashClosing_Details]
@MasterCashClosingID INT=0
,@StoreID INT=0
,@PettyCashBAL DECIMAL(18,3) OUTPUT
--,@CashCredit INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @CashStatus INT=0
	DECLARE @CashBoxDate DATE=NULL
	DECLARE @ExpensesAmt DECIMAL(18,3)
	SET @PARAMERES=CONCAT(@MasterCashClosingID,',',@StoreID)

	SET NOCOUNT ON;
	
	SELECT @PettyCashBAL=PettyCashBalance FROM tblTotalPettyCashExpenses WITH(NOLOCK) 
	WHERE StoreID=@StoreID

	SET @PettyCashBAL=ISNULL(@PettyCashBAL,0)

	IF @MasterCashClosingID > 0
	BEGIN

		SELECT @CashStatus=CashStatus,@CashBoxDate=CashBoxDate FROM tblMasterCashClosing WITH(NOLOCK) 
		WHERE MasterCashClosingID=@MasterCashClosingID

		PRINT CONCAT(@CashStatus,',',@CashBoxDate,',',@MasterCashClosingID)

		IF @CashStatus = 0
		BEGIN
		
		SELECT cb.CashBandID, cb.CashBand,CONCAT('X ', cb.CashBand) [CashBandValue]
		, cc.[Count], cc.Value, ccm.CashBoxDate, ccm.CashStatus, ccm.StoreID
		, ccm.MasterCashClosingID, ccm.CashNo, usr.EmployeeID, ISNULL(ccm.TotalCashValue,0)TotalCashValue
		, usr.Name, ISNULL(cr.Value,0) [CashReturn]
		FROM tblCloseCashBandMaster cb
		LEFT OUTER JOIN tblCashClosing cc ON cb.CashBandID=cc.CashBandID AND cc.MasterCashClosingID=@MasterCashClosingID
		LEFT OUTER JOIN tblMasterCashClosing ccm ON 
		ISNULL(cc.MasterCashClosingID,@MasterCashClosingID)=ISNULL	(ccm.MasterCashClosingID,@MasterCashClosingID)
		LEFT OUTER JOIN tblCashReturn cr ON ccm.MasterCashClosingID=cr.MasterCashClosingID
		LEFT OUTER JOIN 
		(
			SELECT emp.Name,usr.EmployeeID FROM UserManagement usr
			INNER JOIN EmployeeDetails emp ON usr.EmployeeID=emp.EmpID
		) usr ON ccm.EmployeeID=usr.EmployeeID
		
		END

		ELSE
		BEGIN

		SELECT cb.CashBandID, cb.CashBand,CONCAT('X ', cb.CashBand) [CashBandValue]
		, cc.[Count], cc.Value, ccm.CashBoxDate, ccm.CashStatus, ccm.StoreID
		, ccm.MasterCashClosingID, ccm.CashNo, usr.EmployeeID, ccm.TotalCashValue
		, emp.Name, ISNULL(cr.Value,0) [CashReturn]
		FROM tblCloseCashBandMaster cb
		INNER JOIN tblCashClosing cc ON cb.CashBandID=cc.CashBandID
		INNER JOIN tblMasterCashClosing ccm ON cc.MasterCashClosingID=ccm.MasterCashClosingID
		LEFT OUTER JOIN tblCashReturn cr ON ccm.MasterCashClosingID=ISNULL(cr.MasterCashClosingID,ccm.MasterCashClosingID)
		INNER JOIN UserManagement usr ON ccm.EmployeeID=usr.UserID
		INNER JOIN EmployeeDetails emp ON usr.EmployeeID=emp.EmpID

		WHERE ccm.MasterCashClosingID=@MasterCashClosingID
		AND cc.[Count] > 0

		END
		
		SELECT CreditClosingID, MasterCashClosingID, [Type], [Count], Value 
		FROM [dbo].[tblCreditClosing] WITH(NOLOCK)
		WHERE MasterCashClosingID=@MasterCashClosingID

		IF @CashStatus = 0
		BEGIN
		
		SELECT '' AS MasterCashClosingID,'' AS PettyCashExpID,''AS Particulars,@ExpensesAmt ExpensesAmt
		
		END

		ELSE
		BEGIN
		
		SELECT @MasterCashClosingID MasterCashClosingID,PettyCashExpID,Particulars,ExpensesAmt
		FROM tblPettyCashExpensesDetails WITH(NOLOCK)
		WHERE StoreID=@StoreID
		AND TransactionDate = @CashBoxDate--CONVERT(DATE,GETDATE())
		AND ExpensesAmt > 0
		
		END

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <13th JULY 2020>
-- Update date: <17th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_CashClosing_Details 5
CREATE PROCEDURE [dbo].[SPR_Get_CashClosing_Details]
@MasterCashClosingID INT=0
--,@CashCredit INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @CashStatus INT=0
	DECLARE @CashBoxDate DATE=null

	SET @PARAMERES=@MasterCashClosingID

	SET NOCOUNT ON;
	
	IF @MasterCashClosingID > 0
	BEGIN

		SELECT @CashStatus=CashStatus FROM tblMasterCashClosing WITH(NOLOCK) 
		WHERE MasterCashClosingID=@MasterCashClosingID

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
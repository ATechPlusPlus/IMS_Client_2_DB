-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <21th JULY 2020>
-- Update date: <22th JULY 2020>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trg_UpdateTotalPettyCashBAL] ON [dbo].[tblPettyCashExpensesDetails]
FOR INSERT
AS 
--[tblTotalPettyCashExpenses]
DECLARE @StoreID INT=0
DECLARE @PettyCashExpAmt DECIMAL (18, 3)=0
DECLARE @PettyCashAmt DECIMAL (18, 3)=0
DECLARE @PettyCashBalance DECIMAL (18, 3)=0
DECLARE @CreatedBy DECIMAL (18, 3)=0


SELECT @StoreID =StoreID,@PettyCashAmt = ins.PettyCashAmt
,@PettyCashExpAmt = ins.ExpensesAmt,@CreatedBy = ins.CreatedBy 
FROM INSERTED ins

	IF EXISTS(SELECT 1 FROM tblTotalPettyCashExpenses WITH(NOLOCK) WHERE StoreID=@StoreID)
	BEGIN

		UPDATE tblTotalPettyCashExpenses SET
		TotalPettyCashAmt=TotalPettyCashAmt+@PettyCashAmt
		,TotalPettyCashExpAmt=TotalPettyCashExpAmt+@PettyCashExpAmt
		,PettyCashBalance=(TotalPettyCashAmt+@PettyCashAmt) - (TotalPettyCashExpAmt+@PettyCashExpAmt)
		,UpdatedBy=@CreatedBy,UpdatedOn=GETDATE()
		WHERE StoreID=@StoreID

	END

	ELSE
	BEGIN

		INSERT INTO tblTotalPettyCashExpenses
		(
		TotalPettyCashAmt
		,TotalPettyCashExpAmt
		,PettyCashBalance
		,StoreID
		,CreatedBy
		)
		SELECT @PettyCashAmt,@PettyCashExpAmt,(@PettyCashAmt-@PettyCashExpAmt),@StoreID,@CreatedBy

	END
GO
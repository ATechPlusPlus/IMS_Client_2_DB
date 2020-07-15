-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <14th JULY 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[SPR_Insert_CloseCash] 0,0,0,0,0
CREATE PROCEDURE [dbo].[SPR_Insert_CloseCash]
@MasterCashClosingID INT=0
,@CashBandID INT=0
,@Count INT=0
,@Value decimal(18,3)=0
,@CreatedBy INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@MasterCashClosingID,',',@CashBandID,',',@Count,',',@Count,',',@Value,',',@CreatedBy)

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
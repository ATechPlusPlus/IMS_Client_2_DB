-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <12th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_CashBand_Master
CREATE PROCEDURE [dbo].[SPR_Get_CashBand_Master]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	--SET @PARAMERES=@BrandName

	SET NOCOUNT ON;
	

	SELECT cb.CashBandID,cb.CashBand,
	(CASE WHEN cb.ActiveStatus =1 THEN 'Active' WHEN cb.ActiveStatus =0 THEN 'InActive' END)ActiveStatus
	FROM tblCloseCashBandMaster cb
	ORDER BY cb.CashBand
	
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
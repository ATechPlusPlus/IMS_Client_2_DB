-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <20th FEB 2020>
-- Modify date: <08th MAR 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[Get_CurrencyRate]
CREATE PROCEDURE [dbo].[Get_CurrencyRate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''

	SELECT CR.CurrencyRateID, CR.CountryID,C.CountryCode,C.CountryName, CR.CurrencyRate,
	CR.CurrencyCode, CR.CurrencyName
	FROM
	[dbo].[CurrencyRateSetting] CR
	INNER JOIN [dbo].[CountryMaster] C ON CR.CountryID=C.CountryID

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
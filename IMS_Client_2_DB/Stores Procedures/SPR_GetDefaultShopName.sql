-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <21st JULY 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_GetDefaultShopName
CREATE PROCEDURE [dbo].[SPR_GetDefaultShopName]

AS
BEGIN

	SET NOCOUNT ON;
	
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	--Normal Store  0
	--Wearhouse     1
    SELECT de.StoreID,sm.StoreName,de.StoreCategory
	,(CASE de.StoreCategory WHEN 0 THEN 'Normal Store' WHEN 1 THEN 'Wearhouse' END)[StoreCategoryName]
    FROM DefaultStoreSetting de
    INNER JOIN StoreMaster sm ON de.StoreID=sm.StoreID

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
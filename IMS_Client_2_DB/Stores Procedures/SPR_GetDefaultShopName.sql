-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <21st JULY 2020>
-- Update date: <07th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_GetDefaultShopName 'KHAN'
CREATE PROCEDURE [dbo].[SPR_GetDefaultShopName]
@MachineName NVARCHAR(MAX)=''
AS
BEGIN

	SET NOCOUNT ON;
	
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@MachineName

	--Normal Store  0
	--Warehouse     1

    SELECT psm.PC_Store_ID,psm.StoreID,sm.StoreName,psm.StoreCategory
	,(CASE psm.StoreCategory WHEN 0 THEN 'Normal Store' WHEN 1 THEN 'Warehouse' END)[StoreCategoryName]
    FROM tblPC_Store_Mapping psm
    INNER JOIN StoreMaster sm ON psm.StoreID=sm.StoreID
	WHERE MachineName=@MachineName

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
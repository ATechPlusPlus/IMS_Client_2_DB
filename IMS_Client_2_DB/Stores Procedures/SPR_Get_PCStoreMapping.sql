-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <07th AUGUST 2020>
-- Update date: <>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_PCStoreMapping
CREATE PROCEDURE SPR_Get_PCStoreMapping

AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''

	SELECT PSM.PC_Store_ID,PSM.StoreID, PSM.MachineName, SM.StoreName,SM.StoreCategory [StoreCategoryID],
	(CASE PSM.StoreCategory WHEN 1 THEN 'Warehouse' WHEN 0 THEN 'Normal Store' END) [StoreCategory] 
	FROM [dbo].[tblPC_Store_Mapping] PSM 
	INNER JOIN [dbo].[StoreMaster] SM ON SM.StoreID = PSM.StoreID
	ORDER BY PSM.PC_Store_ID

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
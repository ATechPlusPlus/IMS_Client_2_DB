-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <04th AUGUST 2020>
-- Update date: <19th AUGUST 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_ItemWiseModelNo 0,'0',0
CREATE PROCEDURE [dbo].[SPR_Get_ItemWiseModelNo]
@ProductID INT=0
,@ModelNo NVARCHAR(MAX)='0'
,@StoreID INT=0
AS
BEGIN

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@ProductID,',',@ModelNo,',',@StoreID)

	SET NOCOUNT ON;

	SELECT md.SubProductID,md.ProductID, pm.ProductName [ItemName], md.ModelNo [StyleNo]
	,bm.BrandName, sm.StoreName,md.BrandID,md.StoreID,md.Photo,md.EndUser
	FROM [dbo].[tblProductWiseModelNo] md 
	INNER JOIN ProductMaster pm ON md.ProductID = pm.ProductID 
	INNER JOIN BrandMaster bm ON md.BrandID = bm.BrandID 
	INNER JOIN StoreMaster sm ON md.StoreID = sm.StoreID
	WHERE pm.ProductID=IIF(@ProductID=0,pm.ProductID,@ProductID)
	AND md.StoreID=IIF(@StoreID=0,md.StoreID,@StoreID)
	AND md.ModelNo LIKE IIF(@ModelNo='0',md.ModelNo+'%',@ModelNo+'%')

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <04th AUGUST 2020>
-- Update date: <30th APR 2021>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_ItemWiseModelNo 0,'0',0,0
CREATE PROCEDURE [dbo].[SPR_Get_ItemWiseModelNo]
@ProductID INT=0
,@ModelNo NVARCHAR(MAX)='0'
,@StoreID INT=0
,@BarCode BIGINT=0
AS
BEGIN

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@ProductID,',',@ModelNo,',',@StoreID,',',@BarCode)

	SET NOCOUNT ON;

	SELECT md.SubProductID,md.ProductID, pm.ProductName [ItemName], md.ModelNo [StyleNo]
	,bm.BrandName, sm.StoreName,md.BrandID,md.StoreID,md.Photo,md.LocalCost,md.EndUser
	FROM [dbo].[tblProductWiseModelNo] md 
	INNER JOIN ProductMaster pm ON md.ProductID = pm.ProductID 
	INNER JOIN BrandMaster bm ON md.BrandID = bm.BrandID 
	INNER JOIN StoreMaster sm ON md.StoreID = sm.StoreID
	LEFT JOIN
	(
		SELECT TOP 1 ProductID,SubProductID,StoreID,BarcodeNo FROM ProductStockMaster WITH(NOLOCK) 
		WHERE QTY > 0 AND BarcodeNo=@BarCode
	)psm ON md.SubProductID=psm.SubProductID AND md.ProductID =psm.ProductID AND md.StoreID=psm.StoreID
	WHERE pm.ProductID=IIF(@ProductID=0,pm.ProductID,@ProductID)
	AND md.StoreID=IIF(@StoreID=0,md.StoreID,@StoreID)
	AND ISNULL(psm.BarcodeNo,0)=IIF(@BarCode=0,ISNULL(psm.BarcodeNo,0),@BarCode)
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
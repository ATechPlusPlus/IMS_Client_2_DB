-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <15th JULY 2020>
-- Update date: <06th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_StoreTransfer_ItemDetails 2003
CREATE PROCEDURE [dbo].[SPR_Get_StoreTransfer_ItemDetails]
@StoreBillDetailsID INT=0
AS
BEGIN

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@StoreBillDetailsID

	SET NOCOUNT ON;

	SELECT st.TransferItemID,st.StoreBillDetailsID,st.Barcode,st.BillQTY,ISNULL(st.EnterQTY,0)EnterQTY
	,'' [State],
	 (CASE WHEN st.BillQTY = ISNULL(st.EnterQTY,0) THEN 'Green'
	 WHEN st.BillQTY < ISNULL(st.EnterQTY,0) THEN 'Orange' ELSE 'Red' END) [CellColor]
	,pwm.ModelNo [StyleNo]
	,st.ProductID,st.SubProductID,pm.ProductName [Item],cm.ColorName [Color],sm.Size
	,stb.BillDate,stb.BillNo,stb.TotalQTY,st.Total
	,st.ColorID,st.SizeID
	FROM tblStoreTransferItemDetails st
	INNER JOIN [tblStoreTransferBillDetails] stb ON st.StoreBillDetailsID=stb.StoreTransferID
	INNER JOIN tblProductWiseModelNo pwm ON st.SubProductID=pwm.SubProductID AND st.ProductID=pwm.ProductID
	--INNER JOIN ProductStockMaster psm ON st.ProductID=psm.ProductID AND st.ColorID=psm.ColorID AND st.SizeID=psm.SizeID 
	--AND psm.BarcodeNo IS NOT NULL AND psm.QTY > 0

	INNER JOIN ProductMaster pm ON st.ProductID=pm.ProductID
	INNER JOIN ColorMaster cm ON st.ColorID=cm.ColorID
	INNER JOIN SizeMaster sm ON st.SizeID=sm.SizeID
	WHERE st.StoreBillDetailsID=@StoreBillDetailsID

	UNION

	SELECT vt.[TransferItemID], vt.[StoreBillDetailsID],vt.[Barcode]
	, vt.BillQTY, vt.[EnterQTY],'' [State]
	,'Violet' [CellColor], vt.ModelNo [StyleNo]
	, vt.ProductID,vt.SubProductID,pm.ProductName [Item],cm.ColorName [Color],sm.Size [Size]
	,'' BillDate,'' BillNo,'' TotalQTY
    ,0 [Total]
	,vt.ColorID,vt.SizeID
	FROM tblStoreTransferItemDetails_Voilet vt
	INNER JOIN tblProductWiseModelNo pwm ON vt.SubProductID=pwm.SubProductID AND vt.ProductID=pwm.ProductID
	INNER JOIN ProductMaster pm ON vt.ProductID=pm.ProductID
	INNER JOIN ColorMaster cm ON vt.ColorID=cm.ColorID
	INNER JOIN SizeMaster sm ON vt.SizeID=sm.SizeID
	WHERE StoreBillDetailsID=@StoreBillDetailsID
	ORDER BY [TransferItemID] DESC

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <15th JULY 2020>
-- Update date: <16th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_StoreTransfer_ItemDetails 1
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
	,psm.ModelNo
	,st.ProductID,pm.ProductName [Item],cm.ColorName [Color],sm.Size
	,stb.BillDate,stb.BillNo,stb.TotalQTY,st.Total
	FROM tblStoreTransferItemDetails st
	INNER JOIN [tblStoreTransferBillDetails] stb ON st.StoreBillDetailsID=stb.StoreTransferID
	INNER JOIN ProductStockMaster psm ON st.ProductID=psm.ProductID AND st.ColorID=psm.ColorID AND st.SizeID=psm.SizeID 
	AND psm.BarcodeNo IS NOT NULL AND psm.QTY > 0
	
	INNER JOIN ProductMaster pm ON st.ProductID=pm.ProductID
	INNER JOIN ColorMaster cm ON st.ColorID=cm.ColorID
	INNER JOIN SizeMaster sm ON st.SizeID=sm.SizeID
	WHERE st.StoreBillDetailsID=@StoreBillDetailsID

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
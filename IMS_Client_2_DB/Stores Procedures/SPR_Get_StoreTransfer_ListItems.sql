-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <18th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_StoreTransfer_ListItems 1
CREATE PROCEDURE [dbo].[SPR_Get_StoreTransfer_ListItems]
@StoreBillDetailsID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @ReceiveBillNo NVARCHAR(MAX)=''
	DECLARE @TotalQTY AS INT=0
	DECLARE @ReceiveBillDate AS DATE=NULL

	BEGIN TRY
	
	SET @PARAMERES=@StoreBillDetailsID

	SELECT 
      @ReceiveBillNo=ReceiveBillNo
      ,@TotalQTY=TotalQTY
      ,@ReceiveBillDate=ReceiveBillDate
  FROM tblStoreTransferReceiveBillDetails WITH(NOLOCK) WHERE StoreTransferID=@StoreBillDetailsID

	SELECT st.TransferItemID,st.StoreBillDetailsID,st.Barcode,st.BillQTY,ISNULL(st.EnterQTY,0)EnterQTY
	,'' [State],
	 (CASE WHEN st.BillQTY = ISNULL(st.EnterQTY,0) THEN 'Green'
	 WHEN st.BillQTY < ISNULL(st.EnterQTY,0) THEN 'Orange' ELSE 'Red' END) [CellColor]
	,psm.ModelNo,@ReceiveBillNo [ReceiveBillNo],@TotalQTY [ReceivedTotalQTY],@ReceiveBillDate [ReceiveBillDate]
	,st.ProductID,pm.ProductName [Item],cm.ColorName [Color],sm.Size
	,stb.BillDate,stb.BillNo,stb.TotalQTY,st.Total,stm.StoreName
	FROM tblStoreTransferItemDetails st
	INNER JOIN [tblStoreTransferBillDetails] stb ON st.StoreBillDetailsID=stb.StoreTransferID
	INNER JOIN ProductStockMaster psm ON st.ProductID=psm.ProductID AND st.ColorID=psm.ColorID AND st.SizeID=psm.SizeID 
	AND psm.BarcodeNo IS NOT NULL AND psm.QTY > 0
	
	INNER JOIN ProductMaster pm ON st.ProductID=pm.ProductID
	INNER JOIN ColorMaster cm ON st.ColorID=cm.ColorID
	INNER JOIN SizeMaster sm ON st.SizeID=sm.SizeID
	INNER JOIN StoreMaster stm ON stb.ToStore=stm.StoreID
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
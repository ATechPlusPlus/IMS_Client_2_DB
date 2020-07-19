-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <18th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_ProductDetails_ForVioletColor 1,1001
CREATE PROCEDURE SPR_Get_ProductDetails_ForVioletColor
@BillNo AS NVARCHAR(100)='0'
,@BarCode AS INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @StoreID INT=0
	SET @PARAMERES=CONCAT(@BillNo,',',@BarCode)

	SELECT @StoreID=FromStore FROM tblStoreTransferBillDetails WITH(NOLOCK) WHERE BillNo=@BillNo

	SELECT --'' [TransferItemID],'' [StoreBillDetailsID],
	p2.BarcodeNo [Barcode]
	--,'' BillQTY,1 [EnterQTY],'' [State]
	,'Violet' [CellColor],p2.ModelNo
	, p1.ProductID, p1.ProductName [Item],c1.ColorName [Color]
    ,s1.Size
	--,'' BillDate,'' BillNo,'' TotalQTY,'' Total
	FROM dbo.ProductMaster p1
    JOIN ProductStockMaster p2 ON p1.ProductID=p2.ProductID AND p2.StoreID = @StoreID AND p2.BarcodeNo IS NOT NULL
	JOIN ColorMaster c1 ON p2.colorID=c1.ColorID 
    JOIN SizeMaster s1 ON p2.SizeID=s1.SizeID
    WHERE p2.StoreID = @StoreID 
	AND p2.BarcodeNo =@BarCode

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
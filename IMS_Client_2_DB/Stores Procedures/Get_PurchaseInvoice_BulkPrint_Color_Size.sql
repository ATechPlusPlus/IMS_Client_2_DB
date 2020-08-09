
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <07th MARCH 2020>
-- Update date: <9th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
-- EXEC [dbo].[Get_PurchaseInvoice_BulkPrint_Color_Size] 2,1
CREATE PROCEDURE [dbo].[Get_PurchaseInvoice_BulkPrint_Color_Size]
@PurchaseInvoiceID INT=0
,@StoreID INT=0
,@ModelNo NVARCHAR(MAX)='0'
,@PrintStaus INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''

	SET @PARAMERES=CONCAT(@PurchaseInvoiceID,',',@StoreID,',',@ModelNo,',',@PrintStaus)

	SELECT ps.ProductStockID, ps.PurchaseInvoiceID, ps.SubProductID, ps.ProductID,pm.ProductName,ps.Rate
	, ps.StoreID, ps.BarcodeNo, ps.ColorID,cm.ColorName AS Color,sm.SizeID,sm.Size, ps.QTY, ps.ModelNo
	FROM ProductStockMaster ps
	INNER JOIN ProductMaster pm ON ps.ProductID = pm.ProductID
	INNER JOIN ColorMaster cm ON ps.ColorID = cm.ColorID
	Inner Join SizeMaster sm on ps.SizeID = sm.SizeID
	WHERE ps.PurchaseInvoiceID = @PurchaseInvoiceID
	AND ps.StoreID = @StoreID
	AND ps.QTY>0
	AND ps.PrintCount=0
	AND ps.ModelNo=IIF(@ModelNo='0',ps.ModelNo,@ModelNo)


	SELECT DISTINCT ModelNo
	FROM ProductStockMaster WITH(NOLOCK)
	WHERE PurchaseInvoiceID = @PurchaseInvoiceID
	AND StoreID = @StoreID
	AND PrintCount=0
	AND QTY>0

	SELECT ps.ProductStockID, ps.PurchaseInvoiceID, ps.SubProductID, ps.ProductID,pm.ProductName,ps.Rate
	, ps.StoreID, ps.BarcodeNo, ps.ColorID,cm.ColorName AS Color,sm.SizeID,sm.Size, ps.QTY, ps.ModelNo
	FROM ProductStockMaster ps
	INNER JOIN ProductMaster pm ON ps.ProductID = pm.ProductID
	INNER JOIN ColorMaster cm ON ps.ColorID = cm.ColorID
	Inner Join SizeMaster sm on ps.SizeID = sm.SizeID
	WHERE ps.PurchaseInvoiceID = @PurchaseInvoiceID
	AND ps.StoreID = @StoreID
	AND ps.QTY>0
	AND ps.PrintCount>0
	--AND ps.ModelNo=IIF(@ModelNo='0',ps.ModelNo,@ModelNo)
	
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
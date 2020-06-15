
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <07th MARCH 2020>
-- Modify date: <10th MARCH 2020>
-- Description:	<Description,,>
-- =============================================
-- EXEC [dbo].[Get_PurchaseInvoice_BulkPrint_Color_Size] 1
-- EXEC [dbo].[Get_PurchaseInvoice_BulkPrint_Color_Size] 'purinv01' OLD
CREATE PROCEDURE [dbo].[Get_PurchaseInvoice_BulkPrint_Color_Size]
@PurchaseInvoiceID INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''

	SET @PARAMERES=@PurchaseInvoiceID

	SELECT ps.ProductStockID, ps.PurchaseInvoiceID, ps.ProductID,pm.ProductName,pm.Rate
	, ps.StoreID, ps.BarcodeNo, ps.ColorID,cm.ColorName AS Color,sm.SizeID,sm.Size, ps.QTY, ps.ModelNo
	FROM ProductStockMaster ps
	INNER JOIN ProductMaster pm ON ps.ProductID = pm.ProductID
	INNER JOIN ColorMaster cm ON ps.ColorID = cm.ColorID
	Inner Join SizeMaster sm on ps.SizeID = sm.SizeID
	WHERE ps.PurchaseInvoiceID = @PurchaseInvoiceID
	AND ps.QTY>0

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
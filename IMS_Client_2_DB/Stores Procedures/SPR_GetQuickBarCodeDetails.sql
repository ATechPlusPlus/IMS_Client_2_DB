
-- =============================================
-- Author:		<Mateen KHAN>
-- Create date: <07th MARCH 2020>
-- Update date: <08th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
-- EXEC [dbo].[SPR_GetQuickBarCodeDetails] 1000
CREATE PROCEDURE [dbo].[SPR_GetQuickBarCodeDetails]
@BarCodeNo NVARCHAR(MAX)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@BarCodeNo

	SELECT ps.ProductStockID, ps.PurchaseInvoiceID, ps.SubProductID, ps.ProductID,pm.ProductName,ps.Rate
	, ps.StoreID, ps.BarcodeNo, ps.ColorID,cm.ColorName AS Color,sm.SizeID,sm.Size, ps.QTY, ps.ModelNo
	FROM ProductStockMaster ps
	INNER JOIN ProductMaster pm ON ps.ProductID = pm.ProductID
	INNER JOIN ColorMaster cm ON ps.ColorID = cm.ColorID
	Inner Join SizeMaster sm on ps.SizeID = sm.SizeID
	where ps.BarcodeNo=@BarCodeNo
	

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
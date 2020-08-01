-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <15th MARCH 2020>
-- Update date: <02th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_PurchaseInvoice_BillDetails 2
CREATE PROCEDURE [dbo].[Get_PurchaseInvoice_BillDetails]
@PurchaseInvoiceID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@PurchaseInvoiceID

	SELECT p1.PurchaseInvoiceID,ISNULL(p2.PurchaseInvoiceDetailsID,0)PurchaseInvoiceDetailsID
	,ISNULL(p2.ProductID,0)ProductID,ISNULL(p2.SubProductID,0)SubProductID,pm.ProductName,p2.ModelNo,p2.BrandID,bm.BrandName,p2.QTY,p2.Rate
	,CAST(p2.QTY * p2.Rate AS	decimal(18,2)) [Total]
	,CAST(p1.LocalBillValue/p1.TotalQTY AS decimal(18,2)) [LocalCost],p2.AddedRatio,p2.SuppossedPrice
	,p2.Sales_Price [EndUser],p1.SupplierID,p1.BillDate,p1.BillValue
	,p1.TotalQTY,p1.LocalValue,p1.LocalBillValue
	FROM [dbo].[PurchaseInvoice] p1
	LEFT OUTER JOIN [dbo].[PurchaseInvoiceDetails] p2 ON p1.PurchaseInvoiceID = p2.PurchaseInvoiceID
	LEFT OUTER JOIN [dbo].[ProductMaster] pm ON p2.ProductID = pm.ProductID
	LEFT OUTER JOIN [dbo].[BrandMaster] bm ON p2.BrandID = bm.BrandID AND p2.SupplierID = bm.SupplierID
	WHERE p1.PurchaseInvoiceID = @PurchaseInvoiceID
	
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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <12th JULY 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_StyleNo_Popup '1'
CREATE PROCEDURE [dbo].[SPR_Get_StyleNo_Popup]
@ModelNo NVARCHAR(100)='0'
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@ModelNo

	SELECT DISTINCT pid1.ModelNo [StyleNo]
	FROM PurchaseInvoice pur
	INNER JOIN PurchaseInvoiceDetails pid ON pur.PurchaseInvoiceID=pid.PurchaseInvoiceID AND pur.IsInvoiceDone=1
	INNER JOIN ProductMaster pm ON pid.ProductID=pm.ProductID
	INNER JOIN DeliveryPurchaseBill1 pid1 ON pur.PurchaseInvoiceID=pid1.PurchaseInvoiceID AND pm.ProductID=pid1.ProductID
	INNER JOIN StoreMaster sm ON pid1.StoreID=sm.StoreID
	WHERE pid1.ModelNo LIKE ''+@ModelNo+'%'+''

	--SELECT  pid1.ModelNo,pur.SupplierBillNo,pur.IsInvoiceDone,pid.PurchaseInvoiceDetailsID
	--,pid1.StoreID,sm.StoreName
	--FROM PurchaseInvoice pur
	--INNER JOIN PurchaseInvoiceDetails pid ON pur.PurchaseInvoiceID=pid.PurchaseInvoiceID AND pur.IsInvoiceDone=1
	--INNER JOIN ProductMaster pm ON pid.ProductID=pm.ProductID
	--INNER JOIN DeliveryPurchaseBill1 pid1 ON pur.PurchaseInvoiceID=pid1.PurchaseInvoiceID AND pm.ProductID=pid1.ProductID
	--INNER JOIN StoreMaster sm ON pid1.StoreID=sm.StoreID

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
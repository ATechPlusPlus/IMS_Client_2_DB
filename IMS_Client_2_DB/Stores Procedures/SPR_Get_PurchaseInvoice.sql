-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <05th AUGUST 2020>
-- Update date: <30th AUGUST 2021>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_PurchaseInvoice '0','0'
CREATE PROCEDURE [dbo].[SPR_Get_PurchaseInvoice]
@SupplierBillNo VARCHAR(MAX)='0'
,@ShipmentNo VARCHAR(MAX)='0'
AS
BEGIN

	SET NOCOUNT ON;
	
	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@SupplierBillNo,',',@ShipmentNo)

	IF @SupplierBillNo='0' AND @ShipmentNo='0'
	BEGIN

		SELECT PurchaseInvoiceID, SupplierBillNo, SupplierID, ShipmentNo, BillDate, BillValue, TotalQTY,Discount, ForeignExp, GrandTotal
		, LocalValue,LocalExp, LocalBillValue,IsInvoiceDone
		,(CASE IsInvoiceDone WHEN 1 THEN 'Posted' WHEN 0 THEN 'Not Posted' END) InvoiceStatus
		FROM PurchaseInvoice WITH(NOLOCK)
		ORDER BY PurchaseInvoiceID DESC
	
	END

	ELSE
	BEGIN

		SELECT PurchaseInvoiceID,SupplierBillNo, SupplierID, ShipmentNo, BillDate, BillValue, TotalQTY, Discount, ForeignExp, GrandTotal
		, LocalValue,LocalExp, LocalBillValue,IsInvoiceDone
		,(CASE IsInvoiceDone WHEN 1 THEN 'Posted' WHEN 0 THEN 'Not Posted' END) InvoiceStatus
		FROM PurchaseInvoice WITH(NOLOCK)
		WHERE SupplierBillNo LIKE IIF(@SupplierBillNo='0',SupplierBillNo,'%'+@SupplierBillNo+'%')
		AND ShipmentNo LIKE IIF(@ShipmentNo='0',ShipmentNo,'%'+@ShipmentNo+'%')

	END
	
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
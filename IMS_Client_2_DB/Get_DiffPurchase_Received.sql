-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <11th MARCH 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_DiffPurchase_Received 1
CREATE PROCEDURE [dbo].[Get_DiffPurchase_Received]
@PurchaseInvoiceID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY

	DECLARE @PurchaseInvoiceDate DATE
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET NOCOUNT ON;
	
	SET @PARAMERES=@PurchaseInvoiceID

	SELECT @PurchaseInvoiceDate=BillDate 
	FROM [dbo].[PurchaseInvoice] 
	WHERE PurchaseInvoiceID = @PurchaseInvoiceID

	SELECT @PurchaseInvoiceDate [Date]
	,SUM(pd3.Total) Total
	,(CASE WHEN ISNULL(PostingStatus,0)=0 THEN 'Not Posted' 
		WHEN  ISNULL(PostingStatus,0)=1 THEN 'Posted' END) PostingStatus
	FROM DeliveryPurchaseBill1 pd1
	INNER JOIN DeliveryPurchaseBill2 pd2 ON pd2.DeliveryPurchaseID1=pd1.DeliveryPurchaseID1
	INNER JOIN DeliveryPurchaseBill3 pd3 ON pd2.DeliveryPurchaseID2=pd3.DeliveryPurchaseID2
	INNER JOIN ColorMaster clr ON pd3.ColorID=clr.ColorID
	LEFT OUTER JOIN PostingDeliveryEntry pd ON  pd1.PurchaseInvoiceID = @PurchaseInvoiceID
	AND pd1.PurchaseInvoiceID=pd.PurchaseInvoiceID
	WHERE 
	pd1.PurchaseInvoiceID = @PurchaseInvoiceID
	GROUP BY PostingStatus

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
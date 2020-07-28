-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <26th FEB 2020>
-- Modify date: <28th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[Get_Delivering_PurchaseInvoice_BillDetails] 2,1
CREATE PROCEDURE [dbo].[Get_Delivering_PurchaseInvoice_BillDetails]
--@Supplier_BillNo varchar(50)
@PurchaseInvoiceID INT = 0
,@status INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @SupplierBillNo VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@PurchaseInvoiceID,',',@status)

	SELECT @SupplierBillNo=SupplierBillNo FROM PurchaseInvoice WHERE PurchaseInvoiceID=@PurchaseInvoiceID

	IF @status = 0
	BEGIN
		SELECT ISNULL(pid1.DeliveryPurchaseID1,0) DeliveryPurchaseID1,pid.PurchaseInvoiceDetailsID, 
		pid.PurchaseInvoiceID, @SupplierBillNo AS SupplierBillNo,
		pid.ProductID, pid.SubProductID, pid.ModelNo, pid.BrandID, pid.SupplierID, pid.QTY, pid.Rate, 
		pid.BillDate, pid.Sales_Price [Sales Price], ISNULL(cat.CategoryID,0)CategoryID,pm.ProductName,
		bm.BrandName,sm.SupplierName,sm.CountryID,cm.CountryName
		,ISNULL(pid1.SizeTypeID,0)SizeTypeID,ISNULL(pid1.StoreID,0)StoreID
		FROM [dbo].[PurchaseInvoiceDetails] pid
		INNER JOIN [dbo].[ProductMaster] pm ON pid.ProductID = pm.ProductID
	
		LEFT OUTER JOIN [dbo].[DeliveryPurchaseBill1] pid1 ON pid.ProductID = pid1.ProductID
		AND pid1.PurchaseInvoiceID = @PurchaseInvoiceID

		INNER JOIN [dbo].[CategoryMaster] cat ON pm.CategoryID = cat.CategoryID
		INNER JOIN [dbo].[BrandMaster] bm ON pid.BrandID = bm.BrandID
		INNER JOIN [dbo].[SupplierMaster] sm ON pid.SupplierID = sm.SupplierID
		INNER JOIN [dbo].[CountryMaster] cm ON sm.CountryID = cm.CountryID
		WHERE pid.PurchaseInvoiceID = @PurchaseInvoiceID
	END

	ELSE
	BEGIN
		SELECT ISNULL(pid1.DeliveryPurchaseID1,0) DeliveryPurchaseID1,pid.PurchaseInvoiceDetailsID, 
		pid.PurchaseInvoiceID, @SupplierBillNo AS SupplierBillNo,
		pid.ProductID, pid.SubProductID, pid.ModelNo, pid.BrandID, pid.SupplierID, pid.QTY, pid.Rate, 
		pid.BillDate, pid.Sales_Price [Sales Price], ISNULL(cat.CategoryID,0)CategoryID,pm.ProductName,
		bm.BrandName,sm.SupplierName,sm.CountryID,cm.CountryName
		,ISNULL(pid1.SizeTypeID,0)SizeTypeID,ISNULL(pid1.StoreID,0)StoreID
		FROM [dbo].[PurchaseInvoiceDetails] pid
		INNER JOIN [dbo].[ProductMaster] pm ON pid.ProductID = pm.ProductID
	
		INNER JOIN [dbo].[DeliveryPurchaseBill1] pid1 ON pid.ProductID = pid1.ProductID
		AND pid1.PurchaseInvoiceID = @PurchaseInvoiceID

		INNER JOIN [dbo].[CategoryMaster] cat ON pm.CategoryID = cat.CategoryID
		INNER JOIN [dbo].[BrandMaster] bm ON pid.BrandID = bm.BrandID
		INNER JOIN [dbo].[SupplierMaster] sm ON pid.SupplierID = sm.SupplierID
		INNER JOIN [dbo].[CountryMaster] cm ON sm.CountryID = cm.CountryID
		WHERE pid.PurchaseInvoiceID = @PurchaseInvoiceID
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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <26th FEB 2020>
-- Modify date: <17th MARCH 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[Get_Delivering_PurchaseInvoice_BillDetails] 2,1
--EXEC [dbo].[Get_Delivering_PurchaseInvoice_BillDetails] 'purinv01' OLD
CREATE PROCEDURE [dbo].[Get_Delivering_PurchaseInvoice_BillDetails]
--@Supplier_BillNo varchar(50)
@PurchaseInvoiceID INT = 0
,@status INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @status = 0
	BEGIN
		SELECT ISNULL(pid1.DeliveryPurchaseID1,0) DeliveryPurchaseID1,pid.PurchaseInvoiceDetailsID, 
		pid.PurchaseInvoiceID, pid.SupplierBillNo,
		pid.ProductID, pid.ModelNo, pid.BrandID, pid.SupplierID, pid.QTY, pid.Rate, 
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
		pid.PurchaseInvoiceID, pid.SupplierBillNo,
		pid.ProductID, pid.ModelNo, pid.BrandID, pid.SupplierID, pid.QTY, pid.Rate, 
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
	/*
	SELECT ISNULL(pid1.DeliveryPurchaseID1,0) DeliveryPurchaseID1,pid.PurchaseInvoiceDetailsID, 
	pid.PurchaseInvoiceID, pid.SupplierBillNo,
	pid.ProductID, pid.ModelNo, pid.BrandID, pid.SupplierID, pid.QTY, pid.Rate, 
	pid.BillDate, pid.Sales_Price, ISNULL(cat.CategoryID,0)CategoryID,pm.ProductName,
	bm.BrandName,sm.SupplierName,sm.CountryID,cm.CountryName,ISNULL(pid1.SizeTypeID,0)SizeTypeID
	FROM [dbo].[PurchaseInvoiceDetails] pid
	INNER JOIN [dbo].[ProductMaster] pm ON pid.ProductID = pm.ProductID
	
	LEFT JOIN [dbo].[DeliveryPurchaseBill1] pid1 ON pid.ProductID = pid1.ProductID
	AND pid.SupplierBillNo = @Supplier_BillNo

	LEFT JOIN [dbo].[CategoryMaster] cat ON pm.CategoryID = cat.CategoryID
	INNER JOIN [dbo].[BrandMaster] bm ON pid.BrandID = bm.BrandID
	INNER JOIN [dbo].[SupplierMaster] sm ON pid.SupplierID = sm.SupplierID
	INNER JOIN [dbo].[CountryMaster] cm ON sm.CountryID = cm.CountryID
	WHERE pid.SupplierBillNo = @Supplier_BillNo
	*/

END
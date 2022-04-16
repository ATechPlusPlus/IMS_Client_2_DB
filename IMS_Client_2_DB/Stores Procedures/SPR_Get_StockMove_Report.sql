-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <13th FEB 2022>
-- Update date: <>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_StockMove_Report '2020-01-19','2021-01-19'
CREATE PROCEDURE dbo.SPR_Get_StockMove_Report
@FromDate DATE,
@ToDate DATE

AS
BEGIN

	BEGIN TRY

	DECLARE @PARAMERES NVARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@FromDate,',',@ToDate)

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT a.StoreName AS Branch,0 AS InitQTY,0 AS InitCost,SUM(a.BalQTY) BalQTY,SUM(a.BalLocalCost) BalCost
,SUM(a.PurQTY) PurQTY,SUM(a.PurLocalCost) PurCost
,SUM(a.BalQTY+a.PurQTY) AS TotalQTY,SUM(a.BalLocalCost+a.PurLocalCost) AS TotalCost
,SUM(a.SalesQTY) SalesQTY,SUM(a.SalesLocalCost) SalesCost
,SUM(a.Rate) SalesRate
,SUM(a.BalQTY+a.PurQTY-a.SalesQTY) AS CurrQTY,SUM(a.BalLocalCost+a.PurLocalCost-a.SalesLocalCost) AS CurrCost
FROM
(
		-- Balance QTY
		SELECT sm.StoreName,SUM(ps.QTY) AS BalQTY,sum(pwm.LocalCost) BalLocalCost
		,0 AS PurQTY,0 AS PurLocalCost
		,0 AS SalesQTY,0 AS SalesLocalCost
		,0 AS Rate
		FROM ProductStockColorSizeMaster ps
		INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
		INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
		INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
		INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
		INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
		INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
		GROUP BY sm.StoreName

		UNION
		-- Purchase QTY
		SELECT stm.StoreName,0 AS BalQTY,0 AS BalLocalCost
		,SUM(pid.QTY) PurQTY,sum(pwm.LocalCost) PurLocalCost
		,0 AS SalesQTY,0 AS SalesLocalCost
		,0 AS Rate
		FROM [dbo].[PurchaseInvoiceDetails] pid
		INNER JOIN [dbo].[ProductMaster] pm ON pid.ProductID = pm.ProductID	
		INNER JOIN [dbo].[DeliveryPurchaseBill1] pid1 ON pid.ProductID = pid1.ProductID
		AND pid.PurchaseInvoiceID = pid1.PurchaseInvoiceID AND pid.SubProductID=pid1.SubProductID
		INNER JOIN tblProductWiseModelNo pwm ON pid.SubProductID=pwm.SubProductID AND pid.ProductID=pwm.ProductID
		INNER JOIN [dbo].[CategoryMaster] cat ON pm.CategoryID = cat.CategoryID
		INNER JOIN StoreMaster stm ON pid1.StoreID=stm.StoreID
		INNER JOIN [dbo].[BrandMaster] bm ON pid.BrandID = bm.BrandID
		INNER JOIN [dbo].[SupplierMaster] sm ON pid.SupplierID = sm.SupplierID
		INNER JOIN [dbo].[CountryMaster] cm ON sm.CountryID = cm.CountryID
		WHERE pid.BillDate BETWEEN @FromDate AND @ToDate
		GROUP BY stm.StoreName

		UNION
		----Sales
		SELECT sm.StoreName,0 AS BalQTY,0 AS BalLocalCost
		,0 AS PurQTY,0 AS PurLocalCost
		,SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS SalesQTY
		,SUM(v2.LocalCost) SalesLocalCost
		,SUM(v2.QTY * v2.Rate) AS Rate
		FROM dbo.View_SalesBillDetails v1 --ShopeID
		JOIN dbo.View_SalesDetails v2 ON v1.Id = v2.InvoiceID
		JOIN dbo.CategoryMaster cm ON v2.CategoryID=cm.CategoryID
		JOIN dbo.StoreMaster sm on v1.ShopeID=sm.StoreID
		--WHERE v1.ShopeID = @StoreID
		WHERE v1.InvoiceDate BETWEEN @FromDate AND @ToDate
		AND v2.QTY!=0
		GROUP BY sm.StoreName
)a GROUP BY a.StoreName

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

			SELECT -1 AS Flag,ERROR_MESSAGE() AS Msg

			END CATCH
	
END
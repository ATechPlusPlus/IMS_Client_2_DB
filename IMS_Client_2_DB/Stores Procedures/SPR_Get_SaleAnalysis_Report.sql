-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <19th JAN 2021>
-- Update date: <22th MAR 2021>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_SaleAnalysis_Report 0,NULL,NULL
CREATE PROCEDURE [dbo].[SPR_Get_SaleAnalysis_Report]
@StoreID INT=0
,@FromDate DATE=NULL
,@ToDate DATE=NULL

AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY

	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@StoreID,',',@FromDate,',',@ToDate)

	SELECT t.StoreName,t.QTY,t.TotalSales,t.LocalCost,(t.TotalSales - t.LocalCost)[GrossProfit]
,CONCAT(CAST( ((t.TotalSales - t.LocalCost)/t.LocalCost) * 100 AS DECIMAL(18,3) ),'%') [NetProfitRatio]
	FROM(
		SELECT v1.StoreName ,SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		,SUM(v2.QTY * v2.Rate) AS TotalSales,SUM(v2.QTY * v2.LocalCost)LocalCost
		--,ROUND((SUM(p1.LocalBillValue)/SUM(p1.TotalQTY)),3) [LocalCost]
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.Id = v2.InvoiceID
		--WHERE v1.ShopeID = @StoreID
		WHERE v1.InvoiceDate BETWEEN ISNULL(@FromDate,v1.InvoiceDate) AND ISNULL(@ToDate,v1.InvoiceDate)
		AND v1.ShopeID=IIF(@StoreID=0,v1.ShopeID,@StoreID)
		GROUP BY v1.StoreName
		)t
		ORDER BY ( ((t.TotalSales - t.LocalCost)/t.LocalCost) * 100 ) DESC

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
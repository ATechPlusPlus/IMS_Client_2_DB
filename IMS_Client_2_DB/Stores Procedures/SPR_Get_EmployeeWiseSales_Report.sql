-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <19th JAN 2021>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_EmployeeWiseSales_Report 0,null,NULL,1000
CREATE PROCEDURE [dbo].[SPR_Get_EmployeeWiseSales_Report]
@EmpID INT=0
,@FromDate DATE=NULL
,@ToDate DATE=NULL
,@Admintraviteexp DECIMAL(18,3)=0

AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY

	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@EmpID,',',@FromDate,',',@ToDate,',',@Admintraviteexp)

	DECLARE @Commision DECIMAL(18,3)=0
	SET @Commision=(SELECT TOP 1 Commision FROM DefaultStoreSetting WITH(NOLOCK) WHERE ISNULL(Commision,0)!=0)

	SELECT t.SalesMan,t.QTY,t.TotalSales,t.LocalCost,(t.TotalSales - t.LocalCost)[GrossProfit],t.MonthlySalary
,CAST( (@Admintraviteexp/30) AS DECIMAL(18,3)) [AdmintraviteExp]
,CAST( ((t.TotalSales - t.LocalCost) * @Commision * 0.01) - (@Admintraviteexp/30/5) AS decimal(18,3) ) [Commision]
,( (t.TotalSales - t.LocalCost) - ( (t.TotalSales - t.LocalCost) * @Commision * 0.01) - (@Admintraviteexp/30/5) ) [NetProfit]
	FROM(
		--SELECT t.SalesMan,SUM(t.QTY),SUM(t.TotalSales),SUM(t.LocalCost) FROM(
		SELECT v1.Name AS SalesMan ,v1.MonthlySalary, SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		,SUM(v2.QTY * v2.Rate) AS TotalSales,SUM(v2.QTY * v2.LocalCost)LocalCost
		--,ROUND((SUM(p1.LocalBillValue)/SUM(p1.TotalQTY)),3) [LocalCost]
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID
		--WHERE v1.ShopeID = @StoreID
		WHERE v1.InvoiceDate BETWEEN ISNULL(@FromDate,v1.InvoiceDate) AND ISNULL(@ToDate,v1.InvoiceDate)
		AND v1.SalesMan=IIF(@EmpID=0,v1.SalesMan,@EmpID)
		GROUP BY v1.Name,v1.MonthlySalary
		--,p2.ProductID,p2.SubProductID
		--ORDER BY SUM(v2.QTY * v2.Rate) DESC
		)t
		ORDER BY ( (t.TotalSales - t.LocalCost) - ( (t.TotalSales - t.LocalCost) * @Commision * 0.01) - (@Admintraviteexp/30/5) ) DESC

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <16th MAR 2021>
-- Update date: <>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_Sales_Department_Report 0,'2020-09-02','2020-09-02'
CREATE PROCEDURE [dbo].[SPR_Get_Sales_Department_Report]
@CategoryID INT=0
,@FromDate DATE='0'
,@ToDate DATE='0'
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@CategoryID,',',@FromDate,',',@ToDate)

	SELECT t.ModelNo,t.SubProductID,t.ProductName,t.ProductID,t.CategoryName
	,SUM(t.QTY * t.Rate) AS TotalSales,SUM(t.QTY * t.LocalCost)LocalCost
	,SUM(t.QTY) QTY
	,SUM(t.Rate) Rate,SUM(t.LocalCost) [Local]
	,( (SUM(t.QTY * t.Rate) - SUM(t.QTY * t.LocalCost))*0.01 ) [Profit]
	FROM(
		--SELECT t.SalesMan,SUM(t.QTY),SUM(t.TotalSales),SUM(t.LocalCost) FROM(
		SELECT v2.ModelNo,v2.SubProductID,v2.ProductName,v2.ProductID,cm.CategoryName
		--,SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		,(CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END) AS QTY
		,v2.Rate,v2.LocalCost
		--,ROUND((SUM(p1.LocalBillValue)/SUM(p1.TotalQTY)),3) [LocalCost]
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.Id = v2.InvoiceID
		JOIN dbo.CategoryMaster cm ON v2.CategoryID=cm.CategoryID
		--WHERE v1.ShopeID = @StoreID
		WHERE v1.InvoiceDate BETWEEN ISNULL(@FromDate,v1.InvoiceDate) AND ISNULL(@ToDate,v1.InvoiceDate)
		AND v2.CategoryID=IIF(@CategoryID=0,v2.CategoryID,@CategoryID)
		--GROUP BY v2.ModelNo,v2.ProductName,v2.ProductID,v2.Rate,v2.LocalCost
		--,p2.ProductID,p2.SubProductID
		--ORDER BY SUM(v2.QTY * v2.Rate) DESC
		)t
		GROUP BY t.CategoryName,t.ModelNo,t.SubProductID,t.ProductName,t.ProductID
		ORDER BY t.CategoryName

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
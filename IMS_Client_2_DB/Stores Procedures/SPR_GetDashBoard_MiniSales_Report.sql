-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <01st Sept 2020>
-- Update date: <04th Sept 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_GetDashBoard_MiniSales_Report 0,2,'2020-09-02','2020-09-02','Dash',''
CREATE PROCEDURE [dbo].[SPR_GetDashBoard_MiniSales_Report]
@index INT=0
,@StoreID INT=0
,@FromDate DATE='0'
,@ToDate DATE='0'
,@ReportType VARCHAR(MAX)='Dash'
,@GenericColumn VARCHAR(MAX)='' OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@index,',',@StoreID,',',@FromDate,',',@ToDate,',',@ReportType)

	IF @index=0 --Employee ( Sales Man)
	BEGIN

		--reportQuery
		SELECT v1.Name AS SalesMan , SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		, SUM(v2.QTY * v2.Rate) AS Rate 
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID
		WHERE v1.ShopeID = @StoreID
		AND v1.InvoiceDate between @FromDate AND @ToDate 
		--AND v2.Rate>0 
		GROUP BY v1.Name
		ORDER BY SUM(v2.QTY * v2.Rate) DESC

		--TotalQTY_Rate
		SELECT SUM(QTY) AS TotalQTY, SUM(Rate) AS TotalRate,SUM(Discount) AS TotalDiscount
		,(SUM(Rate)-SUM(Discount))+ SUM(TAX) AS GrandTotal
		FROM (SELECT v1.Name AS SalesMan , SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
				, SUM(v2.QTY * v2.Rate) AS Rate
				,v1.Discount,v1.Tax AS TAX
				FROM dbo.View_SalesBillDetails v1
				JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID
				WHERE v1.ShopeID = @StoreID AND v1.InvoiceDate between @FromDate AND @ToDate 
				--AND v2.Rate>0
				GROUP BY v1.Name,v1.Discount,v1.Tax
			 ) AS tb

		IF @ReportType='Mini'
		BEGIN

			SET @GenericColumn='Sales Man' --for Mini Sales report

		END

	END

	ELSE IF @index=1 --Color
	BEGIN
	
		--reportQuery
		SELECT  v2.ColorName AS Color  , SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		, SUM(v2.QTY * v2.Rate) AS Rate
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
		WHERE v1.ShopeID = @StoreID 
		AND v1.InvoiceDate between @FromDate AND @ToDate 
		--AND v2.Rate>0 
		GROUP BY v2.ColorName
		ORDER BY SUM(v2.QTY * v2.Rate) DESC

		--TotalQTY_Rate
		SELECT SUM(QTY) AS TotalQTY,SUM(Rate) AS TotalRate,SUM(Discount) AS TotalDiscount
		,(SUM(Rate)-SUM(Discount))+ SUM(TAX) AS GrandTotal
		FROM (SELECT SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
				, SUM(v2.QTY * v2.Rate) AS Rate
				,v1.Discount,v1.Tax AS TAX
				FROM  dbo.View_SalesBillDetails v1
				JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
                WHERE v1.ShopeID = @StoreID AND v1.InvoiceDate between @FromDate AND @ToDate 
				--AND v2.Rate>0 
				GROUP BY v1.Discount,v1.SalesMan,v1.Tax
			  ) AS tb


		IF @ReportType='Mini'
		BEGIN

			SET @GenericColumn='Color' --for Mini Sales report

		END

	END

	ELSE IF @index=2 --Product
	BEGIN
	
		--reportQuery
		SELECT  v2.ProductName AS ItemName, SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		, SUM(v2.QTY * v2.Rate) AS Rate
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
		WHERE v1.ShopeID = @StoreID 
		AND v1.InvoiceDate between @FromDate AND @ToDate 
		--AND v2.Rate>0 
		GROUP BY v2.ProductName
		ORDER BY SUM(v2.QTY * v2.Rate) DESC

		--TotalQTY_Rate

		SELECT SUM(QTY) AS TotalQTY,SUM(Rate) AS TotalRate,SUM(Discount) AS TotalDiscount
		,(SUM(Rate)-SUM(Discount))+ SUM(TAX) AS GrandTotal 
		FROM (SELECT SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
				, SUM(v2.QTY * v2.Rate) AS Rate
				,v1.Discount,v1.Tax AS TAX
				FROM dbo.View_SalesBillDetails v1
				JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
                WHERE v1.ShopeID = @StoreID AND v1.InvoiceDate between @FromDate AND @ToDate 
				--AND v2.Rate>0 
				GROUP BY v1.Discount,v1.Discount,v1.Tax
			  ) AS tb

		IF @ReportType='Mini'
		BEGIN

			SET @GenericColumn='Item Name' --for Mini Sales report

		END

	END

	ELSE IF @index=3 --Invoice/Bill No
	BEGIN
	
		--reportQuery
		SELECT v1.InvoiceNumber AS InvoiceNo, SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		, SUM(v2.QTY * v2.Rate) AS Rate
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
		WHERE v1.ShopeID = @StoreID 
		AND v1.InvoiceDate between @FromDate AND @ToDate 
		--AND v2.Rate>0 
		GROUP BY v1.InvoiceNumber
		ORDER BY SUM(v2.QTY * v2.Rate) DESC

		--TotalQTY_Rate
		SELECT SUM(QTY) AS TotalQTY,SUM(Rate) AS TotalRate,SUM(Discount) AS TotalDiscount
		,(SUM(Rate)-SUM(Discount))+ SUM(TAX) AS GrandTotal 
		FROM (SELECT v1.InvoiceNumber AS InvoiceNo, SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
				, SUM(v2.QTY * v2.Rate) AS Rate
				,v1.Discount,v1.Tax AS TAX
				FROM dbo.View_SalesBillDetails v1
				JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
                WHERE v1.ShopeID = @StoreID AND v1.InvoiceDate between @FromDate AND @ToDate 
				--AND v2.Rate>0 
				GROUP BY v1.InvoiceNumber,v1.Discount,v1.Tax
			  ) AS tb

		IF @ReportType='Mini'
		BEGIN

			SET @GenericColumn='Invoice No' --for Mini Sales report

		END

	END

	ELSE IF @index=4 --Category Department
	BEGIN
	
		--reportQuery
		SELECT (SELECT CategoryName FROM CategoryMaster WHERE CategoryID=v2.CategoryID) AS Category
		,SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		, SUM(v2.QTY * v2.Rate) AS Rate
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
		WHERE v1.ShopeID = @StoreID AND v1.InvoiceDate between @FromDate AND @ToDate
		--AND v2.Rate>0 
		GROUP BY v2.CategoryID
		ORDER BY SUM(v2.QTY * v2.Rate) DESC

		--TotalQTY_Rate
		SELECT SUM(QTY) AS TotalQTY,SUM(Rate) AS TotalRate,SUM(Discount) AS TotalDiscount
		,(SUM(Rate)-SUM(Discount))+ SUM(TAX) AS GrandTotal 
		FROM (SELECT (SELECT CategoryName FROM CategoryMaster WHERE CategoryID=v2.CategoryID) AS Category
				,SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
				, SUM(v2.QTY * v2.Rate) AS Rate
				,v1.Discount,v1.Tax AS TAX
				FROM dbo.View_SalesBillDetails v1 
				JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
				WHERE v1.ShopeID = @StoreID AND v1.InvoiceDate between @FromDate AND @ToDate
				--AND v2.Rate>0 
				GROUP BY v2.CategoryID,v1.Discount,v1.Tax
			  ) AS tb

		IF @ReportType='Mini'
		BEGIN

			SET @GenericColumn='Category' --for Mini Sales report

		END

	END

	ELSE IF @index=5 --Model No/Style No
	BEGIN
	
		--reportQuery
		SELECT v2.ModelNo AS StyleNo, SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
		, SUM(v2.QTY * v2.Rate) AS Rate
		FROM dbo.View_SalesBillDetails v1 
		JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
		WHERE v1.ShopeID = @StoreID 
		AND v1.InvoiceDate between @FromDate AND @ToDate 
		--AND v2.Rate>0 
		GROUP BY v2.ModelNo
		ORDER BY SUM(v2.QTY * v2.Rate) DESC

		--TotalQTY_Rate
		SELECT SUM(QTY) AS TotalQTY,SUM(Rate) AS TotalRate,SUM(Discount) AS TotalDiscount
		,(SUM(Rate)-SUM(Discount))+ SUM(TAX) AS GrandTotal 
		FROM (SELECT SUM((CASE WHEN v2.Rate<0 THEN -v2.QTY WHEN v2.Rate>0 THEN v2.QTY END)) AS QTY
				, SUM(v2.QTY * v2.Rate) AS Rate
				,v1.Discount,v1.Tax AS TAX
				FROM dbo.View_SalesBillDetails v1 
				JOIN dbo.View_SalesDetails v2 ON v1.id = v2.InvoiceID 
				WHERE v1.ShopeID = @StoreID 
				AND v1.InvoiceDate between @FromDate AND @ToDate 
				--AND v2.Rate>0 
				GROUP BY v1.Discount,v1.Tax
			  ) AS tb

		IF @ReportType='Mini'
		BEGIN

			SET @GenericColumn='StyleNo' --for Mini Sales report

		END

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <02nd JULY 2021>
-- Update date: <04th JULY 2021>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_Stock_LocalCost_Report 1
CREATE PROCEDURE [dbo].[SPR_Get_Stock_LocalCost_Report]
@StoreID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@StoreID

	SET NOCOUNT ON;
	
			SELECT CAST(ISNULL(ps.BarcodeNo,0) AS VARCHAR)BarcodeNo,ps.SubProductID
			,cm.ColorName[Color],sz.Size,pwm.ModelNo [StyleNo],pm.ProductID,pm.ProductName [ItemName]
			,pwm.Photo
			,CAST(pwm.LocalCost AS VARCHAR) LocalCost
			--,ISNULL(MAX(CASE sm.StoreID WHEN @StoreID THEN ps.QTY END),0) [QTY]
			--,ISNULL(MAX(CASE sm.StoreID WHEN @StoreID THEN ps.QTY * pwm.LocalCost END),0) [TotalLocalCost]
			,ISNULL(ps.QTY,0) [QTY]
			,ISNULL(ps.QTY * pwm.LocalCost,0) [TotalLocalCost]
			FROM ProductStockColorSizeMaster ps
			INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
			INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
			INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID AND sm.StoreID=@StoreID
			INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
			INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
			INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
			WHERE ps.StoreID=@StoreID
			--GROUP BY ps.BarcodeNo,cm.ColorName,sz.Size,pm.ProductName,pm.ProductID,pwm.LocalCost,pwm.Photo,ps.SubProductID
			--,pwm.ModelNo
			
			UNION

			SELECT CAST('Total' AS VARCHAR) [BarcodeNo],'' SubProductID,'' [Color],'' [Size],
			'' [StyleNo],'' [ProductID],'' [ItemName],'' [LocalCost],'' Photo,SUM(pt.[QTY]) [QTY],SUM(pt.[TotalLocalCost]) [TotalLocalCost]
			FROM (SELECT 
			ISNULL(ps.QTY,0) [QTY]
			,ISNULL(ps.QTY * pwm.LocalCost,0) [TotalLocalCost]
			--ISNULL(MAX(CASE sm.StoreID WHEN @StoreID THEN ps.QTY END),0) [QTY]
			--,ISNULL(MAX(CASE sm.StoreID WHEN @StoreID THEN ps.QTY * pwm.LocalCost END),0) [TotalLocalCost]
			FROM ProductStockColorSizeMaster ps
			INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
			INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
			INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID AND sm.StoreID=@StoreID
			INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
			INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
			INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
			WHERE ps.StoreID=@StoreID
			--GROUP BY ps.BarcodeNo,cm.ColorName,sz.Size,pm.ProductName,pm.ProductID,pwm.LocalCost,pwm.Photo,ps.SubProductID
			--,pwm.ModelNo
			)pt
	
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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <02nd August 2020>
-- Update date: <31th August 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_BranchShorting_Details 1,3,'2020-08-02','2020-08-02'
CREATE PROCEDURE [dbo].[SPR_Get_BranchShorting_Details]
@FromStoreID INT=0
,@ToStoreID INT=0
,@FromDate DATE='0'
,@ToDate DATE='0'
AS
BEGIN

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@FromStoreID,',',@ToStoreID,',',@FromDate,',',@ToDate)
	SET NOCOUNT ON;

	SELECT psm.SubProductID,psm.ProductID,pm.ProductName [ItemName],cm.ColorID,cm.ColorName,sm.SizeID,sm.Size,COUNT(sd.ProductID) [Sold]
	,st.StoreID,st.StoreName,psm.QTY [Branch],psm1.QTY AS [Store],CONVERT(DATE,si.InvoiceDate) [SalesDate],psm.BarcodeNo
	,pwm.ModelNo [Style No],bm.BrandName,pwm.EndUser
	FROM ProductStockColorSizeMaster psm
	INNER JOIN SalesDetails sd ON sd.ProductID=psm.ProductID AND sd.SubProductID=psm.SubProductID
		AND sd.ColorID=psm.ColorID AND sd.SizeID=psm.SizeID
	INNER JOIN SalesInvoiceDetails si ON sd.InvoiceID=si.Id AND si.ShopeID=@ToStoreID
	INNER JOIN ColorMaster cm ON psm.ColorID=cm.ColorID
	INNER JOIN SizeMaster sm ON psm.SizeID=sm.SizeID
	INNER JOIN StoreMaster st ON psm.StoreID=st.StoreID
	INNER JOIN ProductMaster pm ON psm.ProductID=pm.ProductID
	INNER JOIN tblProductWiseModelNo pwm ON psm.ProductID=pwm.ProductID AND psm.SubProductID=pwm.SubProductID
	INNER JOIN BrandMaster bm ON pwm.BrandID=bm.BrandID
	INNER JOIN
	(
		SELECT BarcodeNo,QTY FROM ProductStockColorSizeMaster WITH(NOLOCK) WHERE QTY>0 AND StoreID=@FromStoreID
	)psm1 ON psm.BarcodeNo=psm1.BarcodeNo
	WHERE 
	CONVERT(DATE,si.InvoiceDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)
	AND 
	psm.StoreID=@ToStoreID AND psm.QTY = 0
	GROUP BY psm.SubProductID,psm.ProductID,pm.ProductName,cm.ColorID,cm.ColorName,sm.SizeID,sm.Size,st.StoreID,st.StoreName,psm.QTY
	,psm1.QTY,CONVERT(DATE,si.InvoiceDate),psm.BarcodeNo,pwm.ModelNo,bm.BrandName,pwm.EndUser
	HAVING COUNT(sd.ProductID)>0

	--SELECT a.* 
	--FROM
	--(
	--SELECT psm.SubProductID,psm.ProductID,pm.ProductName [ItemName],cm.ColorID,cm.ColorName,sm.SizeID,sm.Size,COUNT(sd.ProductID) [Sold]
	--,st.StoreID,st.StoreName,psm.QTY [Branch],0 AS [Store],CONVERT(DATE,sd.CreatedOn) [SalesDate],psm.BarcodeNo
	--,pwm.ModelNo [Style No],bm.BrandName,pwm.EndUser
	--FROM ProductStockColorSizeMaster psm
	--INNER JOIN SalesDetails sd ON sd.ProductID=psm.ProductID AND sd.SubProductID=psm.SubProductID
	--	AND sd.ColorID=psm.ColorID AND sd.SizeID=psm.SizeID
	--INNER JOIN SalesInvoiceDetails si ON sd.InvoiceID=si.Id AND si.ShopeID=@ToStoreID
	--INNER JOIN ColorMaster cm ON psm.ColorID=cm.ColorID
	--INNER JOIN SizeMaster sm ON psm.SizeID=sm.SizeID
	--INNER JOIN StoreMaster st ON psm.StoreID=st.StoreID
	--INNER JOIN ProductMaster pm ON psm.ProductID=pm.ProductID
	--INNER JOIN tblProductWiseModelNo pwm ON psm.ProductID=pwm.ProductID AND psm.SubProductID=pwm.SubProductID
	--INNER JOIN BrandMaster bm ON pwm.BrandID=bm.BrandID
	--WHERE 
	--CONVERT(DATE,sd.CreatedOn) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)
	--AND 
	--psm.StoreID=@ToStoreID AND psm.QTY = 0
	--GROUP BY psm.SubProductID,psm.ProductID,pm.ProductName,cm.ColorID,cm.ColorName,sm.SizeID,sm.Size,st.StoreID,st.StoreName,psm.QTY
	--,CONVERT(DATE,sd.CreatedOn),psm.BarcodeNo,pwm.ModelNo,bm.BrandName,pwm.EndUser
	--HAVING COUNT(sd.ProductID)>0

	--UNION

	--SELECT psm.SubProductID,psm.ProductID,pm.ProductName,cm.ColorID,cm.ColorName,sm.SizeID,sm.Size,COUNT(sd.ProductID) [Sold]
	--,st.StoreID,st.StoreName,0 AS [Branch],psm.QTY [Store],Convert(DATE,sd.CreatedOn) [SalesDate],psm.BarcodeNo
	--,pwm.ModelNo [Style No],bm.BrandName,pwm.EndUser
	--FROM ProductStockColorSizeMaster psm
	--INNER JOIN SalesDetails sd ON sd.ProductID=psm.ProductID AND sd.SubProductID=psm.SubProductID
	--	AND sd.ColorID=psm.ColorID AND sd.SizeID=psm.SizeID
	--INNER JOIN SalesInvoiceDetails si ON sd.InvoiceID=si.Id AND si.ShopeID=@ToStoreID
	--INNER JOIN ColorMaster cm ON psm.ColorID=cm.ColorID
	--INNER JOIN SizeMaster sm ON psm.SizeID=sm.SizeID
	--INNER JOIN StoreMaster st ON psm.StoreID=st.StoreID
	--INNER JOIN ProductMaster pm ON psm.ProductID=pm.ProductID
	--INNER JOIN tblProductWiseModelNo pwm ON psm.ProductID=pwm.ProductID AND psm.SubProductID=pwm.SubProductID
	--INNER JOIN BrandMaster bm ON pwm.BrandID=bm.BrandID
	--WHERE 
	--CONVERT(DATE,sd.CreatedOn) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)
	--AND 
	--psm.StoreID=@FromStoreID AND psm.QTY > 0
	--GROUP BY psm.SubProductID,psm.ProductID,pm.ProductName,cm.ColorID,cm.ColorName,sm.SizeID,sm.Size,st.StoreID,st.StoreName,psm.QTY
	--,CONVERT(DATE,sd.CreatedOn),psm.BarcodeNo,pwm.ModelNo,bm.BrandName,pwm.EndUser
	--HAVING COUNT(sd.ProductID)>0
	--)a
	--WHERE a.Store>0

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
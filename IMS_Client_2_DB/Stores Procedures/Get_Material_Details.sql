-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <12th MARCH 2020>
-- Update date:	<11th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_Material_Details 1,NULL,NULL,NULL,NULL
CREATE PROCEDURE [dbo].[Get_Material_Details]
@ProductID INT=0
,@StoreID INT=0
,@BarcodeNo bigint=0
,@ColorID INT=0
,@ModelNo NVARCHAR(100)='0'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	BEGIN TRY
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@ProductID,',',@StoreID,',',@BarcodeNo,',',@ColorID,',',@ModelNo)
	
	IF @ProductID > 0 OR @StoreID > 0 OR @BarcodeNo > 0 OR @ColorID > 0 OR @ModelNo!='0'
	BEGIN

	SELECT pm.ProductID,pm.ProductName [Item],pid1.ModelNo,pm.Rate [Sales Price],pm.Photo,ps.BarcodeNo,pm.CategoryID,cm.CategoryName [Category]
	,ps.StoreID,sm.StoreName [Store],s1.SizeTypeID,c1.ColorName [Color],ps.SizeID,s1.Size,ps.QTY
	FROM ProductMaster pm
	INNER JOIN DeliveryPurchaseBill1 pid1 ON pm.ProductID=pid1.ProductID
	INNER JOIN ProductStockColorSizeMaster ps ON pm.ProductID = ps.ProductID
	INNER JOIN CategoryMaster cm ON pm.CategoryID = cm.CategoryID
	INNER JOIN StoreMaster sm ON ps.StoreID = sm.StoreID
	INNER JOIN ColorMaster c1 ON ps.ColorID = c1.ColorID
	INNER JOIN SizeMaster s1 ON ps.SizeID = s1.SizeID
	INNER JOIN SizeTypeMaster st ON s1.SizeTypeID = st.SizeTypeID
	WHERE pm.ActiveStatus=1
	AND pm.ProductID = ISNULL(@ProductID,pm.ProductID) 
	AND ps.StoreID = ISNULL(@StoreID,ps.StoreID)
	AND ISNULL(ps.BarcodeNo,0) = ISNULL(@BarcodeNo,ISNULL(ps.BarcodeNo,0))
	AND ps.ColorID = ISNULL(@ColorID,ps.ColorID)
	AND ISNULL(pid1.ModelNo,0) = ISNULL(@ModelNo,pid1.ModelNo)
	ORDER BY pm.ProductID,ps.StoreID,s1.SizeTypeID,ps.ColorID

	--SELECT pm.ProductID,pm.ProductName,ps.BarcodeNo,pm.CategoryID,cm.CategoryName [Category]
	--,ps.StoreID,sm.StoreName,s1.SizeTypeID,c1.ColorName,ps.SizeID,s1.Size,ISNULL(ps.QTY, 0)QTY
	--FROM ProductMaster pm
	--LEFT OUTER JOIN ProductStockColorSizeMaster ps ON pm.ProductID = ps.ProductID
	--LEFT OUTER JOIN CategoryMaster cm ON pm.CategoryID = cm.CategoryID
	--LEFT OUTER JOIN StoreMaster sm ON ps.StoreID = sm.StoreID
	--LEFT OUTER JOIN ColorMaster c1 ON ps.ColorID = c1.ColorID
	--LEFT OUTER JOIN SizeMaster s1 ON ps.SizeID = s1.SizeID
	--LEFT OUTER JOIN SizeTypeMaster st ON s1.SizeTypeID = st.SizeTypeID
	--WHERE pm.ProductID = ISNULL(@ProductID,pm.ProductID) 
	--AND ISNULL(ps.StoreID,0) = ISNULL(@StoreID,ISNULL(ps.StoreID,0))
	--AND ISNULL(ps.BarcodeNo,0) = ISNULL(@BarcodeNo,ISNULL(ps.BarcodeNo,0))
	--AND ISNULL(ps.ColorID,0) = ISNULL(@ColorID,ISNULL(ps.ColorID,0))
	--ORDER BY pm.ProductID,ps.StoreID,s1.SizeTypeID,ps.ColorID
	END

	ELSE
	BEGIN
	SELECT TOP 100 pm.ProductID,pm.ProductName,pm.Rate [Sales Price],pm.Photo,ps.BarcodeNo,pm.CategoryID,cm.CategoryName [Category]
	,ps.StoreID,sm.StoreName,s1.SizeTypeID,c1.ColorName,ps.SizeID,s1.Size,ps.QTY
	FROM ProductMaster pm
	INNER JOIN [dbo].[ProductStockColorSizeMaster] ps ON pm.ProductID = ps.ProductID
	INNER JOIN CategoryMaster cm ON pm.CategoryID = cm.CategoryID
	INNER JOIN StoreMaster sm ON ps.StoreID = sm.StoreID
	INNER JOIN ColorMaster c1 ON ps.ColorID = c1.ColorID
	INNER JOIN SizeMaster s1 ON ps.SizeID = s1.SizeID
	INNER JOIN SizeTypeMaster st ON s1.SizeTypeID = st.SizeTypeID
	WHERE pm.ActiveStatus=1
	ORDER BY pm.ProductID,ps.StoreID,s1.SizeTypeID,ps.ColorID
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
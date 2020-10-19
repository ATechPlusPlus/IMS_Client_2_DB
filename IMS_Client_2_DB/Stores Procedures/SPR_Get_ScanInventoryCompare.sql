-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <15th OCT 2020>
-- Update date: <19th OCT 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_ScanInventoryCompare 5
CREATE PROCEDURE [dbo].[SPR_Get_ScanInventoryCompare]
@MasterScanID INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@MasterScanID

	SET NOCOUNT ON;
	
	SELECT bm.BrandName [Brand],sti.ProductID, ps.ProductName [Item],pwm.ModelNo [Style No],sti.Barcode
	,sti.SizeID,sm.Size, sti.ColorID
	, col.ColorName [Color],sti.BillQTY [Inventory QTY],IIF(sti.SystemQTY=0,psm.QTY,sti.SystemQTY) [System QTY]
	,(sti.BillQTY-IIF(sti.SystemQTY=0,psm.QTY,sti.SystemQTY)) [Diff QTY]
	, pwm.EndUser [Rate], ( (sti.BillQTY-IIF(sti.SystemQTY=0,psm.QTY,sti.SystemQTY)) * pwm.EndUser) [Diff Rate]
	, psm.SubProductID,psm.StoreID,stm.StoreName,(sti.BillQTY * pwm.EndUser) [Inventory Rate]
	, (IIF(sti.SystemQTY=0,psm.QTY,sti.SystemQTY) * pwm.EndUser) [System Rate]
	--, 1 [Default]
	FROM tblScanInventoryItemDetails sti
	INNER JOIN tblScanInventoryDetails std ON sti.MasterScanID=std.MasterScanID
	INNER JOIN ProductMaster ps ON sti.ProductID = ps.ProductID
	INNER JOIN ColorMaster col ON sti.ColorID = col.ColorID
	INNER JOIN SizeMaster sm ON sti.SizeID = sm.SizeID
	INNER JOIN ProductStockColorSizeMaster psm ON sti.Barcode = psm.BarcodeNo AND std.StoreID=psm.StoreID
	INNER JOIN tblProductWiseModelNo pwm ON psm.SubProductID=pwm.SubProductID AND psm.ProductID=pwm.ProductID
	INNER JOIN BrandMaster bm ON pwm.BrandID=bm.BrandID
	INNER JOIN StoreMaster stm ON std.StoreID=stm.StoreID
	WHERE sti.MasterScanID = @MasterScanID
	ORDER BY (sti.BillQTY-IIF(sti.SystemQTY=0,psm.QTY,sti.SystemQTY))

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
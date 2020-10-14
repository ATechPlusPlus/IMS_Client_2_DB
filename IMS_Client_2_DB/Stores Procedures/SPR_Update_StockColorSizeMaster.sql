-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <15th OCT 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Update_StockColorSizeMaster '1'
CREATE PROCEDURE [dbo].[SPR_Update_StockColorSizeMaster]
@MasterScanID INT=0
,@StoreID INT=0
,@CreatedBy INT=0
,@Msg VARCHAR(MAX) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@MasterScanID,',',@StoreID,',',@CreatedBy)

	BEGIN TRANSACTION

	SET NOCOUNT ON;
	
	--Updating Scanned child Table
	UPDATE sti
	SET sti.SystemQTY = sti.BillQTY
	,sti.UpdatedBy=@CreatedBy,sti.UpdatedOn=GETDATE()
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

	--Updating Scanned Master Table
	UPDATE tblScanInventoryDetails SET
	CompareStatus=1
	,UpdatedBy=@CreatedBy,UpdatedOn=GETDATE()
	WHERE MasterScanID = @MasterScanID

	--Updating main ProductStockColorsizeMaster Table
	UPDATE psm
	SET psm.QTY = sti.BillQTY
	,psm.UpdatedBy=@CreatedBy,psm.UpdatedOn=GETDATE()
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
	
	SET @Msg='Inventory Updated Successfully.' -- Means Data saved successfully

	COMMIT

	END TRY

	BEGIN CATCH

	ROLLBACK

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
	
	SET @Msg=ERROR_MESSAGE() -- Exception occured

	END CATCH
END
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <14th OCT 2020>
-- Update date: <17th OCT 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_ScanInventoryItemDetails '0'
CREATE PROCEDURE [dbo].[SPR_Get_ScanInventoryItemDetails]
@StoreID INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@StoreID

	SET NOCOUNT ON;
	
	SELECT sti.MasterScanID,sti.ProductID, ps.ProductName, sti.BillQTY,sti.Rate,sti.Total
	,sti.Barcode,sti.SizeID,sm.Size, sti.ColorID
	, col.ColorName,sti.SubProductID
	FROM tblScanInventoryItemDetails sti
	INNER JOIN tblScanInventoryDetails std ON sti.MasterScanID=std.MasterScanID
	INNER JOIN ProductMaster ps ON sti.ProductID = ps.ProductID
	INNER JOIN ColorMaster col ON sti.ColorID = col.ColorID
	INNER JOIN SizeMaster sm ON sti.SizeID = sm.SizeID
	WHERE std.StoreID=@StoreID AND std.CompareStatus=0
	
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
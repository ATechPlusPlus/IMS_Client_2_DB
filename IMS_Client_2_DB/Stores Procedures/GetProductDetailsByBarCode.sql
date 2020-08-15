-- =============================================
-- Author:		<MATEEN>
-- Create date: <10th MAR 2020>
-- Modify date: <31st MAR 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC GetProductDetailsByBarCode 1,1
CREATE PROCEDURE GetProductDetailsByBarCode
@StoreID as int=0
,@BarCode as int=0
,@IsReturn as bit=0

AS
BEGIN
	
	SET NOCOUNT ON;
    BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@StoreID,',',@BarCode,',',@IsReturn)

	if @IsReturn=1 -- if product is returnin then dont consider store ID because it may happen that the product must be return some nearby shope
	begin
		SELECT p1.ProductID, p1.ProductName,pwm.EndUser as Rate,p2.QTY,p2.ColorID,c1.ColorName
		,s1.SizeID, s1.Size,p2.BarcodeNo,p2.SubProductID FROM dbo.ProductMaster p1 
		JOIN dbo.ProductStockColorSizeMaster p2 ON p1.ProductID = p2.ProductID 
		JOIN ColorMaster c1 ON p2.colorID=c1.ColorID 
		JOIN SizeMaster s1 ON p2.SizeID=s1.SizeID
		join tblProductWiseModelNo pwm on pwm.SubProductID=p2.SubProductID
		WHERE  p2.BarcodeNo =@BarCode;
	end
	else 
	begin
		SELECT p1.ProductID, p1.ProductName,pwm.EndUser as Rate,p2.QTY,p2.ColorID,c1.ColorName
		,s1.SizeID, s1.Size,p2.BarcodeNo,p2.SubProductID FROM dbo.ProductMaster p1 
		JOIN dbo.ProductStockColorSizeMaster p2 ON p1.ProductID = p2.ProductID AND p2.StoreID = @StoreID
		JOIN ColorMaster c1 ON p2.colorID=c1.ColorID 
		JOIN SizeMaster s1 ON p2.SizeID=s1.SizeID
		join tblProductWiseModelNo pwm on pwm.SubProductID=p2.SubProductID
		WHERE p2.StoreID = @StoreID 
		AND p2.BarcodeNo =@BarCode;
	end
	

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
-- =============================================
-- Author:		<MATEEN>
-- Create date: <10th MAR 2020>
-- Modify date: <31st MAR 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC GetProductDetails_By_Color_Size 1,19,1
CREATE PROCEDURE [GetProductDetails_By_Color_Size]
@StoreID as int=0,
@SizeID as int=0,
@ColorID as int=0

AS
BEGIN
	
	SET NOCOUNT ON;
    BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@StoreID,',',@SizeID,',',@ColorID)

	SELECT p1.ProductID, p1.ProductName,p1.Rate,p2.QTY,p2.ColorID,c1.ColorName
    ,s1.SizeID, s1.Size,p2.BarcodeNo FROM dbo.ProductMaster p1 
    JOIN dbo.ProductStockColorSizeMaster p2 ON p1.ProductID = p2.ProductID AND p2.StoreID = @StoreID
    JOIN ColorMaster c1 ON p2.ColorID=c1.ColorID 
    JOIN SizeMaster s1 ON p2.SizeID=s1.SizeID
    WHERE p2.StoreID = @StoreID 
    AND p2.ColorID=@ColorID and p2.SizeID=@SizeID

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
-- =============================================
-- Author:		<Mateen KHAN>
-- Create date: <24th MAR 2022>
-- Update date: <29th MAR 2022>
-- Description:	<>
-- =============================================
-- DROP PROCEDURE [dbo].[SPR_BulkPriceUpdate]
CREATE PROCEDURE [dbo].[SPR_BulkPriceUpdate]
@ExcelTable as tblBulkUpdateType READONLY,
@LoginBy AS INT,
@Flag AS INT OUTPUT

AS
BEGIN

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@LoginBy

	BEGIN TRANSACTION

		UPDATE pwm
		SET pwm.EndUser=t3.SalePrice,pwm.UpdatedOn=GETDATE(),pwm.UpdatedBy=@LoginBy
		FROM tblProductWiseModelNo AS pwm
		INNER JOIN View_ModeBrandDetails AS t2 ON pwm.SubProductID=t2.SubProductID
		INNER JOIN @ExcelTable AS t3 ON t2.BrandName=t3.Brand AND t2.ModelNo=t3.StyleNo

		UPDATE psm
		SET psm.Rate=t3.SalePrice,psm.UpdatedOn=GETDATE(),psm.UpdatedBy=@LoginBy
		FROM ProductStockMaster AS psm
		INNER JOIN View_ModeBrandDetails AS t2 ON psm.SubProductID=t2.SubProductID
		INNER JOIN @ExcelTable AS t3 ON t2.BrandName=t3.Brand AND t2.ModelNo=t3.StyleNo

		--UPDATE ProductStockMaster
		-- SET ProductStockMaster.Rate=t3.SalePrice,ProductStockMaster.UpdatedOn=GETDATE(),ProductStockMaster.UpdatedBy=@LoginBy
		--FROM ProductStockMaster AS t1 JOIN (SELECT * FROM  View_ModeBrandDetails ) AS t2
		--ON t1.SubProductID=t2.SubProductID  JOIN 
		--@ExcelTable AS t3 ON (t2.BrandName=t3.Brand AND t2.ModelNo=t3.StyleNo)

		COMMIT
		
		SELECT @Flag=COUNT(1) FROM tblProductWiseModelNo AS pwm
		INNER JOIN View_ModeBrandDetails AS t2 ON pwm.SubProductID=t2.SubProductID
		INNER JOIN @ExcelTable AS t3 ON t2.BrandName=t3.Brand AND t2.ModelNo=t3.StyleNo

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
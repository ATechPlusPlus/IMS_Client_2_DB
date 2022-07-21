-- =============================================
-- Author:		<Mateen KHAN>
-- Create date: <24th MAR 2022>
-- Update date: <21st JULY 2022>
-- Description:	<>
-- =============================================
-- DROP PROCEDURE [dbo].[SPR_BulkPriceUpdate]
CREATE PROCEDURE [dbo].[SPR_BulkPriceUpdate]
@ExcelTable as tblBulkUpdateType READONLY,
@LoginBy AS INT=0,
@Flag AS INT=0 OUTPUT

AS
BEGIN

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @rows INT=0

	SELECT @rows=COUNT(1) FROM @ExcelTable
	SET @PARAMERES=CONCAT(@LoginBy,', Total Rows ',@rows)

	BEGIN TRANSACTION
		
		SELECT @Flag=COUNT(1) FROM tblProductWiseModelNo AS pwm
		INNER JOIN View_ModeBrandDetails AS t2 ON pwm.SubProductID=t2.SubProductID
		INNER JOIN @ExcelTable AS t3 ON t2.BrandName=t3.Brand AND t2.ModelNo=t3.StyleNo

		IF @rows=@Flag 
		BEGIN
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

		SET @Flag=1;
		END

		ELSE --IF @Flag=0
		BEGIN

		select t4.* from @ExcelTable t4
		LEFT JOIN
		(
		SELECT pwm.ModelNo,t3.StyleNo,t3.Brand,pwm.BrandID,t2.BrandName 
		FROM tblProductWiseModelNo AS pwm
		left JOIN View_ModeBrandDetails AS t2 ON ISNULL(pwm.SubProductID,0)=ISNULL(t2.SubProductID,0)
		left JOIN @ExcelTable AS t3 ON ISNULL(t2.BrandName,0)=ISNULL(t3.Brand,0) AND ISNULL(t2.ModelNo,0)=ISNULL(t3.StyleNo,0)
		where t3.StyleNo is not null
		) AS t5
		ON t4.StyleNo=t5.StyleNo AND t4.Brand=t5.Brand
		where t5.ModelNo is null

		END
		
		COMMIT
		
	END TRY

BEGIN CATCH
	SET @Flag=0;
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
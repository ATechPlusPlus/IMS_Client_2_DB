

-- =============================================
-- Author:		<Mateen KHAN>
-- Create date: <24 March 2022>
-- Description:	<>
-- =============================================

create PROCEDURE [dbo].[SPR_BulkPriceUpdate]

@ExcelTable as tblBulkUpdateType READONLY,
@LoginBy as int

AS
BEGIN

	BEGIN TRY

			update ProductStockMaster

		 set ProductStockMaster.Rate=t3.SalePrice 

		from ProductStockMaster as t1 join (select * from  View_ModeBrandDetails ) as t2
		on t1.SubProductID=t2.SubProductID  join 
		@ExcelTable as t3 on (t2.BrandName=t3.Brand AND t2.ModelNo=t3.StyleNo)
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
	,'inserted by [SPR_BulkPriceUpdate] '
	
	END CATCH
	
END
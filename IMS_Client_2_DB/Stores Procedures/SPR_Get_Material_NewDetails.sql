-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <25th JULY 2020>
-- Update date: <26th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_Material_NewDetails 0,1,0
CREATE PROCEDURE [dbo].[SPR_Get_Material_NewDetails]
@BarcodeNo BIGINT=0
,@ProductID INT=0
,@ColorID   INT=0
AS
BEGIN

	SET NOCOUNT ON;

		BEGIN TRY

		DECLARE @PARAMERES VARCHAR(MAX)=''
		DECLARE @query1 VARCHAR(MAX)=''
		DECLARE @query2 VARCHAR(MAX)=''
		
		DECLARE @SumOfQTY VARCHAR(MAX)=''
		DECLARE @TotalStoreQuery1 VARCHAR(MAX)=''
		DECLARE @WHERE VARCHAR(MAX)=''
		
		DECLARE @StoreID INT=0
		DECLARE @StoreName VARCHAR(MAX)=''

		SET @PARAMERES=CONCAT(@BarcodeNo,',',@ProductID,',',@ColorID)
		--BEGIN TRANSACTION

			DECLARE cursor_Store CURSOR
			FOR
			
			SELECT StoreID,StoreName FROM StoreMaster WITH(NOLOCK) WHERE ISNULL(ActiveStatus,0) = 1
	
			OPEN cursor_Store;

			FETCH NEXT FROM cursor_Store INTO @StoreID,@StoreName

				WHILE @@FETCH_STATUS <> -1
				BEGIN

				SET @query1 += 'ISNULL(MAX(CASE WHEN sm.StoreName = '''+@StoreName+
				''' THEN ps.QTY END),0) '+QUOTENAME(@StoreName)+',';
				
				SET @SumOfQTY +='SUM(pt.'+QUOTENAME(@StoreName)+') '+QUOTENAME(@StoreName)+','

				FETCH NEXT FROM cursor_Store INTO @StoreID,@StoreName

				END

			CLOSE cursor_Store;
			DEALLOCATE cursor_Store;
			
			SET @WHERE='WHERE ps.ProductID=IIF('+CAST(@ProductID AS VARCHAR)+'=0,ps.ProductID,'+CAST(@ProductID AS VARCHAR)+')
			AND ISNULL(ps.BarcodeNo,0)=IIF('+CAST(@BarcodeNo AS VARCHAR)+'=0,ISNULL(ps.BarcodeNo,0),'+CAST(@BarcodeNo AS VARCHAR)+')
			AND ps.ColorID=IIF('+CAST(@ColorID AS VARCHAR)+'=0,ps.ColorID,'+CAST(@ColorID AS VARCHAR)+')
			GROUP BY ps.BarcodeNo,cm.ColorName,sz.Size,pm.ProductName,pm.ProductID'

			SET @query2='SELECT CAST(ISNULL(ps.BarcodeNo,0) AS VARCHAR)BarcodeNo,cm.ColorName [Color],sz.Size,pm.ProductID,pm.ProductName [Item Name],
			'+@query1+'
			[Remove],ISNULL(SUM(ps.QTY),0) AS Total FROM ProductStockColorSizeMaster ps
			INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
			INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
			INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
			INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
			'+@WHERE+'
			'
			SET @query2=REPLACE(@query2,',
			[Remove]','')

			--print @query2

			SET @TotalStoreQuery1='UNION 
			SELECT CAST(''Total'' AS VARCHAR) [BarcodeNo],'''' [Color],'''' [Size],'''' [ProductID],'''' [Item Name],'+@SumOfQTY+'SUM(pt.Total) [Total] FROM (SELECT '+@query1+'ISNULL(SUM(ps.QTY),0) AS Total 
			FROM ProductStockColorSizeMaster ps
			INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
			INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
			INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
			INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
			'+@WHERE+'
			)pt'
			--PRINT @TotalStoreQuery1

			EXEC (@query2 + @TotalStoreQuery1)
			--COMMIT
			 
			END TRY
	
			BEGIN CATCH
			--ROLLBACK
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
			,ISNULL(ERROR_PROCEDURE(),'SPR_Get_Material_NewDetails')
			,@PARAMERES

			SELECT -1 AS Flag,ERROR_MESSAGE() AS Msg

			END CATCH
	
			END
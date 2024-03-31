-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <25th JULY 2020>
-- Update date: <31st MARCH 2024>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_Material_NewDetails 0,0,0,'0922-1',0,1
CREATE PROCEDURE [dbo].[SPR_Get_Material_NewDetails]
@BarcodeNo		BIGINT=0
,@ProductID		INT=0
,@ColorID		INT=0
--,@SubProductID  INT=0
,@ModelNo		NVARCHAR(MAX)
,@CategoryID    INT=0
,@IsAdmin		INT=0
AS
BEGIN

	SET NOCOUNT ON;

		BEGIN TRY

		DECLARE @PARAMERES NVARCHAR(MAX)=''
		DECLARE @query1 NVARCHAR(MAX)=''
		DECLARE @query2 NVARCHAR(MAX)=''
		DECLARE @queryEndUser NVARCHAR(MAX)=''
		
		DECLARE @SumOfQTY NVARCHAR(MAX)=''
		DECLARE @SumOfQTYEndUser NVARCHAR(MAX)=''
		DECLARE @TotalStoreQuery1 NVARCHAR(MAX)=''
		DECLARE @WHERE VARCHAR(MAX)=''
		
		DECLARE @Comma NVARCHAR(MAX)=''
		DECLARE @StoreID INT=0
		DECLARE @StoreName NVARCHAR(MAX)=''
		DECLARE @i INT=0

		SET @PARAMERES=CONCAT(@BarcodeNo,',',@ProductID,',',@ColorID,',',@ModelNo,',',@CategoryID,',',@IsAdmin)
		--BEGIN TRANSACTION

			DECLARE cursor_Store CURSOR
			FOR
			
			SELECT StoreID,StoreName 
			FROM StoreMaster WITH(NOLOCK) WHERE ISNULL(ActiveStatus,0) = 1
	
			OPEN cursor_Store;

			FETCH NEXT FROM cursor_Store INTO @StoreID,@StoreName

				WHILE @@FETCH_STATUS <> -1
				BEGIN

				SET @query1 +=@Comma+'ISNULL(MAX(CASE sm.StoreID WHEN '+CAST(@StoreID AS VARCHAR)+
				' THEN ps.QTY END),0) '+QUOTENAME(@StoreName)

				SET @queryEndUser+=@Comma+'ISNULL(MAX(CASE sm.StoreID WHEN '+CAST(@StoreID AS VARCHAR)+
				' THEN ps.QTY * pwm.EndUser END),0) '+QUOTENAME(CONCAT(@StoreName,' Rate'))
				
				SET @SumOfQTY +=@Comma+'SUM(pt.'+QUOTENAME(@StoreName)+') '+QUOTENAME(@StoreName)

				SET @SumOfQTYEndUser+=@Comma+'SUM(pt.'+QUOTENAME(CONCAT(@StoreName,' Rate'))+') '+QUOTENAME(CONCAT(@StoreName,' Rate'))

				FETCH NEXT FROM cursor_Store INTO @StoreID,@StoreName
				
					IF @@FETCH_STATUS <> -1 BEGIN				
					SET @Comma=','
					END
			
				END

			CLOSE cursor_Store;
			DEALLOCATE cursor_Store;
			
			IF @IsAdmin=1 
			BEGIN
				SET @query1+=',ISNULL(SUM(ps.QTY),0) AS Total,'+@queryEndUser+',ISNULL(SUM(ps.QTY * pwm.EndUser),0) AS [TotalRate]'
				SET @SumOfQTY+=',SUM(pt.Total) [Total],'+@SumOfQTYEndUser+',SUM(pt.TotalRate) [TotalRate]'
			END

			ELSE
			BEGIN
				SET @query1+=',ISNULL(SUM(ps.QTY),0) AS Total'
				SET @SumOfQTY+=',SUM(pt.Total) [Total]'
			END
--AND pwm.ModelNo LIKE IIF('''+CAST(@ModelNo AS NVARCHAR)+'''=''0'',pwm.ModelNo+''%'','''+CAST(@ModelNo AS NVARCHAR)+'%'')
			SET @WHERE='WHERE ps.ProductID=IIF('+CAST(@ProductID AS VARCHAR)+'=0,ps.ProductID,'+CAST(@ProductID AS VARCHAR)+')
			AND ISNULL(ps.BarcodeNo,0)=IIF('+CAST(@BarcodeNo AS VARCHAR)+'=0,ISNULL(ps.BarcodeNo,0),'+CAST(@BarcodeNo AS VARCHAR)+')
			AND ps.ColorID=IIF('+CAST(@ColorID AS VARCHAR)+'=0,ps.ColorID,'+CAST(@ColorID AS VARCHAR)+')
			AND pwm.ModelNo=IIF('''+CAST(@ModelNo AS NVARCHAR)+'''=''0'',pwm.ModelNo,'''+CAST(@ModelNo AS NVARCHAR)+''')
			--AND pwm.ModelNo=IIF('''+CAST(@ModelNo AS NVARCHAR)+'''=''0'',pwm.ModelNo,'''+CAST(@ModelNo AS NVARCHAR)+''')
			AND cat.CategoryID=IIF('+CAST(@CategoryID AS VARCHAR)+'=0,cat.CategoryID,'+CAST(@CategoryID AS VARCHAR)+')
			GROUP BY ps.BarcodeNo,cm.ColorName,sz.Size,pm.ProductName,pm.ProductID,pwm.EndUser,pwm.Photo,ps.SubProductID,pwm.ModelNo'

			SET @query2='SELECT CAST(ISNULL(ps.BarcodeNo,0) AS VARCHAR)BarcodeNo,ps.SubProductID
			,cm.ColorName[Color],sz.Size,pwm.ModelNo [Style No],pm.ProductID,pm.ProductName [Item Name]
			,CAST(pwm.EndUser AS VARCHAR)[EndUser],pwm.Photo,
			'+@query1+'
			FROM ProductStockColorSizeMaster ps
			INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
			INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
			INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
			INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
			INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
			INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
			'+@WHERE+'
			'
			--SET @query2=REPLACE(@query2,',
			--[Remove]','')

			--print @query2

			SET @TotalStoreQuery1='UNION 
			SELECT CAST(''Total'' AS VARCHAR) [BarcodeNo],'''' SubProductID,'''' [Color],'''' [Size],
			'''' [Style No],'''' [ProductID],'''' [Item Name],'''' [EndUser],'''' Photo,'+@SumOfQTY+'
			FROM (SELECT '+@query1+' 
			FROM ProductStockColorSizeMaster ps
			INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
			INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
			INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
			INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
			INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
			INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
			'+@WHERE+'
			)pt ORDER BY pwm.ModelNo'
			
			--PRINT @query2 + @TotalStoreQuery1
			EXEC (@query2 + @TotalStoreQuery1)
			 
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
			,ISNULL(ERROR_PROCEDURE(),'SPR_Get_Material_NewDetails')
			,@PARAMERES

			SELECT -1 AS Flag,ERROR_MESSAGE() AS Msg

			END CATCH
	
			END
-- =============================================
-- Author:  <AAMIR KHAN>
-- Create date: <21st MAR 2021>
-- Update date: <22nd JAN 2025>
-- Description: <>
-- =============================================
--EXEC SPR_Get_ItemCard_Material_Details 0,'B-1'
CREATE PROCEDURE [dbo].[SPR_Get_ItemCard_Material_Details]
@BarCode BIGINT=0
,@ModelNo NVARCHAR(MAX)='0'
,@SubProductID INT=0
--,@ProductID INT=0

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

  SET @PARAMERES=CONCAT(@BarCode,',',@ModelNo,',',@SubProductID)
  --BEGIN TRANSACTION

   DECLARE cursor_Store CURSOR
   FOR

   SELECT StoreID,StoreName
   FROM StoreMaster WITH(NOLOCK) WHERE ISNULL(ActiveStatus,0) = 1

   OPEN cursor_Store;

   FETCH NEXT FROM cursor_Store INTO @StoreID,@StoreName

    WHILE @@FETCH_STATUS <> -1
    BEGIN

    SET @query1 += @Comma+'ISNULL(MAX(CASE sm.StoreID WHEN '+CAST(@StoreID AS VARCHAR)+
    ' THEN ps.QTY END),0) '+QUOTENAME(@StoreName)

    SET @queryEndUser+=@Comma+'ISNULL(MAX(CASE sm.StoreID WHEN '+CAST(@StoreID AS VARCHAR)+
    ' THEN ps.QTY * pwm.EndUser END),0) '+QUOTENAME(CONCAT(@StoreName,' Rate'))

    SET @SumOfQTY +=@Comma+'SUM(pt.'+QUOTENAME(@StoreName)+') '+QUOTENAME(@StoreName)

    SET @SumOfQTYEndUser+=@Comma+'SUM(pt.'+QUOTENAME(CONCAT(@StoreName,' Rate'))+') '+QUOTENAME(CONCAT(@StoreName,' Rate'))

    IF @@FETCH_STATUS <> -1 BEGIN
    SET @Comma=','
    END

    FETCH NEXT FROM cursor_Store INTO @StoreID,@StoreName

    END

   CLOSE cursor_Store;
   DEALLOCATE cursor_Store;


    SET @query1+=',ISNULL(SUM(ps.QTY),0) AS Total'
    SET @SumOfQTY+=',SUM(pt.Total) [Total]'


   SET @WHERE='WHERE ISNULL(ps.BarcodeNo,0)=IIF('+CAST(@BarCode AS VARCHAR)+'=0,ISNULL(ps.BarcodeNo,0),'
   +CAST(@BarCode AS VARCHAR)+')
   --AND pwm.ModelNo LIKE IIF('''+CAST(@ModelNo AS NVARCHAR)+'''=''0'',pwm.ModelNo+''%'','''+CAST(@ModelNo AS NVARCHAR)+'%'')
   AND pwm.ModelNo=IIF('''+CAST(@ModelNo AS NVARCHAR)+'''=''0'',pwm.ModelNo,'''+CAST(@ModelNo AS NVARCHAR)+''')
   AND ISNULL(ps.SubProductID,0)=IIF('+CAST(@SubProductID AS VARCHAR)+'=0,ISNULL(ps.SubProductID,0),'
   +CAST(@SubProductID AS VARCHAR)+')
   GROUP BY ps.BarcodeNo,cm.ColorName,sz.Size,pm.ProductName,pm.ProductID,pwm.EndUser,pwm.Photo,ps.SubProductID,pwm.ModelNo'

   SET @query2='SELECT ps.SubProductID
   ,cm.ColorName [Color],sz.Size,pwm.ModelNo [Style No],pm.ProductID,pm.ProductName [Item Name],
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
   SELECT '''' SubProductID,CAST(''Total'' AS VARCHAR) [Color],'''' [Size],
   '''' [Style No],'''' [ProductID],'''' [Item Name],'+@SumOfQTY+'
   FROM (SELECT '+@query1+'
   FROM ProductStockColorSizeMaster ps
   INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
   INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
   INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
   INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
   INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
   INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
   '+@WHERE+'
   )pt'

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
   ,ISNULL(ERROR_PROCEDURE(),'SPR_Get_ItemCard_Material_Details')
   ,@PARAMERES

   SELECT -1 AS Flag,ERROR_MESSAGE() AS Msg

   END CATCH

   END
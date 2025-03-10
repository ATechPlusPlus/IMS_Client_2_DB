﻿-- =============================================
-- Author:  <AAMIR KHAN>
-- Create date: <21th MARCH 2021>
-- Update date: <22nd JAN 2025>
-- Description: <Description,,>
-- =============================================
--EXEC SPR_Get_ItemCard_Details 38414,'0'
--EXEC SPR_Get_ItemCard_Details 0,'B-1'
CREATE PROCEDURE [dbo].[SPR_Get_ItemCard_Details]
@BarCode BIGINT=0
,@ModelNo NVARCHAR(MAX)='0'
--,@ProductID INT=0

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 BEGIN TRY
 DECLARE @PARAMERES VARCHAR(MAX)=''
 DECLARE @InvoiceDate DATE='1900-01-01'
 DECLARE @SoldQTY INT=0

 SET @PARAMERES=CONCAT(@BarCode,',',@ModelNo)

 SET NOCOUNT ON;

 IF @ModelNo = '0'
 BEGIN

  --SELECT @InvoiceDate=CONVERT(DATE,MAX(si.InvoiceDate)) ,@SoldQTY=SUM(sd.QTY)
  --FROM SalesInvoiceDetails si
  --INNER JOIN View_SalesDetails sd ON si.Id=sd.InvoiceID
  --WHERE sd.BarcodeNo=@BarCode AND si.OldInvoiceID=0

  SELECT CONVERT(DATE,MAX(si.InvoiceDate)) AS InvoiceDate ,SUM(sd.QTY) AS SoldQTY,  sd.SubProductID
   INTO #TempSales FROM SalesInvoiceDetails si
   INNER JOIN View_SalesDetails sd ON si.Id=sd.InvoiceID
   WHERE  sd.BarcodeNo=@BarCode AND si.OldInvoiceID=0
   GROUP BY sd.SubProductID

   SELECT DISTINCT t.SubProductID,t.ProductID,t.[Item Name],t.[Style No],t.BrandName,SUM(t.QTY) QTY
   ,t.EndUser,t.LocalCost--,@InvoiceDate InvoiceDate,ISNULL(@SoldQTY,0) SoldQTY
   ,t.InvoiceDate,t.SoldQTY
   FROM
   (
   SELECT CAST(ISNULL(ps.BarcodeNo,0) AS VARCHAR)BarcodeNo,ps.SubProductID
   ,cm.ColorName[Color],sz.Size,pwm.ModelNo [Style No],bm.BrandName,pm.ProductID,pm.ProductName [Item Name]
   ,CAST(pwm.EndUser AS VARCHAR)[EndUser],pwm.LocalCost,pwm.Photo,ps.QTY,ts.InvoiceDate,ISNULL(ts.SoldQTY,0)SoldQTY
   FROM ProductStockColorSizeMaster ps
   INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
   INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
   INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
   INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
   INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
   INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
   INNER JOIN BrandMaster bm ON pwm.BrandID=bm.BrandID
   LEFT JOIN #TempSales ts ON pwm.SubProductID=ts.SubProductID
   )t
   WHERE t.BarcodeNo = @BarCode
   GROUP BY t.SubProductID,t.ProductID,t.[Item Name],t.[Style No],t.BrandName,t.EndUser,t.LocalCost,t.InvoiceDate,t.SoldQTY

 END

 ELSE
 BEGIN

   --SELECT TOP 1 @InvoiceDate=CONVERT(DATE,MAX(si.InvoiceDate)) ,@SoldQTY=SUM(sd.QTY)
   --FROM SalesInvoiceDetails si
   --INNER JOIN View_SalesDetails sd ON si.Id=sd.InvoiceID
   --WHERE  si.OldInvoiceID=0 AND sd.ModelNo = ''+@ModelNo+''

   SELECT CONVERT(DATE,MAX(si.InvoiceDate)) AS InvoiceDate ,SUM(sd.QTY) AS SoldQTY,  sd.SubProductID
   INTO #TempSale FROM SalesInvoiceDetails si
   INNER JOIN View_SalesDetails sd ON si.Id=sd.InvoiceID
   WHERE  si.OldInvoiceID=0 AND sd.ModelNo = ''+@ModelNo+''
   GROUP BY sd.SubProductID

   --SELECT TOP 1 t.SubProductID,t.ProductID,t.[Item Name],t.[Style No],t.BrandName,SUM(t.QTY) QTY
   SELECT DISTINCT t.SubProductID,t.ProductID,t.[Item Name],t.[Style No],t.BrandName,SUM(t.QTY) QTY
   ,t.EndUser,t.LocalCost--,@InvoiceDate InvoiceDate,ISNULL(@SoldQTY,0) SoldQTY
   ,t.InvoiceDate,t.SoldQTY
   FROM
   (
   SELECT CAST(ISNULL(ps.BarcodeNo,0) AS VARCHAR)BarcodeNo,ps.SubProductID
   ,cm.ColorName[Color],sz.Size,pwm.ModelNo [Style No],bm.BrandName,pm.ProductID,pm.ProductName [Item Name]
   ,CAST(pwm.EndUser AS VARCHAR)[EndUser],pwm.LocalCost,pwm.Photo,ps.QTY,ts.InvoiceDate,ISNULL(ts.SoldQTY,0)SoldQTY
   FROM ProductStockColorSizeMaster ps
   INNER JOIN ProductMaster pm ON ps.ProductID=pm.ProductID
   INNER JOIN CategoryMaster cat ON pm.CategoryID=cat.CategoryID
   INNER JOIN StoreMaster sm ON ps.StoreID=sm.StoreID
   INNER JOIN ColorMaster cm ON ps.ColorID=cm.ColorID
   INNER JOIN SizeMaster sz ON ps.SizeID=sz.SizeID
   INNER JOIN tblProductWiseModelNo pwm ON ps.SubProductID=pwm.SubProductID AND ps.ProductID=pwm.ProductID
   INNER JOIN BrandMaster bm ON pwm.BrandID=bm.BrandID
   LEFT JOIN #TempSale ts ON pwm.SubProductID=ts.SubProductID
   )t
   --WHERE t.[Style No] LIKE ''+@ModelNo+'%'
   WHERE t.[Style No] = ''+@ModelNo+''
   GROUP BY t.SubProductID,t.ProductID,t.[Item Name],t.[Style No],t.BrandName,t.EndUser,t.LocalCost,t.InvoiceDate,t.SoldQTY

 END

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
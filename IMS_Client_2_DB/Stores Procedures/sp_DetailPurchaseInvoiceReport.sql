

Create PROCEDURE sp_DetailPurchaseInvoiceReport
	
	@BillNo as nvarchar(50)
AS
BEGIN
	
	
select PurchaseInvoiceID,SupplierBillNo,ShipmentNo,
(select distinct SupplierName from SupplierMaster where SupplierID=p1.SupplierID) as Supplier,
BillDate,IsInvoiceDone,TotalQTY,BillValue,Discount,ForeignExp,GrandTotal,LocalValue,LocalExp,LocalValue
 from [dbo].[PurchaseInvoice] as p1 where p1.PurchaseInvoiceID=@BillNo



  select PurchaseInvoiceID, 
 (select distinct  item.ProductName from ProductMaster as item where item.ProductID=p1.ProductID) as Item,ModelNo,
 (select distinct BrandName from BrandMaster as b where b.BrandID=p1.BrandID) as Brand,
 QTY,Rate,Sales_Price,AddedRatio,SuppossedPrice
  from [dbo].[PurchaseInvoiceDetails] as p1 where  p1.PurchaseInvoiceID=@BillNo



    select PurchaseInvoiceID,
   (select distinct  item.ProductName from ProductMaster as item where item.ProductID=p1.ProductID) as [Item Name],ModelNo,
   (select distinct StoreName from StoreMaster as S1 where S1.StoreID=p1.StoreID) as StoreName,
   BarcodeNo, 
   (select distinct ColorName from ColorMaster where ColorID=p1.ColorID) as Color,
   (select distinct SizeID from SizeMaster where SizeID=p1.SizeID) as Size,
   ModelNo, QTY, Rate

   from [dbo].[ProductStockMaster] as p1 where p1.PurchaseInvoiceID=@BillNo



END
GO

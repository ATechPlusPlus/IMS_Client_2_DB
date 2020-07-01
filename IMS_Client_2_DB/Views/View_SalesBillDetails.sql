CREATE VIEW [dbo].[View_SalesBillDetails]
	AS 

	select s1.id, s1.InvoiceNumber,Convert(date,s1.InvoiceDate) as InvoiceDate ,s1.SubTotal, s1.Discount,s1.Tax, s1.GrandTotal,s1.SalesMan, s1.ShopeID, e1.Name,s2.StoreName from SalesInvoiceDetails s1 Left join EmployeeDetails e1 on s1.SalesMan = e1.empID left join StoreMaster s2 on s1.ShopeID = s2.StoreID

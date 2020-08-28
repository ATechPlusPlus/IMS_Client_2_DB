CREATE VIEW [View_SalesBillDetails]
	AS 

	SELECT s1.id, s1.InvoiceNumber,CONVERT(DATE,s1.InvoiceDate) AS InvoiceDate ,s1.SubTotal,
	s1.Discount,s1.Tax, s1.GrandTotal,s1.SalesMan, s1.ShopeID, e1.[Name],s2.StoreName 
	FROM SalesInvoiceDetails s1
	LEFT JOIN EmployeeDetails e1 ON s1.SalesMan = e1.empID
	LEFT JOIN StoreMaster s2 ON s1.ShopeID = s2.StoreID
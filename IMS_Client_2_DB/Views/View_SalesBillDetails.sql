CREATE VIEW [View_SalesBillDetails]
	AS 

SELECT s1.Id, s1.InvoiceNumber, CONVERT(DATE, s1.InvoiceDate) AS InvoiceDate
, s1.SubTotal, s1.Discount, s1.Tax, s1.GrandTotal,t.TotalQTY,s1.VoucherNo
, s1.SalesMan, s1.ShopeID, e1.[Name], e1.MonthlySalary, s2.StoreName
FROM dbo.SalesInvoiceDetails AS s1 
	INNER JOIN
	(
	SELECT SUM(QTY) AS TotalQTY,InvoiceID
	FROM dbo.SalesDetails WITH(nolock)
	GROUP BY InvoiceID
	)t ON s1.Id=t.InvoiceID
INNER JOIN dbo.StoreMaster AS s2 ON s1.ShopeID = s2.StoreID
LEFT OUTER JOIN dbo.EmployeeDetails AS e1 ON s1.SalesMan = e1.EmpID
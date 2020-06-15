CREATE TABLE [dbo].[SalesInvoiceDetails]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [InvoiceNumber] NVARCHAR(50) NULL, 
    [InvoiceDate] DATETIME NULL, 
    [CustomerID] INT NULL, 
    [SalesMan] INT NULL, 
    [ShopeID] INT NULL,
    [SubTotal] DECIMAL(18, 2) NULL, 
    [Discount] DECIMAL(18, 2) NULL, 
    [Tax] DECIMAL(18, 2) NULL, 
    [GrandTotal] DECIMAL(18, 2) NULL, 
    [PaymentMode] NVARCHAR(50) NULL, 
    [PaymentAutoID] NVARCHAR(50) NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_SalesInvoiceDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_SalesInvoiceDetails_CreatedOn]  DEFAULT (getdate()),
    [UpdatedBy] INT NULL, 
    [UpdatedOn] DATETIME NULL
)

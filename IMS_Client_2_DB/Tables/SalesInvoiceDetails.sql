﻿CREATE TABLE [dbo].[SalesInvoiceDetails]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [InvoiceNumber] NVARCHAR(50) NOT NULL, 
    [InvoiceDate] DATETIME NOT NULL, 
    [CustomerID] INT NOT NULL, 
    [SalesMan] INT NOT NULL, 
    [ShopeID] INT NOT NULL,
    [SubTotal] DECIMAL(18, 2) NOT NULL DEFAULT 0, 
    [Discount] DECIMAL(18, 2) NOT NULL DEFAULT 0, 
    [Tax] DECIMAL(18, 2) NOT NULL DEFAULT 0, 
    [GrandTotal] DECIMAL(18, 2) NOT NULL DEFAULT 0, 
    [PaymentMode] NVARCHAR(50) NULL, 
    [PaymentAutoID] NVARCHAR(50) NULL,
    [OldInvoiceID] INT NULL,
    CashTendered decimal(18, 2) Null,
    Change decimal(18, 2) NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_SalesInvoiceDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_SalesInvoiceDetails_CreatedOn]  DEFAULT (getdate()),
    [UpdatedBy] INT NULL, 
    [UpdatedOn] DATETIME NULL, 
 
)

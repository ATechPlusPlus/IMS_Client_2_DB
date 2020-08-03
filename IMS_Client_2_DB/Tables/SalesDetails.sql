CREATE TABLE [dbo].[SalesDetails]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [InvoiceID] INT NOT NULL, 
    [ProductID] INT NOT NULL, 
    [SubProductID] INT NOT NULL,
    [ColorID] INT NOT NULL, 
    [SizeID] INT NOT NULL,
    [BarCode] NVARCHAR(50) NOT NULL,
    [QTY] INT NOT NULL,
    [Rate] DECIMAL(18, 2) NOT NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_SalesDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_SalesDetails_CreatedOn]  DEFAULT (getdate()),
    [UpdatedBy] INT NULL, 
    [UpdatedOn] DATETIME NULL
)

CREATE TABLE [dbo].[SalesDetails]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [InvoiceID] INT NULL, 
    [ProductID] INT NULL, 
    [SubtProductID] INT NULL, 
    [BarCode] NVARCHAR(50) NULL, 
    [QTY] INT NULL,
    [Rate] DECIMAL(18, 2) NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_SalesDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_SalesDetails_CreatedOn]  DEFAULT (getdate()),
    [UpdatedBy] INT NULL, 
    [UpdatedOn] DATETIME NULL, 
    [ColorID] INT NULL, 
    [SizeID] INT NULL 
)

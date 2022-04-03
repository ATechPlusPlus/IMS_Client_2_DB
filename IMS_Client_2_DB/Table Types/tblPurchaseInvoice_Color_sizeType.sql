CREATE TYPE [dbo].[tblPurchaseInvoice_Color_sizeType] AS TABLE(
	[PurchaseInvoiceID] [int] NULL,
	[ColorID] [int] NULL,
	[ProductID] [int] NULL,
	[SubProductID] [int] NULL,
	[QTY] [int] NULL,
	[SizeID] [int] NULL,
	[ModelNo] [nvarchar](max) NULL,
	[StoreID] [int] NULL
)
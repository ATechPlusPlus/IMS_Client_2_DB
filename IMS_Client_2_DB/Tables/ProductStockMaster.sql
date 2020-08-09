CREATE TABLE [dbo].[ProductStockMaster](
	[ProductStockID] [bigint] IDENTITY(1,1) NOT NULL,
	[PurchaseInvoiceID] [int] NULL,
	[StoreTransferID] [int] NULL,
	[ProductID] [int] NOT NULL,
	[SubProductID] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[BarcodeNo] [bigint] NULL,
	[ColorID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[ModelNo] [nvarchar](50) NOT NULL,
	[QTY] [int] NOT NULL,
	[Rate] [decimal](18, 3) NULL,
	[PrintCount] [int] NULL DEFAULT 0,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_ProductStockMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_ProductStockMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_ProductStockMaster] PRIMARY KEY CLUSTERED 
(
	[ProductStockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblProductStockLogData](
	[ProductStockLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[sstatus] [varchar](200) NULL,
	[PurchaseInvoiceID] [int] NULL,
	[ProductID] [int] NULL,
	[SubProductID] [int] NULL,
	[StoreID] [int] NULL,
	[ColorID] [int] NULL,
	[SizeID] [int] NULL,
	[QTY] [int] NULL,
	[OldQTY] [int] NULL,
	[BarcodeNo] [bigint] NULL,
	[CreatedBy] [int] NOT NULL DEFAULT 0,
	[CreatedOn] [datetime] NOT NULL DEFAULT getdate(),
 CONSTRAINT [PK_tblProductStockLogData] PRIMARY KEY CLUSTERED 
(
	[ProductStockLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
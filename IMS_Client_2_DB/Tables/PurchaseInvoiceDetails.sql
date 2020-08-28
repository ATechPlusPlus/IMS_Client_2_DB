CREATE TABLE [dbo].[PurchaseInvoiceDetails](
	[PurchaseInvoiceDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseInvoiceID] [int] NOT NULL,
	[SupplierBillNo] [varchar](50) NULL,
	[SubProductID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ModelNo] [nvarchar](50) NOT NULL,
	[BrandID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[QTY] [int] NOT NULL,
	[Rate] [decimal](18, 3) NOT NULL,
	[BillDate] [date] NOT NULL,
	[Sales_Price] [decimal](18, 3) NOT NULL DEFAULT 0,
	[AddedRatio] [int] NOT NULL DEFAULT 0,
	[SuppossedPrice] [decimal](18, 3) NOT NULL DEFAULT 0,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_PurchaseInvoiceDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_PurchaseInvoiceDetails_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_PurchaseInvoiceDetails] PRIMARY KEY CLUSTERED 
(
	[PurchaseInvoiceDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
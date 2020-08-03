CREATE TABLE [dbo].[PurchaseInvoice](
	[PurchaseInvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierBillNo] [varchar](50) NULL,
	[ShipmentNo] [varchar](50) NULL,
	[SupplierID] [int] NOT NULL,
	[BillDate] [date] NOT NULL,
	[IsInvoiceDone] [bit] NOT NULL CONSTRAINT [DF_PurchaseInvoice_IsInvoiceDone]  DEFAULT ((0)),
	[TotalQTY] [int] NOT NULL,
	[BillValue] [decimal](18, 2) NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL DEFAULT 0,
	[ForeignExp] [decimal](18, 2) NOT NULL DEFAULT 0,
	[GrandTotal] [decimal](18, 2) NOT NULL DEFAULT 0,
	[LocalValue] [decimal](18, 2) NOT NULL DEFAULT 0,
	[LocalExp] [decimal](18, 2) NOT NULL DEFAULT 0,
	[LocalBillValue] [decimal](18, 2) NOT NULL DEFAULT 0,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_PurchaseInvoice_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_PurchaseInvoice_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_PurchaseInvoice] PRIMARY KEY CLUSTERED 
(
	[PurchaseInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
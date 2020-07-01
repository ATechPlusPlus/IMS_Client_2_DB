CREATE TABLE [dbo].[PostingDeliveryEntry](
	[PostingDeliveredID] [int] IDENTITY(1,1) NOT NULL,
	[EntryType] [int] NOT NULL,
	[PurchaseInvoiceID] [int] NULL,
	[SupplierBillNo] [varchar](50) NOT NULL,
	[StoreID] [int] NOT NULL,
	[PostingStatus] [bit] NOT NULL CONSTRAINT [DF_PostingDeliveryEntry_PostingStatus]  DEFAULT ((1)),
	[TotalQTY] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_PostingDeliveryEntry_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_PostingDeliveryEntry_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_PostingDeliveryEntry] PRIMARY KEY CLUSTERED 
(
	[PostingDeliveredID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
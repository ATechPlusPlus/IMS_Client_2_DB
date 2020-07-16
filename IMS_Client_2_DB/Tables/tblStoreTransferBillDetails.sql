CREATE TABLE [dbo].[tblStoreTransferBillDetails](
	[StoreTransferID] [int] IDENTITY(1,1) NOT NULL,
	[BillNo] [nvarchar](50) NULL,
	[FromStore] [int] NULL,
	[ToStore] [int] NULL,
	[TotalQTY] [int] NULL,
	[BillStatus] [nvarchar](50) NULL,
	[BillDate] [date] NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_tblStoreTransferBillDetails_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_tblStoreTransferBillDetails] PRIMARY KEY CLUSTERED 
(
	[StoreTransferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
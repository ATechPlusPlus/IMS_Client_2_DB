CREATE TABLE [dbo].[tblStoreTransferBillDetails](
	[StoreTransferID] [int] IDENTITY(1,1) NOT NULL,
	[BillNo] [nvarchar](50) NOT NULL,
	[FromStore] [int] NOT NULL,
	[ToStore] [int] NOT NULL,
	[TotalQTY] [int] NOT NULL,
	[BillStatus] [nvarchar](50) NOT NULL,
	[BillDate] [date] NOT NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblStoreTransferBillDetails_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL DEFAULT 0,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_tblStoreTransferBillDetails] PRIMARY KEY CLUSTERED 
(
	[StoreTransferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
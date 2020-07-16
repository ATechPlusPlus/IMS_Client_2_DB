CREATE TABLE [dbo].[tblStoreTransferReceiveBillDetails](
	[StoreTransferReceiveID] [int] IDENTITY(1,1) NOT NULL,
	[ReceiveBillNo] [nvarchar](50) NULL,
	[StoreTransferID] [int] NULL,
	[TotalQTY] [int] NULL,
	[ReceiveBillStatus] [nvarchar](50) NULL,
	[ReceiveBillDate] [date] NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblStoreTransferReceiveBillDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblStoreTransferReceiveBillDetails_CreatedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_tblStoreTransferReceiveBillDetails] PRIMARY KEY CLUSTERED 
(
	[StoreTransferReceiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
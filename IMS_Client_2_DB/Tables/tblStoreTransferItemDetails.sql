CREATE TABLE [dbo].[tblStoreTransferItemDetails](
	[TransferItemID] [int] IDENTITY(1,1) NOT NULL,
	[StoreBillDetailsID] [int] NULL,
	[ProductID] [int] NULL,
	[Barcode] [nvarchar](50) NULL,
	[Rate] [decimal](18, 3) NULL,
	[BillQTY] [int] NULL,
	[EnterQTY] [int] NULL,
	[ColorID] [int] NULL,
	[SizeID] [int] NULL,
	[Total] [decimal](18, 3) NULL,
	[StoreTransferReceiveID] [int] NULL,
	[ReceiveBillQTYStatus] [bit] NULL CONSTRAINT [DF_tblStoreTransferItemDetails_ReceiveBillQTYStatus]  DEFAULT ((0)),
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_tblStoreTransferItemDetails_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblStoreTransferItemDetails] PRIMARY KEY CLUSTERED 
(
	[TransferItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
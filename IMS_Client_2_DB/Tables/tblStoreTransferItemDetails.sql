CREATE TABLE [dbo].[tblStoreTransferItemDetails](
	[TransferItemID] [int] IDENTITY(1,1) NOT NULL,
	[StoreBillDetailsID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SubProductID] [int] NOT NULL,
	[Barcode] [nvarchar](50) NOT NULL,
	[Rate] [decimal](18, 3) NOT NULL,
	[BillQTY] [int] NOT NULL,
	[EnterQTY] [int] NOT NULL,
	[ColorID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[Total] [decimal](18, 3) NULL,
	[StoreTransferReceiveID] [int] NOT NULL CONSTRAINT [DF_tblStoreTransferItemDetails_StoreTransferReceiveID]  DEFAULT ((0)),
	[ReceiveBillQTYStatus] [bit] NULL CONSTRAINT [DF_tblStoreTransferItemDetails_ReceiveBillQTYStatus]  DEFAULT ((0)),
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_tblStoreTransferItemDetails_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblStoreTransferItemDetails_CreatedBy]  DEFAULT ((0)),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblStoreTransferItemDetails] PRIMARY KEY CLUSTERED 
(
	[TransferItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
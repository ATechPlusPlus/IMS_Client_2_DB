CREATE TABLE [dbo].[tblStoreTransferReceiveBillItemDetails](
	[TransferReceiveBillItemID] [int] IDENTITY(1,1) NOT NULL,
	[StoreTransferReceiveID] [int] NULL,
	[StoreBillDetailsID] [int] NULL,
	[ProductID] [int] NULL,
	[Barcode] [nvarchar](50) NULL,
	[Rate] [decimal](18, 3) NULL,
	[QTY] [int] NULL,
	[ColorID] [int] NULL,
	[SizeID] [int] NULL,
	[Total] [decimal](18, 3) NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblStoreTransferReceiveBillItemDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblStoreTransferReceiveBillItemDetails_CreatedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_tblStoreTransferReceiveBillItemDetails] PRIMARY KEY CLUSTERED 
(
	[TransferReceiveBillItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
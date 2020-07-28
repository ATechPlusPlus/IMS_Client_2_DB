CREATE TABLE [dbo].[tblStoreTransferReceiveBillItemDetails](
	[TransferReceiveBillItemID] [int] IDENTITY(1,1) NOT NULL,
	[StoreTransferReceiveID] [int] NOT NULL,
	[StoreBillDetailsID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SubProductID] [int] NOT NULL,
	[Barcode] [nvarchar](50) NOT NULL,
	[Rate] [decimal](18, 3) NOT NULL,
	[QTY] [int] NOT NULL,
	[ColorID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[Total] [decimal](18, 3) NOT NULL,
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
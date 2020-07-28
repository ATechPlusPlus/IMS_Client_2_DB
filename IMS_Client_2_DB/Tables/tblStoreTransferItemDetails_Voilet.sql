CREATE TABLE [dbo].[tblStoreTransferItemDetails_Voilet](
	[TransferItem_Voilet_ID] [int] IDENTITY(1,1) NOT NULL,
	[TransferItemID] [int] NOT NULL,
	[StoreBillDetailsID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SubProductID] [int] NOT NULL,
	[Barcode] [nvarchar](50) NOT NULL,
	[ModelNo] [nvarchar](50) NULL,
	[Rate] [decimal](18, 3) NOT NULL,
	[BillQTY] [int] NOT NULL CONSTRAINT [DF_tblStoreTransferItemDetails_Voilet_BillQTY]  DEFAULT ((0)),
	[EnterQTY] [int] NOT NULL,
	[ColorID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[Total] [decimal](18, 3) NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblStoreTransferItemDetails_Voilet_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblStoreTransferItemDetails_Voilet_CreatedBy]  DEFAULT ((0)),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblStoreTransferItemDetails_Voilet] PRIMARY KEY CLUSTERED 
(
	[TransferItem_Voilet_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
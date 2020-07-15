CREATE TABLE [dbo].[tblStoreTransferItemDetails](
	[TransferItemID] [int] IDENTITY(1,1) NOT NULL,
	[StoreBillDetailsID] [int] NULL,
	[ProductID] [int] NULL,
	[Barcode] [nvarchar](50) NULL,
	[Rate] [decimal](18, 3) NULL,
	[QTY] [int] NULL,
	[ColorID] [int] NULL,
	[SizeID] [int] NULL,
	[Total] [decimal](18, 3) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblStoreTransferItemDetails] PRIMARY KEY CLUSTERED 
(
	[TransferItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[ProductStockColorSizeMaster](
	[ProductStockID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[StoreID] [int] NULL,
	[BarcodeNo] [bigint] NULL,
	[ColorID] [int] NULL,
	[SizeID] [int] NULL,
	[QTY] [int] NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_ProductStockColorSizeMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_ProductStockColorSizeMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_ProductStockColorSizeMaster] PRIMARY KEY CLUSTERED 
(
	[ProductStockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
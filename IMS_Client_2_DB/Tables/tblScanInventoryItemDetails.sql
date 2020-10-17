CREATE TABLE [dbo].[tblScanInventoryItemDetails]
(
[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[MasterScanID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SubProductID] [int] NOT NULL,
	[Barcode] [nvarchar](50) NOT NULL,
	[Rate] [decimal](18, 3) NOT NULL,
	[BillQTY] [int] NOT NULL,
	[ColorID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[Total] [decimal](18, 3) NULL,
	 [SystemQTY] INT NULL DEFAULT 0, 
	
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblScanInventoryItemDetails_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblScanInventoryItemDetails_CreatedBy]  DEFAULT ((0)),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL

    CONSTRAINT [PK_tblScanInventoryItemDetails] PRIMARY KEY CLUSTERED 
(
	[AutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblScanInventoryDetails](
	[MasterScanID] [int] IDENTITY(1,1) NOT NULL,
	 [ScanDate] DATE NULL, 
	[StoreID] [int] NOT NULL,
	[CompareStatus] BIT NOT NULL DEFAULT 0,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblScanInventory_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL DEFAULT 0,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
   
    CONSTRAINT [PK_tblScanInventory] PRIMARY KEY CLUSTERED 
(
	[MasterScanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
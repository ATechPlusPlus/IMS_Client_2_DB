CREATE TABLE [dbo].[BrandMaster](
	[BrandID] [int] IDENTITY(1,1) NOT NULL,
	[BrandName] [nvarchar](50) NOT NULL,
	[SupplierID] [int] NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_BrandMaster_ActiveStatus]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_BrandMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_BrandMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_BrandMaster] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
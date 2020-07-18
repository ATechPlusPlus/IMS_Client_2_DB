CREATE TABLE [dbo].[ProductMaster](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[ProductArabicName] [nvarchar](100) NULL,
	[CategoryID] [int] NULL,
	[Rate] [decimal](18, 3) NULL CONSTRAINT [DF_ProductMaster_Rate]  DEFAULT ((1)),
	[Photo] NVARCHAR(50) NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_ProductMaster_ActiveStatus]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_ProductMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_ProductMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_ProductMaster] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
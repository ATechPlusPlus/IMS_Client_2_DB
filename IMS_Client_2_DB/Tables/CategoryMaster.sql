
CREATE TABLE [dbo].[CategoryMaster](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](50) NOT NULL,
	[CategoryDescription] [nvarchar](100) NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_CategoryMaster_ActiveStatus] DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL DEFAULT 0,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_CategoryMaster_CreatedOn] DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_CategoryMaster] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



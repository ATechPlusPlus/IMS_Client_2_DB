CREATE TABLE [dbo].[SizeTypeMaster](
	[SizeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SizeTypeName] [nvarchar](50) NOT NULL,
	[CategoryID] [int] NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Table_1_ActiveStatus1]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_SizeTypeMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_SizeTypeMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_SizeTypeMaster] PRIMARY KEY CLUSTERED 
(
	[SizeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
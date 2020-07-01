CREATE TABLE [dbo].[ColorMaster](
	[ColorID] [int] IDENTITY(1,1) NOT NULL,
	[ColorName] [nvarchar](50) NOT NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_ColorMaster_ActiveStatus]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_ColorMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_ColorMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_ColorMaster] PRIMARY KEY CLUSTERED 
(
	[ColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
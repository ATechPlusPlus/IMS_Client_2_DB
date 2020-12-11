
CREATE TABLE [dbo].[CompanyMaster](
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](50) NULL,
	[Address] [nvarchar](max) NULL,
	[MobileNo] [varchar](13) NULL,
	[EmailID] [varchar](50) NULL,
	[IsDefault] [bit] NULL CONSTRAINT [DF_CompanyMaster_IsDefault]  DEFAULT ((0)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_CompanyMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_CompanyMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_CompanyMaster] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblDashBoard](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Shopes] [nvarchar](max) NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[Specification] [int] NULL,
	[RefreshRate] [int] NULL,
 CONSTRAINT [PK_tblDashBoard] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE TABLE [dbo].[tblPC_Store_Mapping](
	[PC_Store_ID] [int] IDENTITY(1,1) NOT NULL,
	[StoreID] [int] NOT NULL,
	[MachineName] [nvarchar](50) NOT NULL,
	[StoreCategory] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblPC_Store_Mapping_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblPC_Store_Mapping_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__tblPC_St__A037AF7C64EDE3A7] PRIMARY KEY CLUSTERED 
(
	[PC_Store_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblUserRights](
	[UserRightsID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[FormID] [int] NOT NULL,
	[IsView] [int] NULL CONSTRAINT [DF_tblUserRights_IsView]  DEFAULT ((0)),
	[IsSave] [int] NULL CONSTRAINT [DF_tblUserRights_IsSave]  DEFAULT ((0)),
	[IsUpdate] [int] NULL CONSTRAINT [DF_tblUserRights_IsUpdate]  DEFAULT ((0)),
	[IsDelete] [int] NULL CONSTRAINT [DF_tblUserRights_IsDelete]  DEFAULT ((0)),
	[IsOther] [int] NULL CONSTRAINT [DF_tblUserRights_IsOther]  DEFAULT ((0)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblUserRights_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblUserRights_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__tblUserR__3214EC071033C564] PRIMARY KEY CLUSTERED 
(
	[UserRightsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
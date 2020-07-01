
CREATE TABLE [dbo].[Login_History](
	[Login_History_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[PcName] [nvarchar](50) NOT NULL,
	[MachineUserName] [nvarchar](50) NOT NULL,
	[UserIPAddress] [varchar](50) NOT NULL,
	[UserMacAddress] [varchar](50) NOT NULL,
	[LoginTime] [datetime] NOT NULL CONSTRAINT [DF_Login_History_LoginTime]  DEFAULT (getdate()),
	[LogOutTime] [datetime] NULL,
 CONSTRAINT [PK_Login_History] PRIMARY KEY CLUSTERED 
(
	[Login_History_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
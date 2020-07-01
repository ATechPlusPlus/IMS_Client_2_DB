
CREATE TABLE [dbo].[RegistrationDetails](
	[RegistrationID] [int] IDENTITY(1,1) NOT NULL,
	[SoftKey] [varchar](max) NULL,
	[RegDate] [date] NULL,
	[ExpiryDate] [varchar](max) NULL,
	[StatusDate] [varchar](max) NULL,
	[PcName] [nvarchar](50) NULL,
	[IsServer] [bit] NULL CONSTRAINT [DF_RegistrationDetails_IsServer]  DEFAULT ((0)),
	[IsTrail] [bit] NULL CONSTRAINT [DF_RegistrationDetails_IsTrail]  DEFAULT ((1)),
	[IsKeyEnter] [bit] NULL CONSTRAINT [DF_RegistrationDetails_IsKeyEnter]  DEFAULT ((0)),
 CONSTRAINT [PK_RegistrationDetails] PRIMARY KEY CLUSTERED 
(
	[RegistrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

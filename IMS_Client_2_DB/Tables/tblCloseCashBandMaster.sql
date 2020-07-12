CREATE TABLE [dbo].[tblCloseCashBandMaster](
	[CashBandID] [int] IDENTITY(1,1) NOT NULL,
	[CashBand] [decimal](18, 3) NOT NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_tblCloseCashBandMaster_ActiveStatus]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblCloseCashBandMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblCloseCashBandMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblCloseBALMaster] PRIMARY KEY CLUSTERED 
(
	[CashBandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
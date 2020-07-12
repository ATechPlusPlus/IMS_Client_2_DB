CREATE TABLE [dbo].[tblMasterCashClosing](
	[MasterCashClosingID] [int] IDENTITY(1,1) NOT NULL,
	[CashNo] [nvarchar](50) NOT NULL,
	[CashBoxDateTime] [datetime] NULL,
	[EmployeeID] [int] NOT NULL,
	[TotalCashValue] [decimal](18, 3) NULL,
	[RoundBalance] [decimal](18, 3) NULL,
	[CashStatus] [bit] NOT NULL CONSTRAINT [DF_tblMasterCashClosing_ActiveStatus1]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblMasterCashClosing_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblMasterCashClosing_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
 CONSTRAINT [PK__tblMasterCashClosing] PRIMARY KEY CLUSTERED 
(
	[MasterCashClosingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
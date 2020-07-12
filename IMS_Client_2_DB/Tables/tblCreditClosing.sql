CREATE TABLE [dbo].[tblCreditClosing]
(
	[CreditClosingID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NOT NULL, 
    [Type] NVARCHAR(50) NOT NULL, 
    [Count] INT NOT NULL, 
    [Value] DECIMAL(18, 3) NOT NULL, 
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblCreditClosing_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblCreditClosing_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
PRIMARY KEY CLUSTERED 
(
	[CreditClosingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

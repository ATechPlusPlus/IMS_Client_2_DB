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
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[tblCashReturn]
(
	[CashReturnID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [Value] DECIMAL(18, 3) NULL, 
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblCashReturn_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblCashReturn_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
) ON [PRIMARY]

GO
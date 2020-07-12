CREATE TABLE [dbo].[tblCashReturn]
(
	[CashReturnID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [Value] DECIMAL(18, 3) NULL, 
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblCashReturn_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblCashReturn_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
PRIMARY KEY CLUSTERED 
(
	[CashReturnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblPettyCashExpensesDetails](
	[PettyCashExpID] [int] IDENTITY(1,1) NOT NULL,
	[MasterCashClosingID] [int] NOT NULL DEFAULT 0,
	[Particulars] [nvarchar](200) NOT NULL,
	[TransactionDate] [date] NOT NULL,
	[PettyCashAmt] [decimal](18, 3) NOT NULL CONSTRAINT [DF_tblPettyCashExpenses_PettyCashAmt]  DEFAULT ((0)),
	[ExpensesAmt] [decimal](18, 3) NOT NULL CONSTRAINT [DF_tblPettyCashExpenses_ExpensesAmt]  DEFAULT ((0)),
	[StoreID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblPettyCashExpenses_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblPettyCashExpenses_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblPettyCashExpenses] PRIMARY KEY CLUSTERED 
(
	[PettyCashExpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblTotalPettyCashExpenses](
	[PettyCashID] [int] IDENTITY(1,1) NOT NULL,
	[TotalPettyCashAmt] [decimal](18, 3) NOT NULL,
	[TotalPettyCashExpAmt] [decimal](18, 3) NOT NULL,
	[PettyCashBalance] [decimal](18, 3) NOT NULL,
	[StoreID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblTotalPettyCashExpenses_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblTotalPettyCashExpenses_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblTotalPettyCashExpenses] PRIMARY KEY CLUSTERED 
(
	[PettyCashID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
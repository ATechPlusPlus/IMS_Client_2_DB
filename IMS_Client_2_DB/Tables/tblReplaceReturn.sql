CREATE TABLE [dbo].[tblReplaceReturn](
	[ReturnReplaceID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[BarCode] [nvarchar](50) NOT NULL,
	[ColorID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[QTY] [int] NOT NULL,
	[Rate] [decimal](18, 3) NOT NULL,
	[OldInvoiceID] [int] NULL,
	[NewInvoiceID] [int] NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblReplaceReturn_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblReplaceReturn_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblReplaceReturn] PRIMARY KEY CLUSTERED 
(
	[ReturnReplaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
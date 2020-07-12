CREATE TABLE [dbo].[tblReplaceReturn](
	[ReturnReplaceID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[BarCode] [nvarchar](50) NULL,
	[ColorID] [int] NULL,
	[SizeID] [int] NULL,
	[QTY] [int] NULL,
	[Rate] [decimal](18, 0) NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [int] NULL,
	[LastModifiedOn] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
 [OldInvoiceID] INT NULL, 
    [NewInvoiceID] INT NULL, 
    CONSTRAINT [PK_tblReplaceReturn] PRIMARY KEY CLUSTERED 
(
	[ReturnReplaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
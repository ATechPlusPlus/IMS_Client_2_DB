CREATE TABLE [dbo].[tblPrinterSetting](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MachineName] [nvarchar](50) NULL,
	[BarCodePrinter] [nvarchar](50) NULL,
	[InvoicePrinter] [nvarchar](50) NULL,

	[CreatedOn] [datetime] NULL,
	[CreateBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblPrinterSetting] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


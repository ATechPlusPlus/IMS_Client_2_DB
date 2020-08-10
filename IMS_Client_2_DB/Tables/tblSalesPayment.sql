CREATE TABLE [dbo].[tblSalesPayment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentType] [nvarchar](50) NULL,
	[Amount] [decimal](18, 2) NULL,
	[SalesInvoiceID] [int] NULL,
	PaymentNumber [nvarchar](50) NULL,
 CONSTRAINT [PK_tblSalesPayment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
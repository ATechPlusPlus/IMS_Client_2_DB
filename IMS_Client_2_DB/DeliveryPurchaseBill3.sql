CREATE TABLE [dbo].[DeliveryPurchaseBill3](
	[DeliveryPurchaseID3] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryPurchaseID1] [int] NULL,
	[DeliveryPurchaseID2] [int] NULL,
	[ColorID] [int] NULL,
	[Col1] [int] NULL,
	[Col2] [int] NULL,
	[Col3] [int] NULL,
	[Col4] [int] NULL,
	[Col5] [int] NULL,
	[Col6] [int] NULL,
	[Col7] [int] NULL,
	[Col8] [int] NULL,
	[Col9] [int] NULL,
	[Col10] [int] NULL,
	[Col11] [int] NULL,
	[Col12] [int] NULL,
	[Col13] [int] NULL,
	[Col14] [int] NULL,
	[Col15] [int] NULL,
	[Col16] [int] NULL,
	[Col17] [int] NULL,
	[Col18] [int] NULL,
	[Col19] [int] NULL,
	[Col20] [int] NULL,
	[Total] [int] NULL,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_DeliveryPurchaseBill3_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_DeliveryPurchaseBill3_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_DeliveryPurchaseBill3] PRIMARY KEY CLUSTERED 
(
	[DeliveryPurchaseID3] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
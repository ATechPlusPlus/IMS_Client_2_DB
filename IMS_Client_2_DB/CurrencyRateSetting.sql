CREATE TABLE [dbo].[CurrencyRateSetting](
	[CurrencyRateID] [int] IDENTITY(1,1) NOT NULL,
	[CountryID] [int] NOT NULL,
	[CurrencyCode] [nvarchar](50) NULL,
	[CurrencyName] [nvarchar](50) NULL,
	[CurrencyRate] [decimal](18, 3) NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_CurrencyRateSetting_ActiveStatus]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_CurrencyRateSetting_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_CurrencyRateSetting_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_CurrencyRateSetting] PRIMARY KEY CLUSTERED 
(
	[CurrencyRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
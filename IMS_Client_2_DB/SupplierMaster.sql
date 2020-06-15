
CREATE TABLE [dbo].[SupplierMaster](
	[SupplierID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [nvarchar](50) NOT NULL,
	[CountryID] [int] NULL,
	[Phone] [varchar](50) NULL,
	[EmailID] [varchar](50) NULL,
	[BankName] [nvarchar](50) NULL,
	[BankAccountNo] [varchar](50) NULL,
	[BankAddress] [nvarchar](max) NULL,
	[ActiveStatus] [bit] NOT NULL CONSTRAINT [DF_SupplierMaster_ActiveStatus]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_SupplierMaster_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_SupplierMaster_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_SupplierMaster] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
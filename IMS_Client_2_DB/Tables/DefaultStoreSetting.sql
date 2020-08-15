CREATE TABLE [dbo].[DefaultStoreSetting]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreID] [int] NULL,
	[MachineName] [nvarchar](500) NULL,
	[StoreCategory] [int] NULL,
	[BarCodeSetting] [nvarchar](max) NULL,
	[InvoiceFooterNote] [nvarchar](max) NULL,
	[UserArabicNumbers] BIT NULL DEFAULT 0, 
	SalesManIDMandatory  bit  null,
	CustMobileMandatory  bit NULL, 
    [ImagePath] NVARCHAR(50) NULL, 
    [Extension] NVARCHAR(50) NULL,
    [CreatedBy] INT NOT NULL CONSTRAINT [DF_DefaultStoreSetting_CreatedBy]  DEFAULT ((0)),
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_DefaultStoreSetting_CreatedOn]  DEFAULT (getdate()), 
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
)

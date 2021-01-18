CREATE TABLE [dbo].[EmployeeDetails](
	[EmpID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCode] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[ShopID] [int] NULL,
	[Gender] [bit] NULL,
	[DOB] [date] NULL,
	[Address] [nvarchar](max) NULL,
	[Photo] [varbinary](max) NULL,
	[MonthlySalary] [decimal](18, 3) NULL CONSTRAINT [DF_EmployeeDetails_MonthlySalary]  DEFAULT ((0)),
	[ActiveStatus] [bit] DEFAULT 1,
	[CreatedBy] [int] NOT NULL CONSTRAINT [DF_EmployeeDetails_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_EmployeeDetails_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Employee__AF2DBA7930B08991] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
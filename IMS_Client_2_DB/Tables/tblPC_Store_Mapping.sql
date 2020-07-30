CREATE TABLE [dbo].[tblPC_Store_Mapping]
(
	[PC_Store_ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [StoreID] INT NULL, 
    [MachineName] NVARCHAR(50) NULL, 
    [CreatedBy] [int] NOT NULL CONSTRAINT [DF_tblPC_Store_Mapping_CreatedBy]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_tblPC_Store_Mapping_CreatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
)

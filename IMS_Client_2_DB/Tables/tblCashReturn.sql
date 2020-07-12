CREATE TABLE [dbo].[tblCashReturn]
(
	[CashReturnID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [Value] DECIMAL(18, 3) NULL, 
    [CreatedOn] DATETIME NULL, 
    [CreatedBy] INT NULL, 
    [ModifiedOn] DATETIME NULL, 
    [ModifiedBy] INT NULL
)

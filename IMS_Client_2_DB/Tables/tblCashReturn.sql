CREATE TABLE [dbo].[tblCashReturn]
(
	[CashReturnID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [Value] DECIMAL NULL, 
    [AddedOn] DATETIME NULL, 
    [AddedBy] INT NULL, 
    [ModifiedOn] DATETIME NULL, 
    [ModifiedBy] INT NULL
)

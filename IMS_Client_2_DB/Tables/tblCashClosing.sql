CREATE TABLE [dbo].[tblCashClosing]
(
	[CashClosingID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [CashBand] NVARCHAR(50) NULL, 
    [Count] INT NULL, 
    [Value] DECIMAL(18, 3) NULL, 
    [CreatedOn] DATETIME NULL, 
    [CreatedBy] INT NULL, 
    [ModifiedOn] DATETIME NULL, 
    [ModifiedBy] INT NULL
)

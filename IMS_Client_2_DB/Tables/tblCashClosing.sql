CREATE TABLE [dbo].[tblCashClosing]
(
	[CashClosingID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [CashBand] NVARCHAR(50) NULL, 
    [Count] INT NULL, 
    [Value] DECIMAL NULL, 
    [AddedOn] DATETIME NULL, 
    [AddedBy] INT NULL, 
    [ModifiedOn] DATETIME NULL, 
    [ModifiedBy] INT NULL
)

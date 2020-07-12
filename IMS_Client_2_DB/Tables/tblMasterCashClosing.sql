CREATE TABLE [dbo].[tblMasterCashClosing]
(
	[MasterCashClosingID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [CashNo] NVARCHAR(50) NULL, 
    [CashBoxDateTime] DATETIME NULL, 
    [EmployeeID] INT NULL, 
    [TotalCashValue] DECIMAL NULL, 
    [RoundBalance] DECIMAL NULL, 
    [CashStatus] BIT NULL DEFAULT 0, 
    [AddedOn] DATETIME NULL, 
    [AddedBy] INT NULL, 
    [ModifiedOn] DATETIME NULL, 
    [ModifiedBy] INT NULL
)

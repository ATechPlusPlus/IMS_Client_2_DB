CREATE TABLE [dbo].[tblMasterCashClosing]
(
	[MasterCashClosingID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [CashNo] NVARCHAR(50) NULL, 
    [CashBoxDateTime] DATETIME NULL, 
    [EmployeeID] INT NULL, 
    [TotalCashValue] DECIMAL(18, 3) NULL, 
    [RoundBalance] DECIMAL(18, 3) NULL, 
    [CashStatus] BIT NULL DEFAULT 0, 
    [CreatedOn] DATETIME NULL, 
    [CreatedBy] INT NULL, 
    [ModifiedOn] DATETIME NULL, 
    [ModifiedBy] INT NULL
)

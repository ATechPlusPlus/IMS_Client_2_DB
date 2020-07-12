CREATE TABLE [dbo].[tblCreditClosing]
(
	[CreditClosingID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MasterCashClosingID] INT NULL, 
    [Type] NVARCHAR(50) NULL, 
    [Count] INT NULL, 
    [Value] DECIMAL(18, 3) NULL, 
    [CreatedOn] INT NULL, 
    [CreatedBy] DATETIME NULL, 
    [ModifiedOn] INT NULL, 
    [ModifiedBy] DATETIME NULL
)

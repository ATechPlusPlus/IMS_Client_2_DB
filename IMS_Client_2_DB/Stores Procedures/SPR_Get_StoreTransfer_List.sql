-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <16th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_StoreTransfer_List
CREATE PROCEDURE [dbo].[SPR_Get_StoreTransfer_List]
--@FromDate date=0
--,@ToDate date=0
--,@BillStatus VARCHAR(50)='0'
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @StoreID AS INT=0

	BEGIN TRY

	SELECT @StoreID=StoreID FROM DefaultStoreSetting WITH(NOLOCK) WHERE MachineName=HOST_NAME()
	
	SELECT stb.StoreTransferID,stb.BillNo,stb.BillDate,sm.StoreName [FromBranch]
	,sm1.StoreName [ToBranch],stb.TotalQTY
	,(CASE WHEN [str].StoreTransferID IS NULL THEN 'Not Received' ELSE 'Received' END) [Received State]
	,stb.CreatedBy,usr.UserName [TransferedBy],usr1.UserName [ReceivedBy]
	FROM tblStoreTransferBillDetails stb
	INNER JOIN StoreMaster sm ON stb.FromStore=sm.StoreID
	INNER JOIN 
	(
		SELECT StoreID,StoreName FROM StoreMaster WITH(NOLOCK)
	)sm1 ON stb.ToStore=sm1.StoreID AND stb.ToStore=@StoreID

	INNER JOIN UserManagement usr ON stb.CreatedBy=usr.UserID
	LEFT OUTER JOIN tblStoreTransferReceiveBillDetails [str] ON stb.StoreTransferID=[str].StoreTransferID
	LEFT OUTER JOIN
	(
		SELECT UserID,UserName FROM UserManagement WITH(NOLOCK)
	) usr1 ON [str].CreatedBy=usr1.UserID

	END TRY

	BEGIN CATCH

		INSERT [dbo].[ERROR_Log]
		(
		ERR_NUMBER
		, ERR_SEVERITY
		, ERR_STATE
		, ERR_LINE
		, ERR_MESSAGE
		, ERR_PROCEDURE
		, PARAMERES
		)
		SELECT  
		ERROR_NUMBER() 
		,ERROR_SEVERITY() 
		,ERROR_STATE() 
		,ERROR_LINE()
		,ERROR_MESSAGE()
		,ERROR_PROCEDURE()
		,@PARAMERES

	END CATCH
END
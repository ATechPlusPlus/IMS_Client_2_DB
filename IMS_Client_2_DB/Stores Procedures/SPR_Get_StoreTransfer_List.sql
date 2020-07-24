-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <16th JULY 2020>
-- Update date: <24th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_StoreTransfer_List '2020-07-15','2020-07-20',-1
CREATE PROCEDURE [dbo].[SPR_Get_StoreTransfer_List]
@FromDate DATE=NULL
,@ToDate DATE=NULL
,@BillStatus INT=NULL  -- @BillStatus < 0 means show all data
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @PARAMERES VARCHAR(MAX)=''
	--DECLARE @StoreID AS INT=0

	BEGIN TRY

	SET @PARAMERES=CONCAT(@FromDate,',',@ToDate,',',@BillStatus)

	--SELECT @StoreID=StoreID FROM DefaultStoreSetting WITH(NOLOCK) WHERE MachineName=HOST_NAME()
	IF @BillStatus < 0
	BEGIN

	SELECT stb.StoreTransferID,stb.BillNo,stb.BillDate,sm.StoreName [FromBranch]
	,sm1.StoreName [ToBranch],stb.TotalQTY
	,(CASE WHEN [str].StoreTransferID IS NULL THEN 'Not Received' ELSE 'Received' END) [Received State]
	,stb.CreatedBy,usr.UserName [TransferedBy],usr1.UserName [ReceivedBy],[str].ReceiveBillDate
	FROM tblStoreTransferBillDetails stb
	INNER JOIN StoreMaster sm ON stb.FromStore=sm.StoreID
	INNER JOIN 
	(
		SELECT StoreID,StoreName FROM StoreMaster WITH(NOLOCK)
	)sm1 ON stb.ToStore=sm1.StoreID --AND stb.ToStore=@StoreID
	
	INNER JOIN UserManagement usr ON stb.CreatedBy=usr.UserID
	LEFT OUTER JOIN tblStoreTransferReceiveBillDetails [str] ON stb.StoreTransferID=[str].StoreTransferID
	LEFT OUTER JOIN
	(
		SELECT UserID,UserName FROM UserManagement WITH(NOLOCK)
	) usr1 ON [str].CreatedBy=usr1.UserID
	--ORDER BY stb.BillDate DESC

	END

	ELSE
	BEGIN
		IF @FromDate IS NULL AND @BillStatus IS NULL
		BEGIN
	
			SELECT Top 100 stb.StoreTransferID,stb.BillNo,stb.BillDate,sm.StoreName [FromBranch]
			,sm1.StoreName [ToBranch],stb.TotalQTY
			,(CASE WHEN [str].StoreTransferID IS NULL THEN 'Not Received' ELSE 'Received' END) [Received State]
			,stb.CreatedBy,usr.UserName [TransferedBy],usr1.UserName [ReceivedBy],[str].ReceiveBillDate
			FROM tblStoreTransferBillDetails stb
			INNER JOIN StoreMaster sm ON stb.FromStore=sm.StoreID
			INNER JOIN 
			(
				SELECT StoreID,StoreName FROM StoreMaster WITH(NOLOCK)
			)sm1 ON stb.ToStore=sm1.StoreID --AND stb.ToStore=@StoreID

			INNER JOIN UserManagement usr ON stb.CreatedBy=usr.UserID
			LEFT OUTER JOIN tblStoreTransferReceiveBillDetails [str] ON stb.StoreTransferID=[str].StoreTransferID
			LEFT OUTER JOIN
			(
				SELECT UserID,UserName FROM UserManagement WITH(NOLOCK)
			) usr1 ON [str].CreatedBy=usr1.UserID
			--ORDER BY stb.BillDate DESC

		END

		ELSE IF @FromDate IS NOT NULL AND @BillStatus IS NULL
		BEGIN
	
			SELECT stb.StoreTransferID,stb.BillNo,stb.BillDate,sm.StoreName [FromBranch]
			,sm1.StoreName [ToBranch],stb.TotalQTY
			,(CASE WHEN [str].StoreTransferID IS NULL THEN 'Not Received' ELSE 'Received' END) [Received State]
			,stb.CreatedBy,usr.UserName [TransferedBy],usr1.UserName [ReceivedBy],[str].ReceiveBillDate
			FROM tblStoreTransferBillDetails stb
			INNER JOIN StoreMaster sm ON stb.FromStore=sm.StoreID
			INNER JOIN 
			(
				SELECT StoreID,StoreName FROM StoreMaster WITH(NOLOCK)
			)sm1 ON stb.ToStore=sm1.StoreID --AND stb.ToStore=@StoreID

			INNER JOIN UserManagement usr ON stb.CreatedBy=usr.UserID
			LEFT OUTER JOIN tblStoreTransferReceiveBillDetails [str] ON stb.StoreTransferID=[str].StoreTransferID
			LEFT OUTER JOIN
			(
				SELECT UserID,UserName FROM UserManagement WITH(NOLOCK)
			) usr1 ON [str].CreatedBy=usr1.UserID
			WHERE stb.BillDate BETWEEN @FromDate AND @ToDate
			--ORDER BY stb.BillDate DESC

		END

		ELSE IF @FromDate IS NULL AND @BillStatus IS NOT NULL
		BEGIN
	
			SELECT stb.StoreTransferID,stb.BillNo,stb.BillDate,sm.StoreName [FromBranch]
			,sm1.StoreName [ToBranch],stb.TotalQTY
			,(CASE WHEN [str].StoreTransferID IS NULL THEN 'Not Received' ELSE 'Received' END) [Received State]
			,stb.CreatedBy,usr.UserName [TransferedBy],usr1.UserName [ReceivedBy],[str].ReceiveBillDate
			FROM tblStoreTransferBillDetails stb
			INNER JOIN StoreMaster sm ON stb.FromStore=sm.StoreID
			INNER JOIN 
			(
				SELECT StoreID,StoreName FROM StoreMaster WITH(NOLOCK)
			)sm1 ON stb.ToStore=sm1.StoreID --AND stb.ToStore=@StoreID

			INNER JOIN UserManagement usr ON stb.CreatedBy=usr.UserID
			LEFT OUTER JOIN tblStoreTransferReceiveBillDetails [str] ON stb.StoreTransferID=[str].StoreTransferID
			LEFT OUTER JOIN
			(
				SELECT UserID,UserName FROM UserManagement WITH(NOLOCK)
			) usr1 ON [str].CreatedBy=usr1.UserID
			WHERE ISNULL([str].StoreTransferID,0) = IIF(@BillStatus=1,stb.StoreTransferID,0)
			--ORDER BY stb.BillDate DESC

		END
	
	END

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
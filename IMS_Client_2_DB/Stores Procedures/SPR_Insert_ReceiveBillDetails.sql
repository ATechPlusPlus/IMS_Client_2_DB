-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <16th JULY 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Insert_ReceiveBillDetails 'RECEBILL-1002',1,5
CREATE PROCEDURE [dbo].[SPR_Insert_ReceiveBillDetails]
@ReceiveBillNo NVARCHAR(50)='0'
,@StoreBillDetailsID INT=0
,@CreatedBy INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @PARAMERES VARCHAR(MAX)=''
		
		DECLARE @StoreTransferReceiveID AS INT=0
		DECLARE @TransferReceiveBillItemID AS INT=0
		DECLARE @TotalQTY AS INT=0						--tblStoreTransferReceiveBillDetails

		DECLARE @TransferItemID AS INT=0
		DECLARE @Barcode AS NVARCHAR(50)=0
		DECLARE @ProductID AS INT=0 
		
		DECLARE @StoreID AS INT=0 
		
		DECLARE @ColorID AS INT=0 
		DECLARE @SizeID AS INT=0
		DECLARE @BillQTY AS INT=0
		DECLARE @Rate AS DECIMAL(18,3)=0

		--DECLARE @ModelNo AS VARCHAR(50)=0

		SET @PARAMERES=CONCAT(@ReceiveBillNo,',',@StoreBillDetailsID,',',@CreatedBy)
		
		BEGIN TRY
		
		SELECT @StoreID=StoreID FROM DefaultStoreSetting WITH(NOLOCK) WHERE MachineName=HOST_NAME()

		BEGIN TRANSACTION

		SELECT @TotalQTY=ISNULL(SUM(BillQTY),0)
		FROM dbo.tblStoreTransferItemDetails WITH(NOLOCK)
		WHERE StoreBillDetailsID=@StoreBillDetailsID
		AND BillQTY=EnterQTY

		INSERT INTO tblStoreTransferReceiveBillDetails
		(
		ReceiveBillNo
		,StoreTransferID
		,TotalQTY
		,ReceiveBillStatus
		,ReceiveBillDate
		,CreatedBy
		)
		VALUES
		(
		 @ReceiveBillNo
		,@StoreBillDetailsID
		,@TotalQTY
		,'Posted'
		,CONVERT(DATE,GETDATE())
		,@CreatedBy
		)
		SELECT @StoreTransferReceiveID=SCOPE_IDENTITY()

		DECLARE ReceiveBill_CURSOR CURSOR 
		FOR
		
		SELECT TransferItemID,Barcode,ProductID, ColorID, SizeID , BillQTY
		,Rate
		FROM dbo.tblStoreTransferItemDetails WITH(NOLOCK)
		WHERE StoreBillDetailsID=@StoreBillDetailsID
		AND BillQTY=EnterQTY

		OPEN ReceiveBill_CURSOR

		FETCH NEXT FROM ReceiveBill_CURSOR INTO @TransferItemID,@Barcode,@ProductID, 
		@ColorID, @SizeID , @BillQTY,@Rate

			WHILE @@FETCH_STATUS <> -1
				BEGIN

				INSERT INTO tblStoreTransferReceiveBillItemDetails
				(
				StoreTransferReceiveID
				,StoreBillDetailsID
				,ProductID
				,Barcode
				,Rate
				,QTY
				,ColorID
				,SizeID
				,Total
				,CreatedBy
				)
				VALUES
				(
				@StoreTransferReceiveID
				,@StoreBillDetailsID
				,@ProductID
				,@Barcode
				,@Rate
				,@BillQTY
				,@ColorID
				,@SizeID
				,(@Rate * @BillQTY)
				,@CreatedBy
				)
				SELECT @TransferReceiveBillItemID=SCOPE_IDENTITY()

				IF EXISTS(SELECT 1 FROM ProductStockColorSizeMaster WITH(NOLOCK) WHERE ProductID=@ProductID 
				AND StoreID=@StoreID AND ColorID=@ColorID AND SizeID=@SizeID)
				BEGIN

				UPDATE ProductStockColorSizeMaster SET
				QTY=QTY+@BillQTY
				,UpdatedBy=@CreatedBy
				,UpdatedOn=GETDATE()
				WHERE ProductID=@ProductID 
				AND StoreID=@StoreID AND ColorID=@ColorID AND SizeID=@SizeID

				END

				ELSE
				BEGIN

				INSERT INTO ProductStockColorSizeMaster
				(
				ProductID
				,StoreID
				,BarcodeNo
				,ColorID
				,SizeID
				,QTY
				,CreatedBy
				)
				VALUES
				(
				@ProductID
				,@StoreID
				,@Barcode
				,@ColorID
				,@SizeID
				,@BillQTY
				,@CreatedBy
				)

				END

				UPDATE tblStoreTransferItemDetails
				SET StoreTransferReceiveID=@TransferReceiveBillItemID
				,UpdatedBy=@CreatedBy
			    ,UpdatedOn=GETDATE()
				,ReceiveBillQTYStatus=1
				WHERE TransferItemID=@TransferItemID

				FETCH NEXT FROM ReceiveBill_CURSOR INTO @TransferItemID,@Barcode,@ProductID
				, @ColorID, @SizeID , @BillQTY, @Rate

				END

			CLOSE ReceiveBill_CURSOR;
			DEALLOCATE ReceiveBill_CURSOR;

			UPDATE tblStoreTransferBillDetails
			SET BillStatus='Posted'
			,UpdatedBy=@CreatedBy
			,UpdatedOn=getdate()
			WHERE StoreTransferID=@TransferItemID

		COMMIT

		SELECT 1 AS Flag,'Bill Receive Successfully.' as Msg -- Success

	END TRY
	
	BEGIN CATCH
		ROLLBACK
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

		SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured

	END CATCH

END
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <16th JULY 2020>
-- Update date: <15th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Insert_ReceiveBillDetails 'RECEBILL-1001',2,1
CREATE PROCEDURE [dbo].[SPR_Insert_ReceiveBillDetails]
@ReceiveBillNo NVARCHAR(50)='0'
,@StoreBillDetailsID INT=0
,@StoreID INT=0
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
		DECLARE @SubProductID AS INT=0 

		DECLARE @ColorID AS INT=0 
		DECLARE @SizeID AS INT=0
		DECLARE @BillQTY AS INT=0
		DECLARE @Rate AS DECIMAL(18,3)=0

		DECLARE @EnteredQTY AS INT=0
		DECLARE @FromStoreID INT=0

		DECLARE @VioletQTY AS INT=0

		SET @PARAMERES=CONCAT(@ReceiveBillNo,',',@StoreBillDetailsID,',',@StoreID,',',@CreatedBy)
		
		BEGIN TRY

		SELECT @VioletQTY=COUNT(1) FROM tblStoreTransferItemDetails_Voilet WITH(NOLOCK)
		WHERE StoreBillDetailsID=@StoreBillDetailsID

		SELECT @TotalQTY=ISNULL(SUM(BillQTY),0), @EnteredQTY=ISNULL(SUM(EnterQTY),0)
		FROM dbo.tblStoreTransferItemDetails WITH(NOLOCK)
		WHERE StoreBillDetailsID=@StoreBillDetailsID

		SELECT @FromStoreID=FromStore 
		FROM tblStoreTransferBillDetails WITH(NOLOCK)
		WHERE StoreTransferID=@StoreBillDetailsID

		IF @VioletQTY = 0
		BEGIN

			IF @TotalQTY = @EnteredQTY
			BEGIN

			BEGIN TRANSACTION

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
		
			SELECT TransferItemID,Barcode,ProductID, SubProductID, ColorID, SizeID , BillQTY
			,Rate
			FROM dbo.tblStoreTransferItemDetails WITH(NOLOCK)
			WHERE StoreBillDetailsID=@StoreBillDetailsID
			AND BillQTY=EnterQTY

			OPEN ReceiveBill_CURSOR

			FETCH NEXT FROM ReceiveBill_CURSOR INTO @TransferItemID,@Barcode,@ProductID,@SubProductID, 
			@ColorID, @SizeID , @BillQTY,@Rate

				WHILE @@FETCH_STATUS <> -1
					BEGIN

					INSERT INTO tblStoreTransferReceiveBillItemDetails
					(
					StoreTransferReceiveID
					,StoreBillDetailsID
					,ProductID
					,SubProductID
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
					,@SubProductID
					,@Barcode
					,@Rate
					,@BillQTY
					,@ColorID
					,@SizeID
					,(@Rate * @BillQTY)
					,@CreatedBy
					)
					SELECT @TransferReceiveBillItemID=SCOPE_IDENTITY()

					IF EXISTS(SELECT 1 FROM ProductStockColorSizeMaster WITH(NOLOCK) WHERE 
					SubProductID=@SubProductID
					AND ProductID=@ProductID 
					AND StoreID=@StoreID AND ColorID=@ColorID AND SizeID=@SizeID)
					BEGIN
					--Adding QTY in Receiver Store
					UPDATE ProductStockColorSizeMaster SET
					QTY=QTY+@BillQTY
					,UpdatedBy=@CreatedBy
					,UpdatedOn=GETDATE()
					WHERE SubProductID=@SubProductID
					AND ProductID=@ProductID 
					AND StoreID=@StoreID AND ColorID=@ColorID AND SizeID=@SizeID

					--Substracting QTY in Sender Store
					UPDATE ProductStockColorSizeMaster SET
					QTY=QTY-@BillQTY
					,UpdatedBy=@CreatedBy
					,UpdatedOn=GETDATE()
					WHERE SubProductID=@SubProductID
					AND ProductID=@ProductID 
					AND StoreID=@FromStoreID AND ColorID=@ColorID AND SizeID=@SizeID
				
					END

					ELSE
					BEGIN
					--Adding QTY in Receiver Store
					INSERT INTO ProductStockColorSizeMaster
					(
					ProductID
					,SubProductID
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
					,@SubProductID
					,@StoreID
					,@Barcode
					,@ColorID
					,@SizeID
					,@BillQTY
					,@CreatedBy
					)

					--Substracting QTY in Sender Store
					UPDATE ProductStockColorSizeMaster SET
					QTY=QTY-@BillQTY
					,UpdatedBy=@CreatedBy
					,UpdatedOn=GETDATE()
					WHERE SubProductID=@SubProductID
					AND ProductID=@ProductID
					AND StoreID=@FromStoreID AND ColorID=@ColorID AND SizeID=@SizeID

					END

					UPDATE tblStoreTransferItemDetails
					SET StoreTransferReceiveID=@TransferReceiveBillItemID
					,UpdatedBy=@CreatedBy
					,UpdatedOn=GETDATE()
					,ReceiveBillQTYStatus=1
					WHERE TransferItemID=@TransferItemID

					FETCH NEXT FROM ReceiveBill_CURSOR INTO @TransferItemID,@Barcode,@ProductID,@SubProductID
					, @ColorID, @SizeID , @BillQTY, @Rate

					END

				CLOSE ReceiveBill_CURSOR;
				DEALLOCATE ReceiveBill_CURSOR;

				UPDATE tblStoreTransferBillDetails
				SET BillStatus='Posted'
				,UpdatedBy=@CreatedBy
				,UpdatedOn=GETDATE()
				WHERE StoreTransferID=@StoreBillDetailsID--@TransferItemID

			COMMIT

			SELECT 1 AS Flag,'Bill Receive Successfully.' as Msg -- Success
		END

		ELSE
		BEGIN

		SELECT 0 AS Flag,'Bill QTY and Entered QTY is not same.' as Msg -- Fail

		END
	END
	
	ELSE
	BEGIN

	SELECT 0 AS Flag,'Please Validate Not Exist Items.' as Msg -- Fail

	END

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
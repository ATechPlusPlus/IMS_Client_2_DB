-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <03th APR 2022>
-- Update date: <17th APR 2022>
-- Description:	<re posting purchase invoice>
-- =============================================
-- EXEC [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size] 2,3,10,0,'B201',3763,5
-- EXEC [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size] 12,3,5,0,'V101',3763,5
-- DROP PROCEDURE [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size]
CREATE PROCEDURE [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size]
@PurchaseInvoiceID INT=0
,@StoreID INT=0
,@SupplierBillNo VARCHAR(MAX)
,@SubProductID INT =0
,@CreatedBy INT=0
,@dtOldPurchase as tblPurchaseInvoice_Color_sizeType READONLY
,@Flag INT=0 OUTPUT
,@Message VARCHAR(MAX)='0' OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM DeliveryPurchaseBill1 WITH(NOLOCK) WHERE PurchaseInvoiceID=@PurchaseInvoiceID)
	BEGIN

		BEGIN TRY

		BEGIN TRANSACTION

		DECLARE @PARAMERES VARCHAR(MAX)=''
		--DECLARE @SizeType_ID AS INT=0
		--DECLARE @SizeValue AS VARCHAR(50)
		DECLARE @i AS INT=1
		--DECLARE @DeliveryPurchaseID AS INT=0
		--DECLARE @query1  AS VARCHAR(MAX)=''
		--DECLARE @query2  AS VARCHAR(MAX)
		--DECLARE @queryunpivot  AS VARCHAR(MAX)=''
		--DECLARE @ModelNo NVARCHAR(50) =''
	
		DECLARE @ProductID    INT =0
		--DECLARE @SubProductID INT =0
		DECLARE @ColorID      INT =0
		DECLARE @QTY		  INT =0
		DECLARE @SizeID		  INT =0
		DECLARE @BarcodeNo    BIGINT=0
		--DECLARE @Size	 VARCHAR(20) ='0'
		
		DECLARE @OldQTY		  INT =0

		SET @PARAMERES=CONCAT(@PurchaseInvoiceID,',',@StoreID,',',@SupplierBillNo,',',@SubProductID,',',@CreatedBy)
		
		DELETE FROM ProductStockMaster WHERE PurchaseInvoiceID=@PurchaseInvoiceID AND QTY = 0

		DECLARE ColorSize_CURSOR CURSOR 
		FOR
		
		SELECT ProductID, StoreID, ColorID, SizeID , QTY, BarcodeNo
		FROM dbo.ProductStockMaster WITH(NOLOCK)
		WHERE PurchaseInvoiceID=@PurchaseInvoiceID AND SubProductID=@SubProductID
		AND QTY > 0
		

	OPEN ColorSize_CURSOR 

	FETCH NEXT FROM ColorSize_CURSOR INTO @ProductID, @StoreID, @ColorID, @SizeID, @QTY, @BarcodeNo
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	--SELECT CONCAT(@PurchaseInvoiceID,',',@ProductID,',',@SubProductID,',', @StoreID,',', @ColorID,',', @SizeID,',' , @QTY)

	SET @i = 1
	SET @OldQTY=0

	IF EXISTS(SELECT 1 FROM ProductStockColorSizeMaster WITH(NOLOCK) WHERE ProductID=@ProductID AND SubProductID=@SubProductID AND ColorID=@ColorID AND StoreID=@StoreID AND SizeID=@SizeID)
	BEGIN

	--SELECT 'select',SubProductID,ProductID, StoreID, ColorID, SizeID , QTY
	--FROM ProductStockColorSizeMaster WITH(NOLOCK)
	--WHERE SubProductID=@SubProductID AND ProductID=@ProductID AND ColorID=@ColorID AND StoreID=@StoreID AND SizeID=@SizeID
		
		--below query Added for mainating main stock log before posting for future rollback
		INSERT INTO dbo.tblProductStockLogData
		(
			sstatus, PurchaseInvoiceID, ProductID, SubProductID, StoreID, ColorID, SizeID, QTY
			, OldQTY, BarcodeNo, CreatedBy
		)
		SELECT 'Before Posting Main Stock QTY', @PurchaseInvoiceID,ProductID, SubProductID, StoreID, ColorID, SizeID, QTY
		, @OldQTY, BarcodeNo, @CreatedBy
		FROM dbo.ProductStockColorSizeMaster WITH(NOLOCK)
		WHERE SubProductID=@SubProductID
		AND ProductID=@ProductID 
		AND ColorID=@ColorID 
		AND StoreID=@StoreID
		AND SizeID=@SizeID

		SELECT @OldQTY=QTY FROM @dtOldPurchase WHERE SubProductID=@SubProductID
		AND ProductID=@ProductID 
		AND ColorID=@ColorID 
		AND StoreID=@StoreID
		AND SizeID=@SizeID

		UPDATE ProductStockColorSizeMaster
		SET 
		--QTY = QTY + @QTY
		QTY = ABS(QTY - (ABS(@OldQTY - @QTY)) )
		,UpdatedBy = @CreatedBy
		,UpdatedOn = GETDATE()
		WHERE 
		SubProductID=@SubProductID
		AND ProductID=@ProductID 
		AND ColorID=@ColorID 
		AND StoreID=@StoreID
		AND SizeID=@SizeID
	END
	
	ELSE
	BEGIN
		--SELECT 'insert',@ProductID,@SubProductID, @StoreID, @ColorID, @SizeID , @QTY, @CreatedBy
		INSERT INTO ProductStockColorSizeMaster
		(
			ProductID, SubProductID, StoreID, ColorID, SizeID , QTY, BarcodeNo, CreatedBy
		)
		VALUES
		(
			@ProductID, @SubProductID, @StoreID, @ColorID, @SizeID , @QTY, @BarcodeNo, @CreatedBy
		)
		--below query Added for mainating main stock log before posting for future rollback
		INSERT INTO dbo.tblProductStockLogData
		(
			sstatus, PurchaseInvoiceID, ProductID, SubProductID, StoreID, ColorID, SizeID, QTY
			, OldQTY, BarcodeNo, CreatedBy
		)
		SELECT 'Before Posting Main Stock BAL QTY', @PurchaseInvoiceID,ProductID, SubProductID, StoreID, ColorID, SizeID, QTY
		, @OldQTY, BarcodeNo, @CreatedBy
		FROM dbo.ProductStockColorSizeMaster WITH(NOLOCK)
		WHERE SubProductID=@SubProductID
		AND ProductID=@ProductID 
		AND ColorID=@ColorID 
		AND StoreID=@StoreID
		AND SizeID=@SizeID

	END
	-- Below table added for maintaining product stock log before/after posting
	INSERT INTO dbo.tblProductStockLogData
	(
		sstatus, PurchaseInvoiceID, ProductID, SubProductID, StoreID, ColorID, SizeID, QTY, OldQTY
		, BarcodeNo, CreatedBy
	)
	VALUES
	(
		'New QTY Added After Post', @PurchaseInvoiceID, @ProductID, @SubProductID, @StoreID, @ColorID, @SizeID, @QTY,@OldQTY
		, @BarcodeNo, @CreatedBy
	)

	SET @i+=1;
	    FETCH NEXT FROM ColorSize_CURSOR INTO @ProductID, @StoreID, @ColorID, @SizeID, @QTY, @BarcodeNo

	    END

	CLOSE ColorSize_CURSOR;
	DEALLOCATE ColorSize_CURSOR;
	
	SELECT @i=ISNULL(SUM(QTY),0) FROM dbo.ProductStockMaster WITH(NOLOCK) 
	WHERE PurchaseInvoiceID=@PurchaseInvoiceID AND SubProductID=@SubProductID AND QTY > 0
	--Below table added for re posting
	INSERT INTO [dbo].[PostingDeliveryEntry]
	(
		EntryType, PurchaseInvoiceID, SupplierBillNo, StoreID, PostingStatus, TotalQTY, CreatedBy
	)
	VALUES
	(
		@SubProductID, @PurchaseInvoiceID, @SupplierBillNo, @StoreID, 1, @i, @CreatedBy
	)
	--SELECT 1 AS Flag,'Purchase Invoice Posted successfully.' as Msg -- Means Data saved successfully
	SELECT @Flag=1,@Message='Purchase Invoice Posted successfully'

	COMMIT
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
		--,ISNULL(ERROR_PROCEDURE(),'spr_Update_PurchaseInvoice_BulkPrint_Color_Size')
		,ERROR_PROCEDURE()
		,@PARAMERES

		--SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured
		SELECT @Flag=-1,@Message=ERROR_MESSAGE()
	END CATCH
	
	END


END
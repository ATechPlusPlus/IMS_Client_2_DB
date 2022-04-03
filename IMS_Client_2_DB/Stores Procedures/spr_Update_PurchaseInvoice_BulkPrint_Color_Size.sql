-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <03th APR 2022>
-- Update date: <04th APR 2022>
-- Description:	<re posting purchase invoice>
-- =============================================
-- EXEC [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size] 2,3,10,0,'B201',5
-- EXEC [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size] 12,3,5,0,'V101',5
-- DROP PROCEDURE [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size]
CREATE PROCEDURE [dbo].[spr_Update_PurchaseInvoice_BulkPrint_Color_Size]
@PurchaseInvoiceID INT=0
,@StoreID INT=0
,@SupplierBillNo VARCHAR(MAX)
,@CreatedBy INT=0
,@dtOldPurchase as tblPurchaseInvoice_Color_sizeType READONLY
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
		DECLARE @SubProductID INT =0
		DECLARE @ColorID      INT =0
		DECLARE @QTY		  INT =0
		DECLARE @SizeID		  INT =0
		DECLARE @BarcodeNo    BIGINT=0
		--DECLARE @Size	 VARCHAR(20) ='0'
		
		DECLARE @OldQTY		  INT =0

		SET @PARAMERES=CONCAT(@PurchaseInvoiceID,',',@StoreID,',',@SupplierBillNo,',',@CreatedBy)
		
		DELETE FROM ProductStockMaster WHERE PurchaseInvoiceID=@PurchaseInvoiceID AND QTY = 0

		DECLARE ColorSize_CURSOR CURSOR 
		FOR
		
		SELECT ProductID,SubProductID, StoreID, ColorID, SizeID , QTY, BarcodeNo
		FROM dbo.ProductStockMaster WITH(NOLOCK)
		WHERE PurchaseInvoiceID=@PurchaseInvoiceID 
		AND QTY > 0
		

	OPEN ColorSize_CURSOR 

	FETCH NEXT FROM ColorSize_CURSOR INTO @ProductID, @SubProductID, @StoreID, @ColorID, @SizeID, @QTY, @BarcodeNo
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	--SELECT CONCAT(@PurchaseInvoiceID,',',@ProductID,',',@SubProductID,',', @StoreID,',', @ColorID,',', @SizeID,',' , @QTY)

	SET @i = 1

	IF EXISTS(SELECT 1 FROM ProductStockColorSizeMaster WITH(NOLOCK) WHERE ProductID=@ProductID AND SubProductID=@SubProductID AND ColorID=@ColorID AND StoreID=@StoreID AND SizeID=@SizeID)
	BEGIN

	--SELECT 'select',SubProductID,ProductID, StoreID, ColorID, SizeID , QTY
	--FROM ProductStockColorSizeMaster WITH(NOLOCK)
	--WHERE SubProductID=@SubProductID AND ProductID=@ProductID AND ColorID=@ColorID AND StoreID=@StoreID AND SizeID=@SizeID
		
		SELECT @OldQTY=QTY FROM @dtOldPurchase WHERE SubProductID=@SubProductID
		AND ProductID=@ProductID 
		AND ColorID=@ColorID 
		AND StoreID=@StoreID
		AND SizeID=@SizeID

		UPDATE ProductStockColorSizeMaster
		SET 
		--QTY = QTY + @QTY
		QTY = QTY - ABS(@OldQTY - @QTY)
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
	END

	SET @i+=1;
	    FETCH NEXT FROM ColorSize_CURSOR INTO @ProductID, @SubProductID, @StoreID, @ColorID, @SizeID, @QTY, @BarcodeNo

	    END

	CLOSE ColorSize_CURSOR;
	DEALLOCATE ColorSize_CURSOR;
	
	--SELECT 1 AS Flag,'Purchase Invoice Posted successfully.' as Msg -- Means Data saved successfully

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
		--,ISNULL(ERROR_PROCEDURE(),'Insert_PurchaseInvoice_BulkPrint_Color_Size')
		,ERROR_PROCEDURE()
		,@PARAMERES

		--SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured

	END CATCH
	
	END

	--ELSE
	--BEGIN
	
	--SELECT 0 AS Flag,'Purchase invoice detail is not found.' as Msg	-- Means Purchase invoice details is not found
	
	--END
END
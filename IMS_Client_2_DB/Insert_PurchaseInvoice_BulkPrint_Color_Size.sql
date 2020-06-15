-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <08th MARCH 2020>
-- Description:	<Description,,>
-- =============================================
-- EXEC [dbo].[Insert_PurchaseInvoice_BulkPrint_Color_Size] 1,1,100,1,'purinv01',0
CREATE PROCEDURE [dbo].[Insert_PurchaseInvoice_BulkPrint_Color_Size]
@PurchaseInvoiceID INT=0
,@StoreID INT=0
,@TotalQTY INT=0
,@EntryType INT=0
,@SupplierBillNo VARCHAR(50)
,@CreatedBy INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM DeliveryPurchaseBill1 WITH(NOLOCK) WHERE PurchaseInvoiceID=@PurchaseInvoiceID)
	BEGIN

		BEGIN TRY
		DECLARE @PARAMERES VARCHAR(MAX)=''
		BEGIN TRANSACTION
		DECLARE @SizeType_ID AS INT=0
		DECLARE @SizeValue AS VARCHAR(50)
		DECLARE @i AS INT=1
		DECLARE @DeliveryPurchaseID AS INT=0
		DECLARE @query1  AS VARCHAR(MAX)=''
		DECLARE @query2  AS VARCHAR(MAX)
		DECLARE @queryunpivot  AS VARCHAR(MAX)=''
		DECLARE @ModelNo NVARCHAR(50) =''
	
		DECLARE @ProductID INT =0
		DECLARE @ColorID INT =0
		DECLARE @QTY	 INT =0
		DECLARE @SizeID	 INT =0
		--DECLARE @Size	 VARCHAR(20) ='0'

		--IF OBJECT_ID('tempdb..#PurchaseInvoice_Color_Size') IS NOT NULL DROP TABLE #PurchaseInvoice_Color_Size
		--	CREATE TABLE #PurchaseInvoice_Color_Size
		--	(
		--	ID INT IDENTITY(1,1)
		--	,ColorID INT
		--	,Color	NVARCHAR(50)
		--	,ProductID INT
		--	,ProductName NVARCHAR(50)
		--	,StoreID INT
		--	,ModelNo NVARCHAR(50)
		--	,QTY INT
		--	,SizeID INT
		--	,Rate DECIMAL(18,2)
		--	,BarcodeNo BIGINT
		--	)

		SET @PARAMERES=CONCAT(@PurchaseInvoiceID,',',@StoreID,',',@EntryType,',',@SupplierBillNo,',',@CreatedBy)

		DECLARE ColorSize_CURSOR CURSOR 
		FOR
		--SELECT ProductID, StoreID, ColorID, Size , QTY
		--FROM #PurchaseInvoice_Color_Size
		--WHERE QTY > 0
		SELECT ProductID, StoreID, ColorID, SizeID , QTY
		FROM dbo.ProductStockMaster
		WHERE QTY > 0
		
		DECLARE OUTER_CURSOR CURSOR 
		FOR
		SELECT SizeTypeID,DeliveryPurchaseID1,ModelNo
		FROM DeliveryPurchaseBill1 WITH(NOLOCK)
		WHERE PurchaseInvoiceID=@PurchaseInvoiceID
		
		OPEN OUTER_CURSOR 
		
		FETCH NEXT FROM OUTER_CURSOR INTO @SizeType_ID,  @DeliveryPurchaseID, @ModelNo
		
		WHILE @@FETCH_STATUS <> -1
		BEGIN

			SET @i = 1
			SET @query1=''
			SET @queryunpivot=''

			DECLARE cursor_Size CURSOR
			FOR
			--SELECT Size FROM SizeMaster WITH(NOLOCK) WHERE SizeTypeID=@SizeType_ID;-- for Size value
			SELECT SizeID FROM SizeMaster WITH(NOLOCK) WHERE SizeTypeID=@SizeType_ID;-- for SizeID
	
			OPEN cursor_Size;
	
			FETCH NEXT FROM cursor_Size INTO @SizeValue

			WHILE @@FETCH_STATUS <> -1
				BEGIN

				SET @query1 += 'MAX(CASE WHEN pd2.Col'+CAST(@i AS VARCHAR)+' = pd2.Col'+cast(@i AS VARCHAR)+
				' THEN pd3.Col'+CAST(@i as VARCHAR)+' END) '+QUOTENAME(@SizeValue)+',';

				SET @queryunpivot += QUOTENAME(@SizeValue);

				SET @i+=1;
				FETCH NEXT FROM cursor_Size INTO @SizeValue;

				 IF @@FETCH_STATUS = 0 
					SET @queryunpivot +=',';

				END;

			CLOSE cursor_Size;
			DEALLOCATE cursor_Size;

	SET @query2='
	SELECT PurchaseInvoiceID,ColorID,ProductID,QTY,Size,ModelNo,Rate,StoreID FROM
	(SELECT pd1.PurchaseInvoiceID,
	clr.ColorID,pd1.ProductID,pd1.ModelNo,pm.Rate,pd1.StoreID,'+@query1+'pd3.Total,FROM DeliveryPurchaseBill1 pd1
	INNER JOIN DeliveryPurchaseBill2 pd2 ON pd2.DeliveryPurchaseID1=pd1.DeliveryPurchaseID1
	INNER JOIN DeliveryPurchaseBill3 pd3 ON pd3.DeliveryPurchaseID2=pd2.DeliveryPurchaseID2
	INNER JOIN ColorMaster clr ON pd3.ColorID=clr.ColorID
	INNER JOIN ProductMaster pm on pd1.ProductID = pm.ProductID
	WHERE 
	pd1.PurchaseInvoiceID='+CAST(@PurchaseInvoiceID AS VARCHAR)+' AND pd2.DeliveryPurchaseID1='+CAST(@DeliveryPurchaseID as VARCHAR)+' group by	pd1.PurchaseInvoiceID,pd1.ProductID,clr.ColorID,pd1.ModelNo,pm.Rate,pd1.StoreID,pd3.Total)a UNPIVOT
	(
	QTY
	FOR SIZE IN ('+@queryunpivot+')
	) unpvt'
	
	SET @query2=REPLACE(@query2,',FROM',' FROM');
	
	--PRINT @query1
	--PRINT @queryunpivot;
	--PRINT @query2
	
	IF @i = 1
	PRINT @query2;

	--INSERT INTO #PurchaseInvoice_Color_Size
	--(ColorID 
	--,Color	
	--,ProductID 
	--,ProductName
	--,QTY 
	--,Size 
	--,ModelNo
	--,Rate
	--,StoreID)
	
	INSERT INTO dbo.ProductStockMaster
	(PurchaseInvoiceID
	,ColorID 	
	,ProductID
	,QTY 
	,SizeID 
	,ModelNo
	,Rate
	,StoreID)
	EXEC (@query2);

FETCH NEXT FROM OUTER_CURSOR INTO @SizeType_ID,  @DeliveryPurchaseID, @ModelNo
END
CLOSE OUTER_CURSOR
DEALLOCATE OUTER_CURSOR

	OPEN ColorSize_CURSOR 

	FETCH NEXT FROM ColorSize_CURSOR INTO @ProductID, @StoreID, @ColorID, @SizeID , @QTY
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	--SELECT CONCAT(@PurchaseInvoiceID,',',@ProductID,',', @StoreID,',', @ColorID,',', @Size,',' , @QTY,',')

	SET @i = 1

	IF EXISTS(SELECT 1 FROM ProductStockColorSizeMaster WHERE ProductID=@ProductID AND ColorID=@ColorID AND StoreID=@StoreID
		AND SizeID=@SizeID)
	BEGIN
	
	--SELECT ProductID, StoreID, ColorID, Size , QTY
	--FROM ProductStockColorSizeMaster WITH(NOLOCK)
	--WHERE ProductID=@ProductID AND ColorID=@ColorID AND StoreID=@StoreID AND Size=@Size

		UPDATE ProductStockColorSizeMaster
		SET QTY = QTY + @QTY
		,UpdatedBy = @CreatedBy
		,UpdatedOn = getdate()
		WHERE 
		ProductID=@ProductID 
		AND ColorID=@ColorID 
		AND StoreID=@StoreID
		AND SizeID=@SizeID
	END

	ELSE
	BEGIN
		--SELECT 'insert',@ProductID, @StoreID, @ColorID, @Size , @QTY, @CreatedBy
		INSERT INTO ProductStockColorSizeMaster
		(
			ProductID, StoreID, ColorID, SizeID , QTY, CreatedBy
		)
		VALUES
		(
			@ProductID, @StoreID, @ColorID, @SizeID , @QTY, @CreatedBy
		)

	END

	SET @i+=1;
	    FETCH NEXT FROM ColorSize_CURSOR INTO @ProductID, @StoreID, @ColorID, @SizeID , @QTY

	    END

	CLOSE ColorSize_CURSOR;
	DEALLOCATE ColorSize_CURSOR;

	UPDATE PurchaseInvoice SET IsInvoiceDone = 1
	WHERE PurchaseInvoiceID = @PurchaseInvoiceID

	INSERT INTO [dbo].[PostingDeliveryEntry]
	(
	EntryType, PurchaseInvoiceID, SupplierBillNo, StoreID, PostingStatus, TotalQTY, CreatedBy
	)
	VALUES
	(
	@EntryType, @PurchaseInvoiceID, @SupplierBillNo, @StoreID, 1, @TotalQTY, @CreatedBy
	)

	SELECT 1 AS Flag,'Purchase Invoice Posted successfully.' as Msg -- Means Data saved successfully

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
		,ISNULL(ERROR_PROCEDURE(),'Insert_PurchaseInvoice_BulkPrint_Color_Size')
		,@PARAMERES

		SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured

	END CATCH
	
	END

	ELSE
	BEGIN
	
	SELECT 0 AS Flag,'Purchase invoice details is not found.' as Msg	-- Means Purchase invoice details is not found
	
	END
END
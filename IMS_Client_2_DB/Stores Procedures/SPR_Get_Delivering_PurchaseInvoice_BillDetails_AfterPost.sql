-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <02nd APR 2022>
-- Update date: <>
-- Description:	<Displaying purchased items details color size wise in tabulor format>
-- =============================================
-- EXEC [dbo].SPR_Get_Delivering_PurchaseInvoice_BillDetails_AfterPost 2074,2470,1
CREATE PROCEDURE [dbo].[SPR_Get_Delivering_PurchaseInvoice_BillDetails_AfterPost]
@PurchaseInvoiceID INT=0
,@SubProductID INT=0
,@StoreID INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@PurchaseInvoiceID,',',@SubProductID,',',@StoreID)

	IF EXISTS(SELECT 1 FROM DeliveryPurchaseBill1 WITH(NOLOCK) WHERE PurchaseInvoiceID=@PurchaseInvoiceID)
	BEGIN

		BEGIN TRY

		BEGIN TRANSACTION

		DECLARE @SizeType_ID AS INT=0
		DECLARE @SizeValue AS VARCHAR(MAX)
		DECLARE @i AS INT=1
		DECLARE @DeliveryPurchaseID AS INT=0
		DECLARE @query1  AS VARCHAR(MAX)=''
		DECLARE @query2  AS VARCHAR(MAX)
		DECLARE @queryunpivot  AS VARCHAR(MAX)=''
		DECLARE @ModelNo NVARCHAR(MAX) =''
	
		DECLARE @ProductID	  INT =0
		--DECLARE @SubProductID INT =0
		--DECLARE @ColorID	  INT =0
		--DECLARE @QTY		  INT =0
		--DECLARE @SizeID		  INT =0
		--DECLARE @Rate		  DECIMAL(18,3)=0
		
		IF OBJECT_ID('tempdb..#Temp_ProductStockMaster') IS NULL
		BEGIN

			CREATE TABLE #Temp_ProductStockMaster
			(
			TempID				INT IDENTITY(1,1) PRIMARY KEY
			,PurchaseInvoiceID  INT
			,ColorID 			INT
			,ProductID			INT
			,SubProductID		INT
			,QTY				INT
			,SizeID				INT
			,ModelNo			NVARCHAR(MAX)
			,Rate				DECIMAL(18,3)
			,StoreID			INT
			)

		END

		DECLARE OUTER_CURSOR CURSOR 
		FOR
		SELECT SizeTypeID,DeliveryPurchaseID1,ModelNo, ProductID
		FROM DeliveryPurchaseBill1 WITH(NOLOCK)
		WHERE PurchaseInvoiceID=@PurchaseInvoiceID AND SubProductID=@SubProductID
		
		OPEN OUTER_CURSOR 
		
		FETCH NEXT FROM OUTER_CURSOR INTO @SizeType_ID,  @DeliveryPurchaseID, @ModelNo, @ProductID
		
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

				SET @query1 += 'MAX(CASE pd2.Col'+CAST(@i AS VARCHAR)+' WHEN pd2.Col'+cast(@i AS VARCHAR)+
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
	SELECT PurchaseInvoiceID,ColorID,ProductID,SubProductID,QTY,Size,ModelNo,Rate,StoreID FROM
	(SELECT pd1.PurchaseInvoiceID,
	clr.ColorID,pd1.ProductID,pd1.SubProductID,pwm.ModelNo,pwm.EndUser [Rate],pd1.StoreID,'+@query1+'pd3.Total
	,FROM DeliveryPurchaseBill1 pd1
	INNER JOIN DeliveryPurchaseBill2 pd2 ON pd1.DeliveryPurchaseID1=pd2.DeliveryPurchaseID1
	INNER JOIN DeliveryPurchaseBill3 pd3 ON pd2.DeliveryPurchaseID2=pd3.DeliveryPurchaseID2 
	--AND pd3.DeliveryPurchaseID3=+CAST(@DeliveryPurchaseID3 AS VARCHAR)+
	INNER JOIN ColorMaster clr ON pd3.ColorID=clr.ColorID
	INNER JOIN ProductMaster pm on pd1.ProductID = pm.ProductID
	INNER JOIN tblProductWiseModelNo pwm ON pd1.ProductID=pwm.ProductID AND pd1.SubProductID=pwm.SubProductID
	--AND pwm.StoreID='+CAST(@StoreID AS VARCHAR)+'
	--LEFT OUTER JOIN ProductStockMaster psm ON pwm.ProductID=psm.ProductID AND pwm.SubProductID=psm.SubProductID
	WHERE pd1.StoreID='+CAST(@StoreID AS VARCHAR)+' --AND ISNULL(psm.PurchaseInvoiceID,0)!='+CAST(@PurchaseInvoiceID AS VARCHAR)+'
	AND pd1.SubProductID='+CAST(@SubProductID AS VARCHAR)+'
	AND pd1.PurchaseInvoiceID='+CAST(@PurchaseInvoiceID AS VARCHAR)+' AND pd2.DeliveryPurchaseID1='+CAST(@DeliveryPurchaseID as VARCHAR)+' GROUP BY pd1.PurchaseInvoiceID,pd1.ProductID,pd1.SubProductID,clr.ColorID,pwm.ModelNo,pwm.EndUser,pd1.StoreID,pd3.Total
	)a 
	UNPIVOT
	(
	QTY
	FOR SIZE IN ('+@queryunpivot+')
	) unpvt
	--WHERE QTY>0
	'
	
	SET @query2=REPLACE(@query2,',FROM',' FROM');

	--PRINT @query1
	--PRINT @queryunpivot;
	--PRINT @query2

	--IF NOT EXISTS(SELECT 1 FROM dbo.ProductStockMaster WITH(NOLOCK) WHERE 
	--PurchaseInvoiceID=@PurchaseInvoiceID AND StoreID=@StoreID AND SubProductID=@SubProductID AND ProductID=@ProductID)
	--BEGIN

		INSERT INTO #Temp_ProductStockMaster
		(PurchaseInvoiceID
		,ColorID 	
		,ProductID
		,SubProductID
		,QTY
		,SizeID 
		,ModelNo
		,Rate
		,StoreID)
		EXEC (@query2);
	--END
	--SELECT * FROM #Temp_ProductStockMaster
	FETCH NEXT FROM OUTER_CURSOR INTO @SizeType_ID,  @DeliveryPurchaseID, @ModelNo, @ProductID
	END
	CLOSE OUTER_CURSOR
	DEALLOCATE OUTER_CURSOR

	SELECT * FROM #Temp_ProductStockMaster
	DROP TABLE #Temp_ProductStockMaster
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
		,ISNULL(ERROR_PROCEDURE(),'Get_Delivering_PurchaseInvoice_BillDetails_AfterPost')
		,@PARAMERES

		SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured

	END CATCH
	
	END

	ELSE
	BEGIN
	
	SELECT 0 AS Flag,'Purchase invoice details is not found.' as Msg	-- Means Purchase invoice details is not found
	
	END
END
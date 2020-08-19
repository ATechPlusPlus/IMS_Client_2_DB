-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <29th FEB 2020>
-- Update date: <19th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
-- EXEC [dbo].[Get_PurchaseInvoice_Color_Size] '2470','cls-g700-711'
CREATE PROCEDURE [dbo].[Get_PurchaseInvoice_Color_Size]
@SupplierBillNo VARCHAR(MAX) =''
,@ModelNo NVARCHAR(MAX) =''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	--BEGIN TRANSACTION
	DECLARE @SizeType_ID AS INT=0
	DECLARE @SizeValue AS VARCHAR(50)
	DECLARE @i AS INT=1
	DECLARE @DeliveryPurchaseID AS INT=0
	DECLARE @query1  AS NVARCHAR(MAX)=''
	DECLARE @query2  AS NVARCHAR(MAX)

	SET @PARAMERES=CONCAT(@SupplierBillNo,',',@ModelNo)

	SELECT @SizeType_ID=SizeTypeID,@DeliveryPurchaseID=DeliveryPurchaseID1 
	FROM DeliveryPurchaseBill1 WITH(NOLOCK)
	WHERE ModelNo=''+@ModelNo+'' AND SupplierBillNo=''+@SupplierBillNo+''

DECLARE cursor_Size CURSOR
FOR
--SELECT SizeID FROM SizeMaster WITH(NOLOCK) WHERE SizeTypeID=@SizeType_ID;-- for Size value
SELECT Size FROM SizeMaster WITH(NOLOCK) WHERE SizeTypeID=@SizeType_ID;-- for SizeID

OPEN cursor_Size;

FETCH NEXT FROM cursor_Size INTO @SizeValue

	WHILE @@FETCH_STATUS = 0
	    BEGIN

		SET @query1 += N'MAX(CASE pd2.Col'+CAST(@i AS VARCHAR)+' WHEN pd2.Col'+CAST(@i AS VARCHAR)+
		' THEN pd3.Col'+CAST(@i as VARCHAR)+' END) '+QUOTENAME(@SizeValue)+',';
		SET @i+=1;
	        FETCH NEXT FROM cursor_Size INTO @SizeValue;

	    END;

CLOSE cursor_Size;
 
DEALLOCATE cursor_Size;

--PRINT @query1;

SET @query2='SELECT clr.ColorName AS Color,
clr.ColorID,pd3.DeliveryPurchaseID3,'+@query1+'pd3.Total,FROM DeliveryPurchaseBill1 pd1
INNER JOIN DeliveryPurchaseBill2 pd2 ON pd2.DeliveryPurchaseID1=pd1.DeliveryPurchaseID1
INNER JOIN DeliveryPurchaseBill3 pd3 ON pd3.DeliveryPurchaseID2=pd2.DeliveryPurchaseID2
INNER JOIN ColorMaster clr ON pd3.ColorID=clr.ColorID
WHERE 
pd1.SupplierBillNo='''+CAST(@SupplierBillNo AS VARCHAR)+'''AND pd2.DeliveryPurchaseID1='+CAST(@DeliveryPurchaseID as VARCHAR)+' 
GROUP BY pd3.DeliveryPurchaseID3,clr.ColorID,clr.ColorName,pd3.Total'

SET @query2=REPLACE(@query2,',FROM',' FROM');

--PRINT @query2;

--IF @i = 1
--PRINT @query2;

EXEC (@query2);
--EXEC sp_executesql @query2;

	--COMMIT
	END TRY
	
	BEGIN CATCH
    --ROLLBACK
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
	,ISNULL(ERROR_PROCEDURE(),'Get_PurchaseInvoice_Color_Size')
	,@PARAMERES
	END CATCH
END
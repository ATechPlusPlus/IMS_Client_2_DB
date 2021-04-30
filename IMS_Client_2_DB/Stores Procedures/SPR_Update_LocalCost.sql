-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <19th JAN 2021>
-- Update date: <01st MAY 2021>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Update_LocalCost '0',0
CREATE PROCEDURE [dbo].[SPR_Update_LocalCost]
@ModelNo NVARCHAR(MAX)='0'
,@CreatedBy INT=0
AS
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM tblProductWiseModelNo WITH(NOLOCK) WHERE ModelNo=IIF(@ModelNo='0',ModelNo,@ModelNo) 
	AND ISNULL(LocalCost,0)=0)

	BEGIN

	BEGIN TRY

	BEGIN TRANSACTION

	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@ModelNo,',',@CreatedBy)

	DECLARE @curSubProductID   INT =0
	DECLARE @LocalCost			DECIMAL(18,3) =0

	DECLARE LocalCost_CURSOR CURSOR 
	FOR	
	SELECT p2.SubProductID,
	--ISNULL(p2.ProductID,0)ProductID,ISNULL(p2.SubProductID,0)SubProductID,pm.ProductName,p2.ModelNo
	--,AVG(CAST(p1.LocalBillValue/p1.TotalQTY AS decimal(18,2))) [LocalCost AVG]
	SUM(p1.LocalBillValue)/SUM(p1.TotalQTY)--[LocalCost SUM]
	FROM [dbo].[PurchaseInvoice] p1
	LEFT OUTER JOIN [dbo].[PurchaseInvoiceDetails] p2 ON p1.PurchaseInvoiceID = p2.PurchaseInvoiceID
	LEFT OUTER JOIN [dbo].[ProductMaster] pm ON p2.ProductID = pm.ProductID
	LEFT OUTER JOIN [dbo].[BrandMaster] bm ON p2.BrandID = bm.BrandID AND p2.SupplierID = bm.SupplierID
	WHERE p2.ModelNo=IIF(@ModelNo='0',p2.ModelNo,@ModelNo)
	GROUP BY p2.ProductID,p2.SubProductID,p2.ModelNo

	OPEN LocalCost_CURSOR
	FETCH NEXT FROM LocalCost_CURSOR INTO @curSubProductID,@LocalCost

		WHILE @@FETCH_STATUS <> -1
		BEGIN

		UPDATE tblProductWiseModelNo 
		SET LocalCost=@LocalCost,UpdatedBy=@CreatedBy,
		UpdatedOn=GETDATE() 
		WHERE SubProductID=@curSubProductID
		AND ISNULL(LocalCost,0)=0

		FETCH NEXT FROM LocalCost_CURSOR INTO @curSubProductID,@LocalCost
		END

		CLOSE LocalCost_CURSOR;
		DEALLOCATE LocalCost_CURSOR;
	
	SELECT 1 AS Flag,'Local Cost Updated successfully.' as Msg -- Means Data saved successfully

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
		,ERROR_PROCEDURE()
		,@PARAMERES

		SELECT -1 AS Flag,ERROR_MESSAGE() as Msg -- Exception occured

	END CATCH
	END

	ELSE
	BEGIN

		SELECT 0 AS Flag,'No Record/Model No. is not found.' as Msg	-- Means Model No. details is not found

	END
END
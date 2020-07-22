-- =============================================
-- Author:		<MATEEN KHAN>
-- Create date: <12th JULY 2020>
-- Update date: <20th JULY 2020>
-- Description:	<>
-- =============================================
--EXEC spr_GetReplaceReturnDetails 1,1019
CREATE PROCEDURE [dbo].[spr_GetReplaceReturnDetails]
@InvoiceID int = 0
,@BarCode BIGINT=0
--,@BarCode nvarchar(50)
AS
	
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @StoreID INT=0
	SET @PARAMERES=CONCAT(@InvoiceID,',',@BarCode)

	

	SELECT * FROM (SELECT InvoiceID, ProductID,
	(SELECT ProductName from ProductMaster WHERE ProductID=s1.ProductID) AS ProductName,
	QTY,Rate,ColorID,
	(SELECT ColorName FROM ColorMaster WHERE ColorID=s1.ColorID) AS Color,
	(SELECT Size FROM SizeMaster WHERE SizeID=s1.SizeID) AS Size,SizeID,
	@BarCode AS BarCode FROM SalesDetails s1
	 WHERE InvoiceID=@InvoiceID) AS tb WHERE BarCode=@BarCode

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

RETURN 0
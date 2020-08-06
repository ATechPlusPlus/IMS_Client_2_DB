-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <14th MARCH 2020>
-- Update date: <06th AUGUST 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_Product_Master 'b',3
CREATE PROCEDURE [dbo].[Get_Product_Master]
@ProductName NVARCHAR(100)='0',
@CategoryId INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES = concat(@ProductName,',',@CategoryId) 
	--SET @PARAMERES=@ProductName

	SET NOCOUNT ON;
	IF @ProductName = '0' AND @CategoryId = 0
	BEGIN

		SELECT pm.ProductID,pm.ProductName AS [ItemName],pm.ProductArabicName [Arabic Name],pm.CategoryID,cm.CategoryName AS [Department]
		,(CASE pm.ActiveStatus WHEN 1 THEN 'Active' WHEN 0 THEN 'InActive' END)ActiveStatus
		FROM ProductMaster pm
		INNER JOIN CategoryMaster cm ON pm.CategoryID = cm.CategoryID
		ORDER BY cm.CategoryName

	END

	ELSE
	BEGIN
	
		SELECT pm.ProductID,pm.ProductName AS [ItemName],pm.ProductArabicName [Arabic Name],pm.CategoryID,cm.CategoryName AS [Department]
		,(CASE pm.ActiveStatus WHEN 1 THEN 'Active' WHEN 0 THEN 'InActive' END)ActiveStatus
		FROM ProductMaster pm
		INNER JOIN CategoryMaster cm ON pm.CategoryID = cm.CategoryID
		WHERE 
		pm.ProductName LIKE ''+IIF(@ProductName='0',pm.ProductName,@ProductName)+'%' 
		AND pm.CategoryID = IIF(@CategoryId=0,pm.CategoryID,@CategoryId)
		ORDER BY cm.CategoryName

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
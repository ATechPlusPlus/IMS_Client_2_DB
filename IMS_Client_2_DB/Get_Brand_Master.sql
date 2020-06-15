-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <14th MARCH 2020>
-- Description:	<Description,,>
-- =============================================
--EXEC Get_Brand_Master '0'
--EXEC Get_Brand_Master 'brand1'
CREATE PROCEDURE Get_Brand_Master
@BrandName NVARCHAR(100)='0'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@BrandName

	SET NOCOUNT ON;
	IF @BrandName = '0'
	BEGIN

	SELECT bm.BrandID,bm.BrandName,bm.SupplierID,cm.CountryID
	,sm.SupplierName,cm.CountryName,
	(CASE WHEN bm.ActiveStatus =1 THEN 'Active' WHEN bm.ActiveStatus =0 THEN 'InActive' END)ActiveStatus
	FROM [dbo].[BrandMaster] bm
	INNER JOIN [dbo].[SupplierMaster] sm ON bm.SupplierID = sm.SupplierID
	INNER JOIN [dbo].[CountryMaster] cm ON sm.CountryID = cm.CountryID

	END

	ELSE
	BEGIN
	
	SELECT bm.BrandID,bm.BrandName,bm.SupplierID,cm.CountryID
	,sm.SupplierName,cm.CountryName,
	(CASE WHEN bm.ActiveStatus =1 THEN 'Active' WHEN bm.ActiveStatus =0 THEN 'InActive' END)ActiveStatus
	FROM [dbo].[BrandMaster] bm
	INNER JOIN [dbo].[SupplierMaster] sm ON bm.SupplierID = sm.SupplierID
	INNER JOIN [dbo].[CountryMaster] cm ON sm.CountryID = cm.CountryID
	WHERE bm.BrandName LIKE ''+@BrandName+'%'

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <05th AUGUST 2020>
-- Update date: <05th AUGUST 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_ProductPhoto 1,0
CREATE PROCEDURE SPR_Get_ProductPhoto
@SubProductID INT=0
,@ProductID INT=0
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@SubProductID,',',@ProductID)

	IF @SubProductID > 0
	BEGIN

		SELECT (CASE WHEN MAX(ISNULL(a.ImagePath,0))='0' THEN '0' WHEN MAX(ISNULL(a.Photo,0))='0' THEN '0' ELSE '1' END) Flag,
		MAX(ISNULL(a.ImagePath,0)) [ImagePath] 
		,MAX(a.Extension) [Extension]
		,MAX(ISNULL(a.Photo,0)) [Photo]
		,CONCAT(MAX(ISNULL(a.ImagePath,0)),'\',MAX(ISNULL(a.Photo,0)),MAX(a.Extension)) [ImgName]
		FROM
		(
			SELECT NULL [ImagePath],NULL [Extension],Photo
			FROM tblProductWiseModelNo WITH(NOLOCK)
			WHERE SubProductID=@SubProductID

			UNION

			SELECT ImagePath,Extension, NULL [Photo]
			FROM DefaultStoreSetting WITH(NOLOCK)
			WHERE MachineName=HOST_NAME()
		)a

	END

	ELSE IF @SubProductID = 0 AND @ProductID > 0
	BEGIN

	SELECT (CASE WHEN MAX(ISNULL(a.ImagePath,0))='0' THEN '0' WHEN MAX(ISNULL(a.Photo,0))='0' THEN '0' ELSE '1' END) Flag,
		MAX(ISNULL(a.ImagePath,0)) [ImagePath] 
		,MAX(a.Extension) [Extension]
		,MAX(ISNULL(a.Photo,0)) [Photo]
		,CONCAT(MAX(ISNULL(a.ImagePath,0)),'\',MAX(ISNULL(a.Photo,0)),MAX(a.Extension)) [ImgName]
		FROM
		(
			SELECT NULL [ImagePath],NULL [Extension],Photo
			FROM ProductMaster WITH(NOLOCK)
			WHERE ProductID=@ProductID

			UNION

			SELECT ImagePath,Extension, NULL [Photo]
			FROM DefaultStoreSetting WITH(NOLOCK)
			WHERE MachineName=HOST_NAME()
		)a

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
	
	SELECT -1 AS Flag,ERROR_MESSAGE() [Msg]

	END CATCH

END
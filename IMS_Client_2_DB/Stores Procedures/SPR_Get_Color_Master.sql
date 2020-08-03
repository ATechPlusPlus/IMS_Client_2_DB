-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <03th AUGUST 2020>
-- Description:	<>
-- =============================================
--EXEC SPR_Get_Color_Master '0'
CREATE PROCEDURE [dbo].[SPR_Get_Color_Master]
@ColorName NVARCHAR(MAX)='0'
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=@ColorName

	IF @ColorName = '0'
	BEGIN

	SELECT ColorID,ColorName,(CASE ActiveStatus WHEN 1 THEN 'Active' WHEN 0 THEN 'InActive' END) ActiveStatus
	FROM ColorMaster WITH(NOLOCK)
	ORDER BY ColorName

	END

	ELSE

	BEGIN

	SELECT ColorID,ColorName,(CASE ActiveStatus WHEN 1 THEN 'Active' WHEN 0 THEN 'InActive' END) ActiveStatus
	FROM ColorMaster WITH(NOLOCK)
	WHERE ColorName LIKE '%'+@ColorName+'%'
	ORDER BY ColorName

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
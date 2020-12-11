-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <11th DEC 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[SPR_Insert_Company] 0,0,0,0,0,0
CREATE PROCEDURE [dbo].[SPR_Insert_Company]
@CompanyName NVarChar(MAX)=0
,@Address NVarChar(MAX)=0
,@MobileNo VarChar(MAX)=0
,@EmailID VarChar(MAX)=0
,@IsDefault BIT=0
,@CreatedBy INT=0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@CompanyName,',',@Address,',',@MobileNo,',',@EmailID,',',@IsDefault,',',@CreatedBy)

	BEGIN TRANSACTION

	INSERT CompanyMaster
	(
		CompanyName,[Address],MobileNo,EmailID,IsDefault,CreatedBy
	)
	VALUES
	(
		@CompanyName,@Address,@MobileNo,@EmailID,@IsDefault,@CreatedBy
	)

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
	
	END CATCH

END
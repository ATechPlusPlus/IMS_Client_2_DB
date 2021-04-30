-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <30th APR 2021>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Update_LocalCost_By_SubProductID 0,0,0
CREATE PROCEDURE [dbo].[SPR_Update_LocalCost_By_SubProductID]
@SubProductID INT=0
,@LocalCost DECIMAL(18,3)=0
,@UpdatedBy INT=0

AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

	BEGIN TRANSACTION

	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@SubProductID,',',@LocalCost,',',@UpdatedBy)

	UPDATE tblProductWiseModelNo 
	SET LocalCost=@LocalCost,UpdatedBy=@UpdatedBy,
	UpdatedOn=GETDATE() WHERE SubProductID=@SubProductID

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
-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <06th Sept 2020>
-- Update date: <>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_CheckDiscountPass_VoucherNo '','123'
CREATE PROCEDURE SPR_CheckDiscountPass_VoucherNo
@Pass VARCHAR(MAX) =''
,@VoucherNo VARCHAR(MAX) =''
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	DECLARE @VoucherCount INT=0
	SET @PARAMERES = CONCAT(@Pass,',',@VoucherNo)

	SELECT @VoucherCount=COUNT(1)
	FROM [dbo].[SalesInvoiceDetails] WITH(NOLOCK) WHERE VoucherNo=@VoucherNo

	SELECT UserID,UserName,IsAdmin,@VoucherCount [VoucherCount]
	FROM dbo.UserManagement WITH(NOLOCK) 
	WHERE [Password]=@Pass
	AND ISNULL(IsBlock,0)=0

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
GO
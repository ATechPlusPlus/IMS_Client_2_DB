-- =============================================
-- Author:		<AAMIR KHAN>
-- Create date: <14th OCT 2020>
-- Update date: <19th JAN 2022>
-- Description:	<Description,,>
-- =============================================
--EXEC SPR_Get_ScanInventoryList
CREATE PROCEDURE [dbo].[SPR_Get_ScanInventoryList]
@FromDate DATE=NULL
,@ToDate DATE=NULL
,@StoreID INT=-1
,@CompareStatus INT=-1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	BEGIN TRY
	DECLARE @PARAMERES VARCHAR(MAX)=''
	SET @PARAMERES=CONCAT(@FromDate,',',@ToDate,',',@StoreID,',',@CompareStatus)

	SET NOCOUNT ON;
	
	SELECT std.MasterScanID,sm.StoreName,std.ScanDate [Scanned Date],std.StoreID
	,(CASE std.CompareStatus WHEN 1 THEN 'Done' WHEN 0 THEN 'Pending' END) [Compare Status]
	,emd.Name [Scanned By], emd1.Name [Compared By],CONVERT(DATE,std.UpdatedOn) [Compared Date]
	,std.CompareStatus
	FROM tblScanInventoryDetails std
	INNER JOIN StoreMaster sm ON std.StoreID=sm.StoreID
	INNER JOIN EmployeeDetails emd ON std.CreatedBy=emd.EmpID
	LEFT OUTER JOIN
	(
		SELECT EmpID,Name FROM EmployeeDetails WITH(NOLOCK)
	)emd1 ON std.UpdatedBy=emd1.EmpID
	WHERE std.StoreID= IIF(@StoreID=-1,std.StoreID,@StoreID)
	AND std.ScanDate BETWEEN ISNULL(@FromDate,std.ScanDate) AND ISNULL(@ToDate,std.ScanDate)
	AND std.CompareStatus=IIF(@CompareStatus=-1,std.CompareStatus,@CompareStatus)
	ORDER BY std.ScanDate DESC

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
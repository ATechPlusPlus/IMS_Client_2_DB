/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
TRUNCATE TABLE tblFormRightDetails

SET IDENTITY_INSERT [dbo].[tblFormRightDetails] ON 
GO

INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (1, N'Master', NULL, 0, N'سادة')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (2, N'Purchase', NULL, 0, N'شراء')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (3, N'Sales', NULL, 0, N'مبيعات')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (4, N'Bar Code', NULL, 0, N'الرمز الشريطي')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (5, N'Stock Manager', NULL, 0, N'مدير الأسهم')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (6, N'Report', NULL, 0, N'تقرير')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (7, N'Setting', NULL, 0, N'الإعدادات')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (8, N'Inventory', NULL, 0, N'المخزون')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (9, N'Brand Master', N'Brand_Master', 1, N'العلامة التجارية تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (10, N'Category Master', N'Category_Master', 1, N'الفئة تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (11, N'Color Master', N'Color_Master', 1, N'لون تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (12, N'Customer Master', N'Customer_Master', 1, N'العملاء تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (13, N'Country Master', N'Country_Master', 1, N'بلد تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (14, N'Item Master', N'Product_Master', 1, N'البنود تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (15, N'Employee Details', N'Employee_Details', 1, N'تفاصيل الموظف')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (16, N'Size Master', N'Size_Master', 1, N'بحجم تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (17, N'Size Type_Master', N'Size_Type_Master', 1, N'الحجم نوع تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (18, N'Store Master', N'Store_Master', 1, N'مخزن تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (19, N'Supplier Details', N'Supplier_Details', 1, N'تفاصيل المورد')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (20, N'Material Details', N'Material_Details', 5, N'تفاصيل مادية')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (21, N'Currency Value Settings', N'Currency_Value_Settings', 7, N'العملة قيمة إعدادات')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (22, N'Other Settings', N'frmOtherSetting', 7, N'اخرى إعدادات')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (23, N'Sales Bill Details', N'Sales_Bill_Details', 3, N'المبيعات فاتورة تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (24, N'Sales Invoice', N'Sales_Invoice', 3, N'المبيعات فاتورة')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (25, N'Sales Report', N'frmSalesReport', 6, N'المبيعات تقرير')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (26, N'Delivering Purchase_Bill', N'Delivering_Purchase_Bill', 2, N'تسليم فاتورة الشراء')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (27, N'Diff Purchase Received', N'frmDiffPurchaseReceived', 2, N'فرق شراء وردت')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (28, N'Diff Purchase Recevied Details', N'frmDiffPurchaseReceviedDetails', 2, N'فرق شراء وردت التفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (29, N'Posting Delivery', N'Posting_Delivery', 2, N'نشر توصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (30, N'Purchase Bill Details', N'Purchase_Bill_Details', 2, N'فاتورة الشراء التفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (31, N'Purchase Invoice', N'Purchase_Invoice', 2, N'فاتورة الشراء')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (32, N'Bar Code', N'frmBarCode', 4, N'الباركود')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (33, N'Bard Code Designer', N'frmBarCodeDesigner', 4, N'الباركود مصمم')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (34, N'Close CashBand Master', N'frmCloseCashBandMaster', 1, N'إغلاق النقدية الفرقة تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (35, N'Cash CloseShif Window', N'frmCloseShifWindow', 3, N'النقدية إغلاق نافذة التحول')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (36, N'Import Product Master Data', N'Import_ProductData', 1, N'استيراد بيانات المنتج الرئيسية')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (37, N'Branch Sale Shorting', N'frmBranchSaleShorting', 5, N'فرع بيع قصير')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (38, N'Item Wise ModelNo', N'frmItemWiseModelNo', 5, N'رقم طراز البند الحكيم')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (39, N'Store Transfer', N'frmStoreTransfer', 5, N'مخزن نقل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (40, N'Transfer Check', N'frmTransferCheck', 5, N'نقل تحقق')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (41, N'Transfer Watch', N'frmTransferWatch', 5, N'نقل راقب')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (42, N'Transfer Watch Items', N'frmTransferWatch_Items', 5, N'نقل راقب البنود')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (43, N'Stock Details', N'frmStockDetails', 5, N'تفاصيل الأسهم')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (44, N'PettyCash Exp Report', N'frmPettyCashExpReport', 6, N'تقرير تصدير المصروفات النثرية')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (45, N'Mini Sales Report', N'tblMiniSalesReport', 6, N'تقرير مبيعات ميني')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (46, N'Purchase Details', N'frmPurchaseDetails', 2, N'تفاصيل شراء')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (47, N'Received Branch Transfer', N'frmReceivedBranchTransfer', 5, N'تم استلام تحويل الفرع')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (48, N'DashBoard Settings', N'frmDashBoardSettings', 3, N'إعدادات لوحة القيادة')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (49, N'DashBoard', N'frmDashBoard', 3, N'لوحة القيادة')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (50, N'Quick BarCode Print', N'frmQuickBarCodePrint', 4, N'سريعة الباركود طباعة')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (51, N'Discount Login', N'frmDiscountLogin', 3, N'خصم تسجيل الدخول')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (52, N'Scan Inventory', N'frmScanInventory', 8, N'الممسوحة ضوئيا المخزون')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (53, N'Scanned Inventory List', N'frmScanInventoryList', 8, N'قائمة الجرد الممسوحة ضوئيا')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (54, N'Scanned Inventory Compare', N'frmScanInventoryCompare', 8, N'المخزون الممسوحة ضوئيا مقارنة')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (55, N'Company Master', N'frmCompanyMaster', 1, N'شركة تفاصيل')
GO

INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (56, N'Employee Sales', N'frmEmployeeSales', 1, N'شركة تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (57, N'Sales Analys Report', N'frmSalesAnalysReport', 1, N'شركة تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (58, N'Sales By Department', N'frmSalesByDepartment', 1, N'شركة تفاصيل')
GO
INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID], [FormName_AR]) VALUES (59, N'Stock Pricing Report', N'frmStockPricingReport', 1, N'شركة تفاصيل')
GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (1, N'Master', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (2, N'Purchase', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (3, N'Sales', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (4, N'Bar Code', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (5, N'Stock Manager', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (6, N'Report', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (7, N'Setting', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (8, N'Inventory', NULL, 0)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (9, N'Brand Master', N'Brand_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (10, N'Category Master', N'Category_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (11, N'Color Master', N'Color_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (12, N'Customer Master', N'Customer_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (13, N'Country Master', N'Country_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (14, N'Item Master', N'Product_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (15, N'Employee Details', N'Employee_Details', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (16, N'Size Master', N'Size_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (17, N'Size Type_Master', N'Size_Type_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (18, N'Store Master', N'Store_Master', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (19, N'Supplier Details', N'Supplier_Details', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (20, N'Material Details', N'Material_Details', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (21, N'Currency Value Settings', N'Currency_Value_Settings', 7)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (22, N'Other Settings', N'frmOtherSetting', 7)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (23, N'Sales Bill Details', N'Sales_Bill_Details', 3)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (24, N'Sales Invoice', N'Sales_Invoice', 3)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (25, N'Sales Report', N'frmSalesReport', 6)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (26, N'Delivering Purchase_Bill', N'Delivering_Purchase_Bill', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (27, N'Diff Purchase Received', N'frmDiffPurchaseReceived', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (28, N'Diff Purchase Recevied Details', N'frmDiffPurchaseReceviedDetails', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (29, N'Posting Delivery', N'Posting_Delivery', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (30, N'Purchase Bill Details', N'Purchase_Bill_Details', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (31, N'Purchase Invoice', N'Purchase_Invoice', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (32, N'Bar Code', N'frmBarCode', 4)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (33, N'Bard Code Designer', N'frmBarCodeDesigner', 4)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (34, N'Close CashBand Master', N'frmCloseCashBandMaster', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (35, N'Cash CloseShif Window', N'frmCloseShifWindow', 3)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (36, N'Import Product Master Data', N'Import_ProductData', 1)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (37, N'Branch Sale Shorting', N'frmBranchSaleShorting', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (38, N'Item Wise ModelNo', N'frmItemWiseModelNo', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (39, N'Store Transfer', N'frmStoreTransfer', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (40, N'Transfer Check', N'frmTransferCheck', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (41, N'Transfer Watch', N'frmTransferWatch', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (42, N'Transfer Watch Items', N'frmTransferWatch_Items', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (43, N'Stock Details', N'frmStockDetails', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (44, N'PettyCash Exp Report', N'frmPettyCashExpReport', 6)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (45, N'Mini Sales Report', N'tblMiniSalesReport', 6)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (46, N'Purchase Details', N'frmPurchaseDetails', 2)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (47, N'Received Branch Transfer', N'frmReceivedBranchTransfer', 5)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (48, N'DashBoard Settings', N'frmDashBoardSettings', 3)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (49, N'DashBoard', N'frmDashBoard', 3)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (50, N'Quick BarCode Print', N'frmQuickBarCodePrint', 4)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (51, N'Discount Login', N'frmDiscountLogin', 3)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (52, N'Scan Inventory', N'frmScanInventory', 8)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (53, N'Scanned Inventory List', N'frmScanInventoryList', 8)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (54, N'Scanned Inventory Compare', N'frmScanInventoryCompare', 8)
--GO
--INSERT [dbo].[tblFormRightDetails] ([FormID], [FormName], [Form_Name], [ParentID]) VALUES (55, N'Company Master', N'frmCompanyMaster', 1)
--GO

SET IDENTITY_INSERT [dbo].[tblFormRightDetails] OFF
GO
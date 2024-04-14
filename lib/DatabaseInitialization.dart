import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Database/DatabaseHandler.dart';
import 'package:maintenance/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;

Future<Database> initializeDB(BuildContext? context) async {
  String path = await getDatabasesPath();
  // String xmlString = await DefaultAssetBundle.of(context).loadString("assets/tables.xml");
//   String xmlString = """
//   <data>
//     <table>
//         <create_statement>
//             CREATE TABLE ACT1([ID] [int],[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[Competitor] [nvarchar](150) NULL,[ItemCode] [nvarchar](100) NULL,[ItemName]
//             [nvarchar](150) NULL,[Quantity] [decimal](10, 2) NULL,[CreateDate][datetime]
//             NULL,[UOM] [nvarchar](50) NULL,[Price]
//             [decimal](10, 2) NULL ,[UpdateDate] [datetime] NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ACT1_Temp([ID] [int],[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[Competitor] [nvarchar](150) NULL,[ItemCode] [nvarchar](100) NULL,[ItemName]
//             [nvarchar](150) NULL,[Quantity] [decimal](10, 2) NULL,[CreateDate][datetime]
//             NULL,[UOM] [nvarchar](50) NULL,[Price]
//             [decimal](10, 2) NULL ,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DOCN([ID] [int] ,[DocName] [nvarchar](50) ,[DocNumber] [int]
//             NULL,[MDocNumber] [int] NULL,[CreateDate][datetime]
//             NULL,[Notes] [nvarchar](150) NULL ,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DOCN_Temp([ID] [int] ,[DocName] [nvarchar](50) ,[DocNumber] [int]
//             NULL,[MDocNumber] [int] NULL,[CreateDate][datetime]
//             NULL,[Notes] [nvarchar](150) NULL ,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ACT2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[CreateDate][datetime]
//             NULL,[ItemName] [nvarchar](150) NULL,[UpdateDate] [datetime] NULL,[Quantity]
//             [decimal](10, 2) NULL,
//             [UOM] [nvarchar](50) NULL, [Price] [decimal](10, 2) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ACT2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[CreateDate][datetime]
//             NULL,[ItemName] [nvarchar](150) NULL,[UpdateDate] [datetime] NULL,[Quantity]
//             [decimal](10, 2) NULL,
//             [UOM] [nvarchar](50) NULL, [Price] [decimal](10, 2) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ACT3([ID] [int],[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[DocName]
//             [nvarchar](100) NULL,[CreateDate][datetime]
//             NULL,[DocPath] [nvarchar](150) NULL,[Remarks] [nvarchar](150) NULL,[UpdateDate]
//             [datetime] NULL,[Quantity]
//             [decimal](10, 2) NULL,  [has_created] [int] NULL DEFAULT (0), [is_header] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ACT3_Temp([ID] [int],[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[DocName]
//             [nvarchar](100) NULL,[CreateDate][datetime]
//             NULL,[DocPath] [nvarchar](150) NULL,[Remarks] [nvarchar](150) NULL,[UpdateDate]
//             [datetime] NULL,[Quantity]
//             [decimal](10, 2) NULL, [has_created] [int] NULL DEFAULT (0), [is_header] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Controller([ID] [int] NULL,
// 	[ControllerName] [varchar](50) NULL,
// 	[EmployeeId] [int] NULL,
// 	[Allowed] [bit] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Controller_Temp([ID] [int] NULL,
// 	[ControllerName] [varchar](50) NULL,
// 	[EmployeeId] [int] NULL,
// 	[Allowed] [bit] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Employee([ID] [int] NULL,
// 	[FirstName] [varchar](50) NULL,
// 	[LastName] [varchar](50) NULL,
// 	[Gender] [varchar](50) NULL,
// 	[Login] [varchar](50) NULL,
// 	[Password] [varchar](50) NULL,
// 	[Email] [varchar](50) NULL,
// 	[EmployeeTypeId] [numeric](3, 0) NULL,
// 	[RightId] [numeric](4, 0) NULL,
// 	[RankId] [tinyint] NULL,
// 	[DepartmentId] [int] NULL,
// 	[Designation] [varchar](50) NULL,
// 	[Probation] [tinyint] NULL,
// 	[RegistrationDate] [datetime] NULL,
// 	[Casual] [numeric](3, 0) NULL,
// 	[Earned] [numeric](3, 0) NULL,
// 	[Active] [numeric](2, 0) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Employee_Temp([ID] [int] NULL,
// 	[FirstName] [varchar](50) NULL,
// 	[LastName] [varchar](50) NULL,
// 	[Gender] [varchar](50) NULL,
// 	[Login] [varchar](50) NULL,
// 	[Password] [varchar](50) NULL,
// 	[Email] [varchar](50) NULL,
// 	[EmployeeTypeId] [numeric](3, 0) NULL,
// 	[RightId] [numeric](4, 0) NULL,
// 	[RankId] [tinyint] NULL,
// 	[DepartmentId] [int] NULL,
// 	[Designation] [varchar](50) NULL,
// 	[Probation] [tinyint] NULL,
// 	[RegistrationDate] [datetime] NULL,
// 	[Casual] [numeric](3, 0) NULL,
// 	[Earned] [numeric](3, 0) NULL,
// 	[Active] [numeric](2, 0) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE COUNTRY([ID] [int],
// 	[CountryName] [nvarchar](150) NULL,
// 	[Active] [bit] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE COUNTRY_Temp([ID] [int],
// 	[CountryName] [nvarchar](150) NULL,
// 	[Active] [bit] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Action([ControllerId] [int] NULL,
// 	[ActionName] [varchar](50) NULL,
// 	[Allowed] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Action_Temp([ControllerId] [int] NULL,
// 	[ActionName] [varchar](50) NULL,
// 	[Allowed] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE BPMG([ID] [int],
// 	[Code] [nvarchar](150) NULL,
// 	[ShortDesc] [text] NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE BPMG_Temp([ID] [int],
// 	[Code] [nvarchar](150) NULL,
// 	[ShortDesc] [text] NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE BPSG([ID] [int],
// 	[Code] [nvarchar](150) NULL,
// 	[ShortDesc] [text] NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE BPSG_Temp([ID] [int],
// 	[Code] [nvarchar](150) NULL,
// 	[ShortDesc] [text] NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE BusinessInfo([ID] [varchar](50) NULL,
// 	[Serial] [int] NULL,
// 	[Name] [nchar](500) NULL,
// 	[Address] [nchar](500) NULL,
// 	[MobileNo] [nchar](500) NULL,
// 	[email] [nchar](500) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE BusinessInfo_Temp([ID] [varchar](50) NULL,
// 	[Serial] [int] NULL,
// 	[Name] [nchar](500) NULL,
// 	[Address] [nchar](500) NULL,
// 	[MobileNo] [nchar](500) NULL,
// 	[email] [nchar](500) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRD1([ID] [int],[Code] [nvarchar](50) ,[RowId] [int] NULL,[FirstName]
//             [nvarchar](50) ,[MiddleName] [nvarchar](50) NULL,[LastName] [nvarchar](50)
//             NULL,[JobTitle] [nvarchar](50) NULL,[Position] [nvarchar](50) NULL,[Department]
//             [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[Email] [nvarchar](50) NULL,[Gender]
//             [nvarchar](50) NULL,[DateOfBirth] [datetime] NULL,[Active] [bit] NULL,[Attachment] [nvarchar]
//             NULL,[Address] [nvarchar] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRD1_Temp([ID] [int],[Code] [nvarchar](50) ,[RowId] [int] NULL,[FirstName]
//             [nvarchar](50) ,[MiddleName] [nvarchar](50) NULL,[LastName] [nvarchar](50)
//             NULL,[JobTitle] [nvarchar](50) NULL,[Position] [nvarchar](50) NULL,[Department]
//             [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[Email] [nvarchar](50) NULL,[Gender]
//             [nvarchar](50) NULL,[DateOfBirth] [datetime] NULL,[Active] [bit] NULL,[Attachment] [nvarchar]
//             NULL,[Address] [nvarchar] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRD2([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](50) NULL,[Address] [nvarchar] NULL,[CityCode] [nvarchar](50) NULL,[CityName]
//             [nvarchar](150) NULL,[StateCode] [nvarchar](50) NULL,[StateName] [nvarchar](150)
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](50) NULL,[Latitude]
//             [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode] [nvarchar](50)
//             NULL,[RouteName] [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL,ShopSizeUom nvarchar(50),[UpdateDate] [datetime] NULL,[ShopSize] [int]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRD2_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](50) NULL,[Address] [nvarchar] NULL,[CityCode] [nvarchar](50) NULL,[CityName]
//             [nvarchar](150) NULL,[StateCode] [nvarchar](50) NULL,[StateName] [nvarchar](150)
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](50) NULL,[Latitude]
//             [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode] [nvarchar](50)
//             NULL,[RouteName] [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL,ShopSizeUom nvarchar(50),[UpdateDate] [datetime] NULL,[ShopSize] [int]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRD3([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](50) NULL,[Address] [nvarchar] NULL,[CityCode] [nvarchar](50) NULL,[CityName]
//             [nvarchar](150) NULL,[StateCode] [nvarchar](50) NULL,[StateName] [nvarchar](150)
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](50) NULL,[Latitude]
//             [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRD3_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](50) NULL,[Address] [nvarchar] NULL,[CityCode] [nvarchar](50) NULL,[CityName]
//             [nvarchar](150) NULL,[StateCode] [nvarchar](50) NULL,[StateName] [nvarchar](150)
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](50) NULL,[Latitude]
//             [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRO1([ID] [int],
// 	[TransId] [nvarchar](50) NULL,
// 	[EmpGroupId] [int] NULL,
// 	[RowId] [int] NULL,
// 	[ExpId] [int] NULL,
// 	[ExpShortDesc] [nvarchar](150) NULL,
// 	[Based] [nvarchar](150) NULL,
// 	[ValidFrom] [datetime] NULL,
// 	[ValidTo] [datetime] NULL,
// 	[Remarks] [nvarchar](150) NULL,
// 	[Mandatory] [bit] NULL,
// 	[Amount] [decimal](10, 2) NULL,
// 	[Factor] [decimal](10, 2) NULL,
// 	[RAmount] [decimal](10, 2) NULL,
// 	[RRemarks] [nvarchar](100) NULL,
// 	[AAmount] [decimal](10, 2) NULL,
// 	[ARemarks] [nvarchar](100) NULL,
// 	[ReconAmt] [decimal](10, 2) NULL,
// 	[DiffAmount] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRO1_Temp([ID] [int],
// 	[TransId] [nvarchar](50) NULL,
// 	[EmpGroupId] [int] NULL,
// 	[RowId] [int] NULL,
// 	[ExpId] [int] NULL,
// 	[ExpShortDesc] [nvarchar](150) NULL,
// 	[Based] [nvarchar](150) NULL,
// 	[ValidFrom] [datetime] NULL,
// 	[ValidTo] [datetime] NULL,
// 	[Remarks] [nvarchar](150) NULL,
// 	[Mandatory] [bit] NULL,
// 	[Amount] [decimal](10, 2) NULL,
// 	[Factor] [decimal](10, 2) NULL,
// 	[RAmount] [decimal](10, 2) NULL,
// 	[RRemarks] [nvarchar](100) NULL,
// 	[AAmount] [decimal](10, 2) NULL,
// 	[ARemarks] [nvarchar](100) NULL,
// 	[ReconAmt] [decimal](10, 2) NULL,
// 	[DiffAmount] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//
//     <table>
//         <create_statement>
//             CREATE TABLE CRT1([ID] [int] ,
// 	[NID] [nvarchar](50) NULL,
// 	[TransId] [nvarchar](150) NULL,
// 	[CardCode] [nvarchar](150) NULL,
// 	[DocTotal] [numeric](18, 2) NULL,
// 	[Payment] [numeric](18, 2) NULL,
// 	[Balance] [numeric](18, 2) NULL,
// 	[DocEntry] [nvarchar](50) NULL,
// 	[DocNum] [nvarchar](150) NULL,
// 	[CRTransID] [nvarchar](150) NULL,
// 	[PostingDate] [date] NULL,
// 	[INTransId] [nvarchar](150) NULL,
// 	[RPTransId] [nvarchar](150) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRT1_Temp([ID] [int] ,
// 	[NID] [nvarchar](50) NULL,
// 	[TransId] [nvarchar](150) NULL,
// 	[CardCode] [nvarchar](150) NULL,
// 	[DocTotal] [numeric](18, 2) NULL,
// 	[Payment] [numeric](18, 2) NULL,
// 	[Balance] [numeric](18, 2) NULL,
// 	[DocEntry] [nvarchar](50) NULL,
// 	[DocNum] [nvarchar](150) NULL,
// 	[CRTransID] [nvarchar](150) NULL,
// 	[PostingDate] [date] NULL,
// 	[INTransId] [nvarchar](150) NULL,
// 	[RPTransId] [nvarchar](150) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRDD([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[IssueDate] [date] NULL,[ValidDate] [date] NULL,[Attachment]
//             [nvarchar](150) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Customer([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Address] [varchar](100) NULL,
// 	[Balance] [decimal](18, 2) NULL,
// 	[Remarks] [nchar](500) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Customer_Temp([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Address] [varchar](100) NULL,
// 	[Balance] [decimal](18, 2) NULL,
// 	[Remarks] [nchar](500) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CRDD_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[IssueDate] [date] NULL,[ValidDate] [date] NULL,[Attachment]
//             [nvarchar](150) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE DLN1([ID] [int] ,[UpdateDate] [datetime] NULL,[TransId] [nvarchar](50)
//             NULL,[RowId] [int] NULL,[ItemCode]
//             [nvarchar](100) NULL,[WhsCode] [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId] [nvarchar](50)
//             NULL,[CRTransId] [nvarchar](50) NULL,[DSRowId] [int] NULL,[BaseTransId] [nvarchar](50)
//             NULL,[BaseRowId] [int] NULL,[BaseType] [nvarchar](50) NULL,[MSP] [decimal](10, 2)
//             DEFAULT ((0)) ,[OpenQty] [decimal](10, 2) NULL,[LineStatus] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL, [BaseObjectCode][nvarchar](100)NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DLN1_Temp([ID] [int] ,[UpdateDate] [datetime] NULL,[TransId] [nvarchar](50)
//             NULL,[RowId] [int] NULL,[ItemCode]
//             [nvarchar](100) NULL,[WhsCode] [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId] [nvarchar](50)
//             NULL,[CRTransId] [nvarchar](50) NULL,[DSRowId] [int] NULL,[BaseTransId] [nvarchar](50)
//             NULL,[BaseRowId] [int] NULL,[BaseType] [nvarchar](50) NULL,[MSP] [decimal](10, 2)
//             DEFAULT ((0)) ,[OpenQty] [decimal](10, 2) NULL,[LineStatus] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL, [BaseObjectCode][nvarchar](100)NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DLN2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DLN2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Department([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Remarks] [nchar](500) NULL,
// 	[CreateDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Department_Temp([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Remarks] [nchar](500) NULL,
// 	[CreateDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DLN3([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DLN3_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DOC1([ID] [int] ,[EmpGroupId] [int] ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[Validity] [int] NULL,[Mandatory] [bit] NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DOC1_Temp([ID] [int] ,[EmpGroupId] [int] ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[Validity] [int] NULL,[Mandatory] [bit] NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DSC1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[BaseTransId] [nvarchar](100) NULL,[BaseRowId] [int] NULL,[CardCode]
//             [nvarchar](150) NULL,[CardName] [nvarchar](250) NULL,[ItemCode] [nvarchar](100)
//             NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2) NULL,[UOM]
//             [nvarchar](50) NULL,[DelDueDate] [datetime] NULL,[ShipToAddress] [nvarchar](250)
//             NULL,[CollectCash] [bit] NULL,[LoadQty] [decimal](10, 2) NULL,[OpenQty]
//             [decimal](10, 2) NULL,[InvoiceQty] [decimal](10,2) NULL,[IsSelected] [int] NULL,[UpdateDate] [datetime] NULL,[LineStatus] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DSC1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[BaseTransId] [nvarchar](100) NULL,[BaseRowId] [int] NULL,[CardCode]
//             [nvarchar](150) NULL,[CardName] [nvarchar](250) NULL,[ItemCode] [nvarchar](100)
//             NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2) NULL,[UOM]
//             [nvarchar](50) NULL,[DelDueDate] [datetime] NULL,[ShipToAddress] [nvarchar](250)
//             NULL,[CollectCash] [bit] NULL,[LoadQty] [decimal](10, 2) NULL,[OpenQty]
//             [decimal](10, 2) NULL,[InvoiceQty] [decimal](10,2) NULL,[IsSelected] [int] NULL,[UpdateDate] [datetime] NULL,[LineStatus] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DSC2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[UpdateDate] [datetime] NULL,[UOM]
//             [nvarchar](50) NULL,[DelDueDate]
//             [datetime] NULL,[ShipToAdd] [nvarchar](250) NULL,[CollectCash] [bit] NULL,[LineStatus]
//             [nvarchar](50) NULL ,[InvoiceQty] [decimal](10,2) NULL,[IsSelected] [bit] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DSC2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[UpdateDate] [datetime] NULL,[UOM]
//             [nvarchar](50) NULL,[DelDueDate]
//             [datetime] NULL,[ShipToAdd] [nvarchar](250) NULL,[CollectCash] [bit] NULL,[LineStatus]
//             [nvarchar](50) NULL ,[InvoiceQty] [decimal](10,2) NULL,[IsSelected] [bit] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ECP1([ID] [int] ,
// [TransId] [nvarchar](50) NULL,
// [RowId] [int] NULL,
// [ExpId] [int] NULL,
// [ExpShortDesc] [nvarchar](150) NULL,
// [Based] [nvarchar](150) NULL,
// [Remarks] [nvarchar](150) NULL,
// [Mandatory] [bit] NULL,
// [Amount] [decimal](10, 2) NULL,
// [Factor] [decimal](10, 2) NULL,
// [RAmount] [decimal](10, 2) NULL,
// [RRemarks] [nvarchar](100) NULL,
// [AAmount] [decimal](10, 2) NULL,
// [ARemarks] [nvarchar](100) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ECP1_Temp([ID] [int] ,
// [TransId] [nvarchar](50) NULL,
// [RowId] [int] NULL,
// [ExpId] [int] NULL,
// [ExpShortDesc] [nvarchar](150) NULL,
// [Based] [nvarchar](150) NULL,
// [Remarks] [nvarchar](150) NULL,
// [Mandatory] [bit] NULL,
// [Amount] [decimal](10, 2) NULL,
// [Factor] [decimal](10, 2) NULL,
// [RAmount] [decimal](10, 2) NULL,
// [RRemarks] [nvarchar](100) NULL,
// [AAmount] [decimal](10, 2) NULL,
// [ARemarks] [nvarchar](100) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE EMPD([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[IssueDate] [date] NULL,[ValidDate] [date] NULL,[UpdateDate]
//             [datetime] NULL,[Attachment]
//             [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE EMPD_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[IssueDate] [date] NULL,[ValidDate] [date] NULL,[UpdateDate]
//             [datetime] NULL,[Attachment]
//             [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE INV1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[WhsCode] [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[UpdateDate] [datetime]
//             NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId] [nvarchar](50)
//             NULL,[CRTransId] [nvarchar](50) NULL,[DSRowId] [int] NULL,[BaseTransId] [nvarchar](50)
//             NULL,[BaseRowId] [int] NULL,[CreateDate][datetime]
//             NULL,[BaseType] [nvarchar](50) NULL,[OpenQty] [decimal](10,2) NULL,
// [BaseObjectCode] [nvarchar](100) NULL,[LineStatus] [nvarchar](50)
//             NULL,[MSP] [decimal](10, 2) DEFAULT ((0)) , [has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE INV1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[WhsCode] [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[UpdateDate] [datetime]
//             NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId] [nvarchar](50)
//             NULL,[CRTransId] [nvarchar](50) NULL,[DSRowId] [int] NULL,[BaseTransId] [nvarchar](50)
//             NULL,[BaseRowId] [int] NULL,[CreateDate][datetime]
//             NULL,[BaseType] [nvarchar](50) NULL,[OpenQty] [decimal](10,2) NULL,
// [BaseObjectCode] [nvarchar](100) NULL,[LineStatus] [nvarchar](50)
//             NULL,[MSP] [decimal](10, 2) DEFAULT ((0)) , [has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE INV2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL , [has_created] [int] NULL DEFAULT (0), [BaseObjectCode] [nvarchar](100) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE INV2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL , [has_created] [int] NULL DEFAULT (0), [BaseObjectCode] [nvarchar](100) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE INV3([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[Longitude] [nvarchar](50) NULL ,[BaseObjectCode] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE INV3_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[Longitude] [nvarchar](50) NULL ,[BaseObjectCode] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ITMP([ID] [int],
// 	[PriceListCode] [nvarchar](50) NULL,
// 	[CurrencyCode] [nvarchar](50) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[PriceListName] [nvarchar](100) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ITMP_Temp([ID] [int] ,
// 	[PriceListCode] [nvarchar](50) NULL,
// 	[CurrencyCode] [nvarchar](50) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[PriceListName] [nvarchar](100) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE IUOM([ID] [int] ,
// 	[ItemCode] [nvarchar](50) NULL,
// 	[UOM] [nvarchar](50) NULL,
// 	[Quantity] [decimal](10, 2) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[InStockQty] [decimal](10, 2) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE IUOM_Temp([ID] [int] ,
// 	[ItemCode] [nvarchar](50) NULL,
// 	[UOM] [nvarchar](50) NULL,
// 	[Quantity] [decimal](10, 2) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[InStockQty] [decimal](10, 2) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE IWHS([ID] [int] ,
// 	[ItemCode] [nvarchar](50) NULL,
// 	[WhsCode] [nvarchar](50) NULL,
// 	[Quantity] [decimal](10, 2) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[InStockQty] [decimal](10, 2) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE IWHS_Temp([ID] [int] ,
// 	[ItemCode] [nvarchar](50) NULL,
// 	[WhsCode] [nvarchar](50) NULL,
// 	[Quantity] [decimal](10, 2) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[InStockQty] [decimal](10, 2) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_AppLog([BPLID] [int] NULL,
// 	[AppLogID] [int] ,
// 	[AppStageID] [int] NULL,
// 	[DocID] [int] NULL,
// 	[DocDate] [datetime] NULL,
// 	[Subject] [varchar] NULL,
// 	[OriginatorUID] [int] NULL,
// 	[ApproverUID] [int] NULL,
// 	[ApproverRemark] [varchar](250) NULL,
// 	[ApprovedStatus] [varchar](10) NULL,
// 	[ApprovedDate] [datetime] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [int] NULL,
// 	[DocName] [varchar](15) NULL,
// 	[Rejected] [varchar](10) NULL,
// 	[RejectedRemark] [varchar](250) NULL,
// 	[DocNo] [varchar](250) NULL,
// 	[ApprovalLevel] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_AppLog_Temp([BPLID] [int] NULL,
// 	[AppLogID] [int] ,
// 	[AppStageID] [int] NULL,
// 	[DocID] [int] NULL,
// 	[DocDate] [datetime] NULL,
// 	[Subject] [varchar] NULL,
// 	[OriginatorUID] [int] NULL,
// 	[ApproverUID] [int] NULL,
// 	[ApproverRemark] [varchar](250) NULL,
// 	[ApprovedStatus] [varchar](10) NULL,
// 	[ApprovedDate] [datetime] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [int] NULL,
// 	[DocName] [varchar](15) NULL,
// 	[Rejected] [varchar](10) NULL,
// 	[RejectedRemark] [varchar](250) NULL,
// 	[DocNo] [varchar](250) NULL,
// 	[ApprovalLevel] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OAC1([ID] [int],
// 	[ACID] [int] NULL,
// 	[UserCode] [nvarchar](50) NULL,
// 	[UserName] [nvarchar](150) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OAC1_Temp([ID] [int],
// 	[ACID] [int] NULL,
// 	[UserCode] [nvarchar](50) NULL,
// 	[UserName] [nvarchar](150) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OAC2([ID] [int],
// 	[ACID] [int] NULL,
// 	[Level] [int] NULL,
// 	[UserCode] [nvarchar](50) NULL,
// 	[UserName] [nvarchar](150) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UpdateDate] [datetime] NULL
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OAC2_Temp([ID] [int],
// 	[ACID] [int] NULL,
// 	[Level] [int] NULL,
// 	[UserCode] [nvarchar](50) NULL,
// 	[UserName] [nvarchar](150) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OADM([ID] [int] ,
// 	[TableName] [nvarchar](25) NULL,
// 	[Name] [nvarchar](50) NULL,
// 	[UserName] [nvarchar](150) NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[CreateDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[Active] [int] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OADM_Temp([ID] [int] ,
// 	[Name] [nvarchar](50) NULL,
// 	[TableName] [nvarchar](25) NULL,
// 	[UserName] [nvarchar](150) NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[CreateDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[Active] [int] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OOAC([ACID] [int],
// 	[DocID] [int] NOT NULL,
// 	[DocName] [nvarchar](150) NOT NULL,
// 	[Add] [bit] NULL,
// 	[Cancle] [bit] NULL,
// 	[Edit] [bit] NULL,
// 	[Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BranchId] [int] NULL
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OOAC_Temp([ACID] [int],
// 	[DocID] [int] NOT NULL,
// 	[DocName] [nvarchar](150) NOT NULL,
// 	[Add] [int] NULL,
// 	[Cancle] [int] NULL,
// 	[Edit] [int] NULL,
// 	[Active] [int] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BranchId] [int] NULL
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OOAL(
//             RowId INTEGER PRIMARY KEY AUTOINCREMENT,
//             [ALID] [int],
// 	[ACID] [int] NULL,
// 	[Level] [int] NULL,
// 	[RejectRemarks] [nvarchar](255) NULL,
// 	[AUserCode] [nvarchar](50) NULL,
// 	[AUserName] [nvarchar](150) NULL,
// 	[OUserCode] [nvarchar](50) NULL,
// 	[OUserName] [nvarchar](150) NULL,
// 	[DocNum] [nvarchar](50) NULL,
// 	[DocID] [int] NULL,
// 	[TransId] [nvarchar](50) NULL,
// 	[TransDocID] [int] NULL,
// 	[DocDate] [datetime] NULL,
// 	[DocStatus] [nvarchar](100) NULL,
// 	[Approve] [bit] NULL,
// 	[Reject] [bit] NULL,
// 	[Remark] [nvarchar](250) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreatedDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE LITPL_OOAL_Temp(
//             RowId INTEGER PRIMARY KEY AUTOINCREMENT,
//             [ALID] [int],
// 	[ACID] [int] NULL,
// 	[Level] [int] NULL,
// 	[RejectRemarks] [nvarchar](255) NULL,
// 	[AUserCode] [nvarchar](50) NULL,
// 	[AUserName] [nvarchar](150) NULL,
// 	[OUserCode] [nvarchar](50) NULL,
// 	[OUserName] [nvarchar](150) NULL,
// 	[DocNum] [nvarchar](50) NULL,
// 	[DocID] [int] NULL,
// 	[TransId] [nvarchar](50) NULL,
// 	[TransDocID] [int] NULL,
// 	[DocDate] [datetime] NULL,
// 	[DocStatus] [nvarchar](100) NULL,
// 	[Approve] [bit] NULL,
// 	[Reject] [bit] NULL,
// 	[Remark] [nvarchar](250) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[CreatedDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Location([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Remarks] [nchar](500) NULL,
// 	[CreateDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Location_Temp([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Remarks] [nchar](500) NULL,
// 	[CreateDate] [date] NULL,
// 	[UpdateDate] [date] NULL,
// 	[BizId] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OACT([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[DocStatus] [nvarchar](50) NULL,[Notes] [nvarchar](250) NULL ,[MeetingType] [nvarchar](100) NULL, [Subject] [nvarchar](100) NULL,
//             [MeetingLocation] [nvarchar](100) NULL, [GeoFancingDetails] [nvarchar](100) NULL,
//             [StartDate] [datetime] NULL, [StartTime] [datetime] NULL, [EndDate] [datetime] NULL,
//             [EndTime] [datetime] NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OACT_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[DocStatus] [nvarchar](50) NULL,[Notes] [nvarchar](250) NULL ,[MeetingType] [nvarchar](100) NULL, [Subject] [nvarchar](100) NULL,
//             [MeetingLocation] [nvarchar](100) NULL, [GeoFancingDetails] [nvarchar](100) NULL,
//             [StartDate] [datetime] NULL, [StartTime] [datetime] NULL, [EndDate] [datetime] NULL,
//             [EndTime] [datetime] NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OAMR([ID] [int] ,[RoleId] [int] ,[CreateDate][datetime]
//             NULL,[RoleShortDesc] [nvarchar](150) ,[MenuPath] [nvarchar](150) NULL,[MenuDesc] [nvarchar](150) NULL,[MenuId] [int]
//             NULL,[Active] [bit] NULL DEFAULT ('false') ,[ReadOnly] [bit] NULL DEFAULT ((0)),[Self]
//             [bit] NULL DEFAULT ((0)),[BranchName] [bit] NULL DEFAULT ((0)),[UpdateDate] [datetime] NULL,
//             [ParentMenuId] [int] NULL,
// [IsCreate] [bit] NULL,
// [IsFull] [bit] NULL,
// [IsEdit] [bit] NULL,
// [CreatedBy] [nvarchar] (50) NULL,
// [UpdatedBy] [nvarchar] (50)NULL,
// [BranchId] [nvarchar](50) NULL,
// [Company] [bit] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OAMR_Temp([ID] [int] ,[RoleId] [int] ,[CreateDate][datetime]
//             NULL,[RoleShortDesc] [nvarchar](150) ,[MenuPath] [nvarchar](150) NULL,[MenuDesc] [nvarchar](150) NULL,[MenuId] [int]
//             NULL,[Active] [bit] NULL DEFAULT ('false') ,[ReadOnly] [bit] NULL DEFAULT ((0)),[Self]
//             [bit] NULL DEFAULT ((0)),[BranchName] [bit] NULL DEFAULT ((0)),[UpdateDate] [datetime] NULL,
//             [ParentMenuId] [int] NULL,
// [IsCreate] [bit] NULL,
// [IsFull] [bit] NULL,
// [IsEdit] [bit] NULL,
// [CreatedBy] [nvarchar] (50) NULL,
// [UpdatedBy] [nvarchar] (50)NULL,
// [BranchId] [nvarchar](50) NULL,
// [Company] [bit] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OBDT([ID] [int] ,[BranchId] [int] ,[CreateDate][datetime]
//             NULL,[BranchName] [nvarchar](150),[DeptCode] [nvarchar](10) ,[DeptName] [nvarchar](150) ,[Active] [bit]
//             NULL,[Remarks] [text] NULL ,[UpdateDate] [datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar] (50) NULL,[has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OBDT_Temp([ID] [int] ,[BranchId] [int] ,[CreateDate][datetime]
//             NULL,[BranchName] [nvarchar](150),[DeptCode] [nvarchar](10) ,[DeptName] [nvarchar](150) ,[Active] [bit]
//             NULL,[Remarks] [text] NULL ,[UpdateDate] [datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar] (50) NULL,[has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OBRN([ID] [int] ,[BranchName] [nvarchar](150) NULL,[Address] [text]
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](150) NULL,[StateCode]
//             [nvarchar](50) NULL,[StateName] [nvarchar](50) NULL,[CityName] [nvarchar](150)
//             NULL,[Location] [nvarchar](150) NULL,[Active] [bit] NULL ,[CreatedBy]
//             [nvarchar](150) NULL DEFAULT ((1)), [UpdateDate] [datetime] NULL,[CreateDate]
//             [datetime] NULL, [UpdatedBy] [nvarchar] (50) NULL,[BranchId] [nvarchar] (50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OBRN_Temp([ID] [int] ,[BranchName] [nvarchar](150) NULL,[Address] [text]
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](150) NULL,[StateCode]
//             [nvarchar](50) NULL,[StateName] [nvarchar](50) NULL,[CityName] [nvarchar](150)
//             NULL,[Location] [nvarchar](150) NULL,[Active] [bit] NULL ,[CreatedBy]
//             [nvarchar](150) NULL DEFAULT ((1)), [UpdateDate] [datetime] NULL,[CreateDate]
//             [datetime] NULL, [UpdatedBy] [nvarchar] (50) NULL,[BranchId] [nvarchar] (50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OCCT([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[StateCode]
//             [nvarchar](50) ,[StateName] [nvarchar](150) ,[UpdateDate] [datetime] NULL,[CountryCode]
//             [nvarchar](50) ,[CountryName] [nvarchar](150)
//             ,[CreateDate][datetime]
//             NULL,[CreatedBy] [nvarchar] (50)NULL,
// [UpdatedBy] [nvarchar] (50)NULL,[Active] [bit] NULL,
// [BranchId] [nvarchar] (50)NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCCT_Temp([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[StateCode]
//             [nvarchar](50) ,[StateName] [nvarchar](150) ,[UpdateDate] [datetime] NULL,[CountryCode]
//             [nvarchar](50) ,[CountryName] [nvarchar](150)
//             ,[CreateDate][datetime]
//             NULL,[CreatedBy] [nvarchar] (50)NULL,
// [UpdatedBy] [nvarchar] (50)NULL,[Active] [bit] NULL,
// [BranchId] [nvarchar] (50)NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//   <table>
//         <create_statement>
//
//
//             CREATE TABLE OCIN([ID] [int] ,[CompanyName] [nvarchar](150) NULL,
//             VATNumber nvarchar(255),
// TPINNumber nvarchar(255),
// NRCNumber nvarchar(255),
// LicenseNumber nvarchar(255),
// NAPSANumber nvarchar(255),
// NHIMANumber nvarchar(255),
//             [Address] [text]
//             NULL,[CountryCode] [nvarchar](50) NULL,[StateCode] [nvarchar](50) NULL,[CityCode]
//             [nvarchar](50) NULL,[WebSite] [nvarchar](50) NULL,[Telephone] [nvarchar](50) NULL,[Fax]
//             [nvarchar](50) NULL,[SDRequired] [bit](50) NULL,[PAN] [nvarchar](50) NULL,[TAN]
//             [nvarchar](50) NULL,[CIN] [nvarchar](50) NULL,[SCurr] [nvarchar](50) NULL,[LCurr]
//             [nvarchar](50) NULL,[Email] [nvarchar](60) NULL,[DateFormat] [nvarchar](150) NULL,[CountryName] [nvarchar](150)
//             NULL,[StateName] [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int]
//             NULL DEFAULT (0),[Latitude] [nvarchar](50) NULL,[Longitude]
//             [nvarchar](50) NULL ,
//             MapRange decimal(10,2),
//             [UpdateDate] [datetime] NULL,
//             [CreatedBy][nvarchar](50)NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [MobDocPAth] [nvarchar](150),
// [IsLocalDate] [bit] NULL,
// [IsMtv] [bit] NULL,
// [IsPriceEditable] [bit] NULL,
//             [MobURL] [nvarchar](1250));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCIN_Temp([ID] [int] ,[CompanyName] [nvarchar](150) NULL,
//             VATNumber nvarchar(255),
// TPINNumber nvarchar(255),
// NRCNumber nvarchar(255),
// LicenseNumber nvarchar(255),
// NAPSANumber nvarchar(255),
// NHIMANumber nvarchar(255),
// [Address] [text]
//             NULL,[CountryCode] [nvarchar](50) NULL,[StateCode] [nvarchar](50) NULL,[CityCode]
//             [nvarchar](50) NULL,[WebSite] [nvarchar](50) NULL,[Telephone] [nvarchar](50) NULL,[Fax]
//             [nvarchar](50) NULL,[SDRequired] [bit](50) NULL,[PAN] [nvarchar](50) NULL,[TAN]
//             [nvarchar](50) NULL,[CIN] [nvarchar](50) NULL,[SCurr] [nvarchar](50) NULL,[LCurr]
//             [nvarchar](50) NULL,[Email] [nvarchar](60) NULL,[CountryName] [nvarchar](150)
//             NULL,[StateName] [nvarchar](150) NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [DateFormat] [nvarchar](150) NULL,[has_updated]  [int]
//             NULL DEFAULT (0),[Latitude] [nvarchar](50) NULL,[Longitude]
//             [nvarchar](50) NULL ,
//             MapRange decimal(10,2),
//             [UpdateDate] [datetime] NULL,
//             [CreatedBy][nvarchar](50)NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [MobDocPAth] [nvarchar](150),
// [IsLocalDate] [bit] NULL,
// [IsMtv] [bit] NULL,
// [IsPriceEditable] [bit] NULL,
//             [MobURL] [nvarchar](1250));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OCINP([ID] [int] ,
// 	[CompanyName] [nvarchar](150) NULL,
// 	[Address] [text] NULL,
// 	[CountryCode] [nvarchar](50) NULL,
// 	[StateCode] [nvarchar](50) NULL,
// 	[CityCode] [nvarchar](50) NULL,
// 	[WebSite] [nvarchar](50) NULL,
// 	[Telephone] [nvarchar](50) NULL,
// 	[Fax] [nvarchar](50) NULL,
// 	[SDRequired] [nvarchar](50) NULL,
// 	[PAN] [nvarchar](50) NULL,
// 	[TAN] [nvarchar](50) NULL,
// 	[CIN] [nvarchar](50) NULL,
// 	[SCurr] [nvarchar](50) NULL,
// 	[LCurr] [nvarchar](50) NULL,
// 	[Email] [nvarchar](60) NULL,
// 	[CountryName] [nvarchar](150) NULL,
// 	[StateName] [nvarchar](150) NULL,
// 	[MobURL] [nchar](150) NULL,
// 	[MobDocPAth] [nchar](1250) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OCINP_Temp([ID] [int] ,
// 	[CompanyName] [nvarchar](150) NULL,
// 	[Address] [text] NULL,
// 	[CountryCode] [nvarchar](50) NULL,
// 	[StateCode] [nvarchar](50) NULL,
// 	[CityCode] [nvarchar](50) NULL,
// 	[WebSite] [nvarchar](50) NULL,
// 	[Telephone] [nvarchar](50) NULL,
// 	[Fax] [nvarchar](50) NULL,
// 	[SDRequired] [nvarchar](50) NULL,
// 	[PAN] [nvarchar](50) NULL,
// 	[TAN] [nvarchar](50) NULL,
// 	[CIN] [nvarchar](50) NULL,
// 	[SCurr] [nvarchar](50) NULL,
// 	[LCurr] [nvarchar](50) NULL,
// 	[Email] [nvarchar](60) NULL,
// 	[CountryName] [nvarchar](150) NULL,
// 	[StateName] [nvarchar](150) NULL,
// 	[MobURL] [nchar](150) NULL,
// 	[MobDocPAth] [nchar](1250) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OCRD([ID] [int] ,[Code] [nvarchar](50) ,[FirstName] [nvarchar](50)
//             ,[MiddleName] [nvarchar](50) NULL,[LastName] [nvarchar](50) NULL,CardGroupName nvarchar(255),
// CardSubGroupName nvarchar(255),[Group] [nvarchar](50)
//             NULL,[SubGroup] [nvarchar](50) NULL,[Currency] [nvarchar](50) NULL,[Telephone]
//             [nvarchar](50) NULL,[MobileNo] [nvarchar](50) NULL,[Address] [nvarchar]
//             NULL,[CityCode] [nvarchar](50) NULL,[CityName] [nvarchar](150) NULL,[StateCode]
//             [nvarchar](50) NULL,[StateName] [nvarchar](150) NULL,[CountryCode] [nvarchar](50)
//             NULL,[CountryName] [nvarchar](50) NULL,[Email] [nvarchar](50) NULL,[Website]
//             [nvarchar](50) NULL,[SAPCustomer] [bit] NULL,[PaymentTermCode] [nvarchar](50)
//             NULL,[PaymentTermName] [nvarchar](150) NULL,[PaymentTermDays] [int] NULL,[CreditLimit]
//             [decimal](20, 2) NULL,[Active] [bit] NULL,[Latitude] [nvarchar](50) NULL,[Longitude]
//             [nvarchar](50) NULL ,[ShopSize] [int] NULL, ShopSizeUom nvarchar(50),[CreateDate][datetime]
//             NULL,[Competitor] [bit] NULL,[ISSAP] [bit] NULL,
// [ISPORTAL] [bit] NULL,[BPType] [nvarchar](1)NULL,
// [CreatedBy] [nvarchar](50)NULL,
// [UpdatedBy] [nvarchar](50)NULL,
// [BranchId] [nvarchar](50)NULL,
// [PriceListCode] [nvarchar](50)NULL,
// [SAPCARDCODE] [nvarchar](100)NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCRD_Temp([ID] [int] ,[Code] [nvarchar](50) ,[FirstName] [nvarchar](50)
//             ,[MiddleName] [nvarchar](50) NULL,[LastName] [nvarchar](50) NULL,CardGroupName nvarchar(255),
// CardSubGroupName nvarchar(255),[Group] [nvarchar](50)
//             NULL,[SubGroup] [nvarchar](50) NULL,[Currency] [nvarchar](50) NULL,[Telephone]
//             [nvarchar](50) NULL,[MobileNo] [nvarchar](50) NULL,[Address] [nvarchar]
//             NULL,[CityCode] [nvarchar](50) NULL,[CityName] [nvarchar](150) NULL,[StateCode]
//             [nvarchar](50) NULL,[StateName] [nvarchar](150) NULL,[CountryCode] [nvarchar](50)
//             NULL,[CountryName] [nvarchar](50) NULL,[Email] [nvarchar](50) NULL,[Website]
//             [nvarchar](50) NULL,[SAPCustomer] [bit] NULL,[PaymentTermCode] [nvarchar](50)
//             NULL,[PaymentTermName] [nvarchar](150) NULL,[PaymentTermDays] [int] NULL,[CreditLimit]
//             [decimal](20, 2) NULL,[Active] [bit] NULL,[Latitude] [nvarchar](50) NULL,[Longitude]
//             [nvarchar](50) NULL ,[ShopSize] [int] NULL, ShopSizeUom nvarchar(50),[CreateDate][datetime]
//             NULL,[Competitor] [bit] NULL,[ISSAP] [bit] NULL,
// [ISPORTAL] [bit] NULL,[BPType] [nvarchar](1)NULL,
// [CreatedBy] [nvarchar](50)NULL,
// [UpdatedBy] [nvarchar](50)NULL,
// [BranchId] [nvarchar](50)NULL,
// [PriceListCode] [nvarchar](50)NULL,
// [SAPCARDCODE] [nvarchar](100)NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OCRN([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[Symbol]
//             [nvarchar](50) NULL,[Active] [bit] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL, [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCRN_Temp([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[Symbol]
//             [nvarchar](50) NULL,[Active] [bit] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL, [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE PO([ID] [varchar](50) NULL,
// 	[POSerial] [int] NULL,
// 	[BillAmount] [decimal](18, 2) NULL,
// 	[BillPaid] [decimal](18, 2) NULL,
// 	[Discount] [decimal](18, 2) NULL,
// 	[Balance] [decimal](18, 2) NULL,
// 	[PrevBalance] [decimal](18, 2) NULL,
// 	[Date] [datetime] NULL,
// 	[PurchaseReturn] [bit] NULL,
// 	[SupplierId] [int] NULL,
// 	[PODId] [numeric](18, 0) NULL,
// 	[PurchaseOrderAmount] [decimal](18, 2) NULL,
// 	[PurchaseReturnAmount] [decimal](18, 2) NULL,
// 	[PurchaseOrderQty] [decimal](18, 2) NULL,
// 	[PurchaseReturnQty] [decimal](18, 2) NULL,
// 	[PaymentMethod] [nvarchar](100) NULL,
// 	[PaymentDetail] [nvarchar](500) NULL,
// 	[Remarks] [nvarchar](500) NULL,
// 	[EmployeeId] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE PO_Temp([ID] [varchar](50) NULL,
// 	[POSerial] [int] NULL,
// 	[BillAmount] [decimal](18, 2) NULL,
// 	[BillPaid] [decimal](18, 2) NULL,
// 	[Discount] [decimal](18, 2) NULL,
// 	[Balance] [decimal](18, 2) NULL,
// 	[PrevBalance] [decimal](18, 2) NULL,
// 	[Date] [datetime] NULL,
// 	[PurchaseReturn] [bit] NULL,
// 	[SupplierId] [int] NULL,
// 	[PODId] [numeric](18, 0) NULL,
// 	[PurchaseOrderAmount] [decimal](18, 2) NULL,
// 	[PurchaseReturnAmount] [decimal](18, 2) NULL,
// 	[PurchaseOrderQty] [decimal](18, 2) NULL,
// 	[PurchaseReturnQty] [decimal](18, 2) NULL,
// 	[PaymentMethod] [nvarchar](100) NULL,
// 	[PaymentDetail] [nvarchar](500) NULL,
// 	[Remarks] [nvarchar](500) NULL,
// 	[EmployeeId] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE POD([Auto] [numeric](18, 0) ,
// 	[POId] [varchar](50) NULL,
// 	[PODId] [int] NULL,
// 	[ProductId] [int] NULL,
// 	[OpeningStock] [decimal](18, 2) NULL,
// 	[Quantity] [int] NULL,
// 	[PurchasePrice] [numeric](18, 2) NULL,
// 	[PerPack] [decimal](18, 0) NULL,
// 	[IsPack] [bit] NULL,
// 	[SaleType] [bit] NULL,
// 	[Remarks] [nvarchar](500) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE POD_Temp([Auto] [numeric](18, 0) ,
// 	[POId] [varchar](50) NULL,
// 	[PODId] [int] NULL,
// 	[ProductId] [int] NULL,
// 	[OpeningStock] [decimal](18, 2) NULL,
// 	[Quantity] [int] NULL,
// 	[PurchasePrice] [numeric](18, 2) NULL,
// 	[PerPack] [decimal](18, 0) NULL,
// 	[IsPack] [bit] NULL,
// 	[SaleType] [bit] NULL,
// 	[Remarks] [nvarchar](500) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE Product([ID] [int] NULL,
// 	[Name] [varchar](500) NULL,
// 	[PurchasePrice] [numeric](18, 2) NULL,
// 	[SalePrice] [numeric](18, 2) NULL,
// 	[Stock] [decimal](18, 2) NULL,
// 	[PerPack] [int] NULL,
// 	[totalPiece] [decimal](18, 2) NULL,
// 	[Saleable] [bit] NULL,
// 	[RackPosition] [varchar](100) NULL,
// 	[SupplierId] [int] NULL,
// 	[Attachment] [varchar](500) NULL,
// 	[Remarks] [varchar](1000) NULL,
// 	[BarCode] [varchar](100) NULL,
// 	[ReOrder] [int] NULL,
// 	[LocationId] [int] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE Product_Temp([ID] [int] NULL,
// 	[Name] [varchar](500) NULL,
// 	[PurchasePrice] [numeric](18, 2) NULL,
// 	[SalePrice] [numeric](18, 2) NULL,
// 	[Stock] [decimal](18, 2) NULL,
// 	[PerPack] [int] NULL,
// 	[totalPiece] [decimal](18, 2) NULL,
// 	[Saleable] [bit] NULL,
// 	[RackPosition] [varchar](100) NULL,
// 	[SupplierId] [int] NULL,
// 	[Attachment] [varchar](500) NULL,
// 	[Remarks] [varchar](1000) NULL,
// 	[BarCode] [varchar](100) NULL,
// 	[ReOrder] [int] NULL,
// 	[LocationId] [int] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ProductionOrder([ID] [varchar](50) NULL,
// 	[SOSerial] [int] NULL,
// 	[BillAmount] [decimal](10, 2) NULL,
// 	[BillPaid] [float] NULL,
// 	[Discount] [float] NULL,
// 	[Balance] [float] NULL,
// 	[PrevBalance] [float] NULL,
// 	[Date] [datetime] NULL,
// 	[SaleReturn] [bit] NULL,
// 	[SODId] [numeric](18, 0) NULL,
// 	[SaleOrderAmount] [float] NULL,
// 	[SaleReturnAmount] [float] NULL,
// 	[SaleOrderQty] [int] NULL,
// 	[SaleReturnQty] [int] NULL,
// 	[Profit] [decimal](10, 2) NULL,
// 	[Remarks] [varchar](500) NULL,
// 	[ProductionOrderName] [varchar](500) NULL,
// 	[StartDate] [datetime] NULL,
// 	[EndDate] [datetime] NULL,
// 	[ProductionOrderQty] [int] NULL,
// 	[EmployeeId] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ProductionOrder_Temp([ID] [varchar](50) NULL,
// 	[SOSerial] [int] NULL,
// 	[BillAmount] [decimal](10, 2) NULL,
// 	[BillPaid] [float] NULL,
// 	[Discount] [float] NULL,
// 	[Balance] [float] NULL,
// 	[PrevBalance] [float] NULL,
// 	[Date] [datetime] NULL,
// 	[SaleReturn] [bit] NULL,
// 	[SODId] [numeric](18, 0) NULL,
// 	[SaleOrderAmount] [float] NULL,
// 	[SaleReturnAmount] [float] NULL,
// 	[SaleOrderQty] [int] NULL,
// 	[SaleReturnQty] [int] NULL,
// 	[Profit] [decimal](10, 2) NULL,
// 	[Remarks] [varchar](500) NULL,
// 	[ProductionOrderName] [varchar](500) NULL,
// 	[StartDate] [datetime] NULL,
// 	[EndDate] [datetime] NULL,
// 	[ProductionOrderQty] [int] NULL,
// 	[EmployeeId] [int] NULL);
//         </create_statement>
//     </table><table>
//         <create_statement>
//
//             CREATE TABLE ProductionOrderDetail([Auto] [numeric](18, 0) ,
// 	[SOId] [varchar](50) NULL,
// 	[SODId] [int] NULL,
// 	[ProductId] [int] NULL,
// 	[Quantity] [int] NULL,
// 	[SalePrice] [numeric](18, 2) NULL,
// 	[PurchasePrice] [decimal](10, 2) NULL,
// 	[SaleType] [bit] NULL,
// 	[ShortFall] [int] NULL,
// 	[Remarks] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ProductionOrderDetail_Temp([Auto] [numeric](18, 0) ,
// 	[SOId] [varchar](50) NULL,
// 	[SODId] [int] NULL,
// 	[ProductId] [int] NULL,
// 	[Quantity] [int] NULL,
// 	[SalePrice] [numeric](18, 2) NULL,
// 	[PurchasePrice] [decimal](10, 2) NULL,
// 	[SaleType] [bit] NULL,
// 	[ShortFall] [int] NULL,
// 	[Remarks] [int] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCRO([ID] [int] ,
// 	[TransId] [nvarchar](50) NULL,
// 	[DocDate] [datetime] NULL,
// 	[EmpId] [nvarchar](100) NULL,
// 	[EmpName] [nvarchar](200) NULL,
// 	[EmpGroupId] [nvarchar](100) NULL,
// 	[EmpDesc] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](150) NULL,
// 	[Active] [bit] NULL,
// 	[RequestedAmt] [decimal](10, 2) NULL,
// 	[ApprovedAmt] [decimal](10, 2) NULL,
// 	[ApprovedBy] [nvarchar](50) NULL,
// 	[ApprovedByDesc] [nvarchar](150) NULL,
// 	[ApprovedDate] [datetime] NULL,
// 	[FromDate] [datetime] NULL,
// 	[ToDate] [datetime] NULL,
// 	[Factor] [decimal](10, 2) NULL,
// 	[AdditionalCash] [decimal](10, 2) NULL,
// 	[AdditionalApprovedCash] [decimal](10, 2) NULL,
// 	[ReconDate] [datetime] NULL,
// 	[ReconAmt] [decimal](10, 2) NULL,
// 	[ReconStatus] [nvarchar](50) NULL,
// 	[ReconBy] [nvarchar](50) NULL,
// 	[ApprovalStatus] [nvarchar](50) NULL,
// 	[RPTransId] [nvarchar](50) NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[Currency] [nvarchar](150) NULL,
// 	[Rate] [decimal](10, 2) NULL,
// 	[DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[DraftKey] [nvarchar](100) NULL,
// 	[Error] [nvarchar](100) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCRO_Temp([ID] [int] ,
// 	[TransId] [nvarchar](50) NULL,
// 	[DocDate] [datetime] NULL,
// 	[EmpId] [nvarchar](100) NULL,
// 	[EmpName] [nvarchar](200) NULL,
// 	[EmpGroupId] [nvarchar](100) NULL,
// 	[EmpDesc] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](150) NULL,
// 	[Active] [bit] NULL,
// 	[RequestedAmt] [decimal](10, 2) NULL,
// 	[ApprovedAmt] [decimal](10, 2) NULL,
// 	[ApprovedBy] [nvarchar](50) NULL,
// 	[ApprovedByDesc] [nvarchar](150) NULL,
// 	[ApprovedDate] [datetime] NULL,
// 	[FromDate] [datetime] NULL,
// 	[ToDate] [datetime] NULL,
// 	[Factor] [decimal](10, 2) NULL,
// 	[AdditionalCash] [decimal](10, 2) NULL,
// 	[AdditionalApprovedCash] [decimal](10, 2) NULL,
// 	[ReconDate] [datetime] NULL,
// 	[ReconAmt] [decimal](10, 2) NULL,
// 	[ReconStatus] [nvarchar](50) NULL,
// 	[ReconBy] [nvarchar](50) NULL,
// 	[ApprovalStatus] [nvarchar](50) NULL,
// 	[RPTransId] [nvarchar](50) NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[Currency] [nvarchar](150) NULL,
// 	[Rate] [decimal](10, 2) NULL,
// 	[DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[DraftKey] [nvarchar](100) NULL,
// 	[Error] [nvarchar](100) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OCRT([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[ContactPersonId] [int] NULL,[ContactPersonName]
//             [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate] [datetime]
//             NULL,[Currency] [nvarchar](50) NULL,[CurrRate] [decimal](10, 2) NULL,[DocStatus]
//             [nvarchar](50) NULL,[INTransId] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[Amount] [decimal](10, 2) NULL,[AdAmount] [decimal](10, 2) NULL
//             ,[UpdateDate] [datetime] NULL,[DocType] [nvarchar](100)
//             NULL, [RPTransId]
//             [nvarchar](100) NULL,ApprovalStatus nvarchar(50), [DocEntry] [nvarchar] (100)NULL,
// [DocNum] [nvarchar](100) NULL,
// [Error] [nvarchar] NULL,[OpenAmt] [decimal](10,2) NULL,[CreatedBy] [nvarchar](150) NULL DEFAULT
//             ('admin'),
//             [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar] (50)NULL,
// [Remarks] [nvarchar] (255)NULL,
// [LocalDate][nvarchar](255)NULL,
//             [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCRT_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[ContactPersonId] [int] NULL,[ContactPersonName]
//             [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate] [datetime]
//             NULL,[Currency] [nvarchar](50) NULL,[CurrRate] [decimal](10, 2) NULL,[DocStatus]
//             [nvarchar](50) NULL,[INTransId] [nvarchar](50) NULL,[CreateDate][datetime]
//             NULL,[Amount] [decimal](10, 2) NULL
//             ,[UpdateDate] [datetime] NULL,ApprovalStatus nvarchar(50),[DocType] [nvarchar](100)
//             NULL, [RPTransId]
//             [nvarchar](100) NULL,[AdAmount] [decimal](10, 2) NULL, [DocEntry] [nvarchar] (100)NULL,
// [DocNum] [nvarchar](100) NULL,
// [Error] [nvarchar] NULL,[OpenAmt] [decimal](10,2) NULL,[CreatedBy] [nvarchar](150) NULL DEFAULT
//             ('admin'),
//             [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar] (50)NULL,
// [Remarks] [nvarchar] (255)NULL,
// [LocalDate][nvarchar](255)NULL,
//             [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OCRY([ID] [int] ,[Code] [nvarchar](50) ,[CreateDate][datetime]
//             NULL,[Name] [nvarchar](150) ,[UpdateDate] [datetime] NULL,[Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OCRY_Temp([ID] [int] ,[Code] [nvarchar](50) ,[CreateDate][datetime]
//             NULL,[Name] [nvarchar](150) ,[UpdateDate] [datetime] NULL,[Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OCST([ID] [int],[CountryCode] [nvarchar](50) ,[CountryName] [nvarchar](150) ,[StateCode]
//             [nvarchar](50) ,[UpdateDate] [datetime] NULL,[StateName] [nvarchar](150)
//             ,[CreateDate][datetime]
//             NULL, [Active] [bit] NULL,
//             [CreatedBy] [nvarchar] (50) NULL,
// [UpdatedBy] [nvarchar] (50) NULL,
// [BranchId] [nvarchar](50) NULL,
//             [has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCST_Temp([ID] [int],[CountryCode] [nvarchar](50) ,[CountryName] [nvarchar](150) ,[StateCode]
//             [nvarchar](50) ,[UpdateDate] [datetime] NULL,[StateName] [nvarchar](150)
//             ,[CreateDate][datetime]
//             NULL, [Active] [bit] NULL,
//             [CreatedBy] [nvarchar] (50) NULL,
// [UpdatedBy] [nvarchar] (50) NULL,
// [BranchId] [nvarchar](50) NULL,
//             [has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE ODLN([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId]
//             [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[BaseTab] [nvarchar](150)
//             NULL,[TotBDisc] [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal]
//             [decimal](10, 2) NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2)
//             NULL,[DocEntry] [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[CreateDate] [datetime] NULL,[UpdateDate]
//             [datetime] NULL ,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,[ApprovedBy] [nvarchar](150) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ODLN_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId]
//             [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[BaseTab] [nvarchar](150)
//             NULL,[TotBDisc] [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal]
//             [decimal](10, 2) NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2)
//             NULL,[DocEntry] [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[CreateDate] [datetime] NULL,[UpdateDate]
//             [datetime] NULL ,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,[ApprovedBy] [nvarchar](150) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ODOC([ID] [int] ,
// 	[EmpGroupId] [int] NULL,
// 	[ShortDesc] [nvarchar](150) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ODOC_Temp([ID] [int] ,
// 	[EmpGroupId] [int] NULL,
// 	[ShortDesc] [nvarchar](150) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OMDOC([ID] [int] ,[EMPGId] [int] ,[ShortDesc] [nvarchar](150) ,[Active]
//             [bit]
//             NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OMDOC_Temp([ID] [int] ,[EMPGId] [int] ,[ShortDesc] [nvarchar](150) ,[Active]
//             [bit]
//             NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE ODSC([ID] [int] ,[TransId] [nvarchar](50) ,[BaseTransId] [nvarchar](50)
//             ,[RouteCode] [nvarchar](100) NULL,[RouteName] [nvarchar](150) NULL,[VehCode]
//             [nvarchar](100) NULL,[TruckNo] [nvarchar](100) NULL,[TareWeight] [decimal](10, 2)
//             NULL,[Volume] [decimal](10, 2) NULL,[LoadingCap] [decimal](10, 2) NULL,[DriverName]
//             [nvarchar](150) NULL,[LoadingStatus] [nvarchar](150) NULL,[DocStatus] [nvarchar](50)
//             NULL,[DocEntry] [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[CreateDate] [datetime] NULL,[UpdateDate]
//             [datetime] NULL ,[Latitude] [nvarchar](100) NULL,
// 	[Longitude] [nvarchar](100) NULL,[ApprovalStatus] [nvarchar](100) NULL,SEContact nvarchar(50),
//             [ApprovedBy] [nvarchar](150) NULL, [has_created] [int] NULL DEFAULT (0),
//             [WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[NrcNo] [nvarchar](50) NULL,
// 	[IsPosted] [bit] NULL,
// 	[Error] [nvarchar](50) NULL,
// 	[ObjectCode] [nvarchar](10) NULL,
//             SalesEmpId nvarchar(200),SalesEmp nvarchar(200),DriverMobileNo nvarchar(50),[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ODSC_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[BaseTransId] [nvarchar](50)
//             ,[RouteCode] [nvarchar](100) NULL,[RouteName] [nvarchar](150) NULL,[VehCode]
//             [nvarchar](100) NULL,[TruckNo] [nvarchar](100) NULL,[TareWeight] [decimal](10, 2)
//             NULL,[Volume] [decimal](10, 2) NULL,[LoadingCap] [decimal](10, 2) NULL,[DriverName]
//             [nvarchar](150) NULL,[LoadingStatus] [nvarchar](150) NULL,[DocStatus] [nvarchar](50)
//             NULL,[DocEntry] [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[CreateDate] [datetime] NULL,[UpdateDate]
//             [datetime] NULL ,[Latitude] [nvarchar](100) NULL,
// 	[Longitude] [nvarchar](100) NULL,[ApprovalStatus] [nvarchar](100) NULL,SEContact nvarchar(50),
//             [ApprovedBy] [nvarchar](150) NULL, [has_created] [int] NULL DEFAULT (0),
//             [WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[NrcNo] [nvarchar](50) NULL,
// 	[IsPosted] [bit] NULL,
// 	[Error] [nvarchar](50) NULL,
// 	[ObjectCode] [nvarchar](10) NULL,
//             SalesEmpId nvarchar(200),SalesEmp nvarchar(200),DriverMobileNo nvarchar(50),[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OEMG([ID] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks] [text]
//             NULL,[Active]
//             [bit] NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OEMG_Temp([ID] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks] [text]
//             NULL,[Active]
//             [bit] NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OEMP([ID] [int] ,[Code] [nvarchar](50) ,[FirstName] [nvarchar](50)
//             ,[MiddleName] [nvarchar](50) NULL,[LastName] [nvarchar](50) NULL,[JobTitle]
//             [nvarchar](50) NULL,[Position] [nvarchar](50) NULL,[MobileNo] [nvarchar](50)
//             NULL,[Gender] [nvarchar](50) NULL,[StartDate] [datetime] NULL,[TerminationDate]
//             [datetime] NULL,[DateOfBirth] [datetime] NULL,[BranchId] [int] NULL,[BranchShortDesc]
//             [nvarchar](150) NULL,[DeptId] [int] NULL,[DeptCode] [nvarchar](50) NULL,[DeptShortDesc]
//             [nvarchar](150) NULL,[Address] [nvarchar] NULL,[CityCode] [nvarchar](50) NULL,[CityName]
//             [nvarchar](150) NULL,[StateCode] [nvarchar](50) NULL,[StateName] [nvarchar](150)
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](50) NULL,[Active] [bit]
//             NULL,[Attachment] [nvarchar](255) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL,[EmpGroupId] [nvarchar](100) NULL,
//             [NrcNo] [nvarchar](50) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//             [EMPGD] [nvarchar](150) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OEMP_Temp([ID] [int] ,[Code] [nvarchar](50) ,[FirstName] [nvarchar](50)
//             ,[MiddleName] [nvarchar](50) NULL,[LastName] [nvarchar](50) NULL,[JobTitle]
//             [nvarchar](50) NULL,[Position] [nvarchar](50) NULL,[MobileNo] [nvarchar](50)
//             NULL,[Gender] [nvarchar](50) NULL,[StartDate] [datetime] NULL,[TerminationDate]
//             [datetime] NULL,[DateOfBirth] [datetime] NULL,[BranchId] [int] NULL,[BranchShortDesc]
//             [nvarchar](150) NULL,[DeptId] [int] NULL,[DeptCode] [nvarchar](50) NULL,[DeptShortDesc]
//             [nvarchar](150) NULL,[Address] [nvarchar] NULL,[CityCode] [nvarchar](50) NULL,[CityName]
//             [nvarchar](150) NULL,[StateCode] [nvarchar](50) NULL,[StateName] [nvarchar](150)
//             NULL,[CountryCode] [nvarchar](50) NULL,[CountryName] [nvarchar](50) NULL,[Active] [bit]
//             NULL,[Attachment] [nvarchar](255) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL,[EmpGroupId] [nvarchar](100) NULL,
//             [NrcNo] [nvarchar](50) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//             [EMPGD] [nvarchar](150) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OEMR([ID] [int] ,[EmpGroupId] [int] ,[ShortDesc] [nvarchar](150) ,[JobTitle]
//             [text] NULL,[JobResp] [text] NULL,[UpdateDate] [datetime] NULL,[Requirements] [text]
//             NULL,[CreateDate][datetime]
//             NULL,[Active] [bit] NULL
//             , [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OEMR_Temp([ID] [int] ,[EmpGroupId] [int] ,[ShortDesc] [nvarchar](150) ,[JobTitle]
//             [text] NULL,[JobResp] [text] NULL,[UpdateDate] [datetime] NULL,[Requirements] [text]
//             NULL,[CreateDate][datetime]
//             NULL,[Active] [bit] NULL
//             , [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OEMS([ID] [int] ,[EmpGroupId] [int] ,[CreateDate][datetime]
//             NULL,[ShortDesc] [nvarchar](150) ,[UpdateDate] [datetime] NULL,[SkillDesc]
//             [text] NULL,[Active] [bit] NULL ,[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OEMS_Temp([ID] [int] ,[EmpGroupId] [int] ,[CreateDate][datetime]
//             NULL,[ShortDesc] [nvarchar](150) ,[UpdateDate] [datetime] NULL,[SkillDesc]
//             [text] NULL,[Active] [bit] NULL ,[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OFTY([ID] [int] ,[ShortDesc] [nvarchar](150) ,[CreateDate][datetime]
//             NULL,[Remarks] [text] NULL,[UpdateDate] [datetime] NULL,[Active]
//             [bit] NULL , [has_created] [int] NULL DEFAULT (0),[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OFTY_Temp([ID] [int] ,[ShortDesc] [nvarchar](150) ,[CreateDate][datetime]
//             NULL,[Remarks] [text] NULL,[UpdateDate] [datetime] NULL,[Active]
//             [bit] NULL , [has_created] [int] NULL DEFAULT (0),[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OGRA([ID] [int] ,[ShortDesc] [nvarchar](150) ,[CreateDate][datetime]
//             NULL,[Remarks] [text] NULL,[UpdateDate] [datetime] NULL,[Active]
//             [bit] NULL , [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OGRA_Temp([ID] [int] ,[ShortDesc] [nvarchar](150) ,[CreateDate][datetime]
//             NULL,[Remarks] [text] NULL,[UpdateDate] [datetime] NULL,[Active]
//             [bit] NULL , [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OHPS([ID] [int] ,[ShortDesc] [nvarchar](150) ,[CreateDate][datetime]
//             NULL,[Remarks] [text] NULL,[UpdateDate] [datetime] NULL,[Active]
//             [nvarchar](50) NULL ,[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OHPS_Temp([ID] [int] ,[ShortDesc] [nvarchar](150) ,[CreateDate][datetime]
//             NULL,[Remarks] [text] NULL,[UpdateDate] [datetime] NULL,[Active]
//             [nvarchar](50) NULL ,[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OINV([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId]
//             [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[BaseTab] [nvarchar](150)
//             NULL,[TotBDisc] [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal]
//             [decimal](10, 2) NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2)
//             NULL,[DocEntry] [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[CreateDate] [datetime] NULL,[UpdateDate]
//             [datetime] NULL ,[Latitude] [nvarchar](50) NULL,[Longitude]
//             [nvarchar](50) NULL , [DraftKey] [nvarchar](100) NULL,
// 	[IsPosted] [bit] NULL,
// 	[Error] [nvarchar] NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[OpenAmt] [decimal](10, 2) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,
// 	[IsCashReceipt] [bit] NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ApprovedBy]
//             [nvarchar](150) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OINV_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId]
//             [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[BaseTab] [nvarchar](150)
//             NULL,[TotBDisc] [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal]
//             [decimal](10, 2) NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2)
//             NULL,[DocEntry] [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[CreateDate] [datetime] NULL,[UpdateDate]
//             [datetime] NULL ,[Latitude] [nvarchar](50) NULL,[Longitude]
//             [nvarchar](50) NULL , [DraftKey] [nvarchar](100) NULL,
// 	[IsPosted] [bit] NULL,
// 	[Error] [nvarchar] NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[OpenAmt] [decimal](10, 2) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,
// 	[IsCashReceipt] [bit] NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ApprovedBy]
//             [nvarchar](150) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OITM([ID] [int] ,[ItemCode] [nvarchar](50) ,[ItemName] [nvarchar](150)
//             ,[ItemGroup] [nvarchar](50) ,[SubGroup] [nvarchar](150) ,[UOM] [nvarchar](50) ,[Volume]
//             [decimal](12, 2) ,[Weight] [decimal](12, 2) ,[UpdateDate] [datetime] NULL,[Active] [bit]
//             NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0),[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL, [has_updated]  [int] NULL DEFAULT (0),[Marketing] [bit] NULL
//             DEFAULT ((0)));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OITM_Temp([ID] [int] ,[ItemCode] [nvarchar](50) ,[ItemName] [nvarchar](150)
//             ,[ItemGroup] [nvarchar](50) ,[SubGroup] [nvarchar](150) ,[UOM] [nvarchar](50) ,[Volume]
//             [decimal](12, 2) ,[Weight] [decimal](12, 2) ,[UpdateDate] [datetime] NULL,[Active] [bit]
//             NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0),[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL, [has_updated]  [int] NULL DEFAULT (0),[Marketing] [bit] NULL
//             DEFAULT ((0)));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OLEV([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[Active]
//             [bit] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OLEV_Temp([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[Active]
//             [bit] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OMNU([ID] [int] ,[MenuDesc] [nvarchar](150) NULL,[ParentMenu] [int] NULL ,
//             [Type] [int] NULL,[Notes] [text] NULL,[MenuId] [int] NULL,[Sel] [bit] NULL DEFAULT
//             ('false')
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ReadOnly]
//             [bit] NULL DEFAULT ((0)),[UpdateDate] [datetime] NULL,[Self] [bit] NULL DEFAULT
//             ((0)),[Url] [nvarchar](250) NULL,
// 	[MenuPath] [nvarchar](250) NULL,
// 	[ControllerName] [nchar](20) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[Company] [bit] NULL,[BranchName] [bit] NULL DEFAULT
//             ((0)));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OMNU_Temp([ID] [int] ,[MenuDesc] [nvarchar](150) NULL,[ParentMenu] [int] NULL ,
//             [Type] [int] NULL,[Notes] [text] NULL,[MenuId] [int] NULL,[Sel] [bit] NULL DEFAULT
//             ('false')
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ReadOnly]
//             [bit] NULL DEFAULT ((0)),[UpdateDate] [datetime] NULL,[Self] [bit] NULL DEFAULT
//             ((0)),[Url] [nvarchar](250) NULL,
// 	[MenuPath] [nvarchar](250) NULL,
// 	[ControllerName] [nchar](20) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[Company] [bit] NULL,[BranchName] [bit] NULL DEFAULT
//             ((0)));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OMSP([ItemCode]
//             [nvarchar](50) ,[Price] [decimal](10, 2) NULL,[MSP] [decimal](10, 2) NULL ,[TaxCode] [nvarchar](100) ,[TaxRate] [decimal](10, 2)
//             NULL,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[PriceListCode] [nvarchar](15) NULL,
// 	[ID] [int] ,
// 	[StartDate] [datetime] NULL,
// 	[EndDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OMSP_Temp([ItemCode]
//             [nvarchar](50) ,[Price] [decimal](10, 2) NULL,[MSP] [decimal](10, 2) NULL ,[TaxCode] [nvarchar](100) ,[TaxRate] [decimal](10, 2)
//             NULL,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[PriceListCode] [nvarchar](15) NULL,
// 	[ID] [int] ,
// 	[StartDate] [datetime] NULL,
// 	[EndDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OPTR([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[Days]
//             [numeric](10, 0) NULL,[Active] [bit] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OPTR_Temp([ID] [int] ,[Code] [nvarchar](50) ,[Name] [nvarchar](150) ,[Days]
//             [numeric](10, 0) NULL,[Active] [bit] NULL ,[CreateDate][datetime]
//             NULL,[UpdateDate] [datetime] NULL,[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OQEM([ID] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks] [text]
//             NULL,[Active]
//             [bit] NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OQEM_Temp([ID] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks] [text]
//             NULL,[Active]
//             [bit] NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OQUT([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[BaseTransId] [nvarchar](50) NULL,[TotBDisc]
//             [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal] [decimal](10, 2)
//             NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2) NULL,[DocEntry] [int]
//             NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL,[UpdateDate] [datetime] NULL
//             ,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[ApprovedBy] [nvarchar](100) NULL, [Error] [nvarchar] (150) NULL,[ObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [IsPosted] [bit]
//             NULL,  [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OQUT_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[BaseTransId] [nvarchar](50) NULL,[TotBDisc]
//             [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal] [decimal](10, 2)
//             NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2) NULL,[DocEntry] [int]
//             NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL,[UpdateDate] [datetime] NULL
//             ,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[ApprovedBy] [nvarchar](100) NULL, [Error] [nvarchar] (150) NULL,[ObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [IsPosted] [bit]
//             NULL,  [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ORCT([ID] [int] ,
// 	[RowId] [int] NULL,
// 	[PostingDate] [datetime] NULL,
// 	[ApprovedBy] [nvarchar](150) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[TransId] [nvarchar](50) NULL,
// 	[EmpId] [nvarchar](100) NULL,
// 	[EmpName] [nvarchar](200) NULL,
// 	[EmpGroupId] [nvarchar](100) NULL,
// 	[EmpDesc] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](150) NULL,
// 	[FromDate] [datetime] NULL,
// 	[ToDate] [datetime] NULL,
// 	[ApprovalStatus] [nvarchar](50) NULL,
// 	[Currency] [nvarchar](150) NULL,
// 	[Rate] [decimal](10, 2) NULL,
// 	[DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[DraftKey] [nvarchar](100) NULL,
// 	[RecoverAmt] [decimal](10, 2) NULL,
// 	[PayAmt] [decimal](10, 2) NULL,
// 	[CRTransId] [nvarchar](50) NULL,
// 	[DocStatus] [nvarchar](50) NULL,
// 	TotalRequestedAmt decimal(10,2), TotalApprovedAmt decimal(10,2), TotalExpenseApprovedAmt decimal (10, 2), TotalCashHandoverAmt decimal(10, 2),
// 	[Error] [nvarchar](100) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ORCT_Temp([ID] [int] ,
// 	[RowId] [int] NULL,
// 	[PostingDate] [datetime] NULL,
// 	[ApprovedBy] [nvarchar](150) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[TransId] [nvarchar](50) NULL,
// 	[EmpId] [nvarchar](100) NULL,
// 	[EmpName] [nvarchar](200) NULL,
// 	[EmpGroupId] [nvarchar](100) NULL,
// 	[EmpDesc] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](150) NULL,
// 	[FromDate] [datetime] NULL,
// 	[ToDate] [datetime] NULL,
// 	[ApprovalStatus] [nvarchar](50) NULL,
// 	[Currency] [nvarchar](150) NULL,
// 	[Rate] [decimal](10, 2) NULL,
// 	[DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[DraftKey] [nvarchar](100) NULL,
// 	[RecoverAmt] [decimal](10, 2) NULL,
// 	[PayAmt] [decimal](10, 2) NULL,
// 	[CRTransId] [nvarchar](50) NULL,
// 	[DocStatus] [nvarchar](50) NULL,
// 	TotalRequestedAmt decimal(10,2), TotalApprovedAmt decimal(10,2), TotalExpenseApprovedAmt decimal (10, 2), TotalCashHandoverAmt decimal(10, 2),
// 	[Error] [nvarchar](100) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE ORDR([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[BaseTransId] [nvarchar](50) NULL,[TotBDisc]
//             [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal] [decimal](10, 2)
//             NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2) NULL,[DocEntry] [int]
//             NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL,[UpdateDate] [datetime] NULL
//             ,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[ApprovedBy] [nvarchar](150) NULL, [Error] [nvarchar] NULL,
// 	[IsPosted] [bit] NULL,
// 	[DraftKey] [nvarchar](200) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ORDR_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[PaymentTermDays] [int] NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[BaseTransId] [nvarchar](50) NULL,[TotBDisc]
//             [decimal](10, 2) NULL,[DiscPer] [decimal](10, 2) NULL,[DiscVal] [decimal](10, 2)
//             NULL,[TaxVal] [decimal](10, 2) NULL,[DocTotal] [decimal](10, 2) NULL,[DocEntry] [int]
//             NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL,[UpdateDate] [datetime] NULL
//             ,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[ApprovedBy] [nvarchar](150) NULL, [Error] [nvarchar] NULL,
// 	[IsPosted] [bit] NULL,
// 	[DraftKey] [nvarchar](200) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OROL([ID] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks] [text]
//             NULL,[Active]
//             [nvarchar](50) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OROL_Temp([ID] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks] [text]
//             NULL,[Active]
//             [nvarchar](50) NULL ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE ORTN([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[UpdateDate] [datetime] NULL,[PaymentTermDays] [int]
//             NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId]
//             [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[BaseTab] [nvarchar](150) NULL
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [TotBDisc] [decimal](10, 2) NULL,
// 	[DiscPer] [decimal](10, 2) NULL,
// 	[DiscVal] [decimal](10, 2) NULL,
// 	[TaxVal] [decimal](10, 2) NULL,
// 	[DocTotal] [decimal](10, 2) NULL,
//
// 	[DocEntry] [int] NULL,
// 	[DocNum] [nvarchar](50) NULL,
// 	[ApprovedBy] [nvarchar](200) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0),[CreatedBy]
//             [nvarchar](150) NULL DEFAULT ('admin'));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ORTN_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[CardCode] [nvarchar](100)
//             NULL,[CardName] [nvarchar](150) NULL,[RefNo] [nvarchar](50) NULL,[ContactPersonId] [int]
//             NULL,[ContactPersonName] [nvarchar](150) NULL,[MobileNo] [nvarchar](50) NULL,[PostingDate]
//             [datetime] NULL,[ValidUntill] [datetime] NULL,[Currency] [nvarchar](50) NULL,[CurrRate]
//             [decimal](10, 2) NULL,[PaymentTermCode] [nvarchar](50) NULL,[PaymentTermName]
//             [nvarchar](50) NULL,[UpdateDate] [datetime] NULL,[PaymentTermDays] [int]
//             NULL,[ApprovalStatus] [nvarchar](50)
//             NULL,[DocStatus] [nvarchar](50) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId]
//             [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[BaseTab] [nvarchar](150) NULL
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [TotBDisc] [decimal](10, 2) NULL,
// 	[DiscPer] [decimal](10, 2) NULL,
// 	[DiscVal] [decimal](10, 2) NULL,
// 	[TaxVal] [decimal](10, 2) NULL,
// 	[DocTotal] [decimal](10, 2) NULL,
//
// 	[DocEntry] [int] NULL,
// 	[DocNum] [nvarchar](50) NULL,
// 	[ApprovedBy] [nvarchar](200) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_updated]  [int] NULL DEFAULT (0),[CreatedBy]
//             [nvarchar](150) NULL DEFAULT ('admin'));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ORTP([ID] [int] ,[TransId] [nvarchar](50) ,[RouteCode] [nvarchar](100)
//             NULL,[RouteName] [nvarchar](150) NULL,[VehCode] [nvarchar](100) NULL,[TruckNo]
//             [nvarchar](100) NULL,[TareWeight] [decimal](10, 2) NULL,[Volume] [decimal](10, 2)
//             NULL,[LoadingCap] [decimal](10, 2) NULL,[DriverName] [nvarchar](150)
//             NULL,[LoadingStatus] [nvarchar](150) NULL,[DocStatus] [nvarchar](50) NULL,[DocEntry]
//             [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL,[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ApprovedBy]
//             [nvarchar](150) NULL,[ApprovalStatus] [nvarchar](50) NULL,[SalesEmpId] [nvarchar](50)
//             NULL,[SalesEmp] [nvarchar](150) NULL,[Latitude] [nvarchar](100) NULL,
// 	[Longitude] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[TrnsType] [nvarchar](50) NULL,[Error] [nvarchar](50) NULL,[NrcNo] [nvarchar](50) NULL,[DriverMobileNo] [nvarchar](50) NULL,
//             [WhsCode] [nvarchar](50) NULL,[ISPosted] [int]);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ORTP_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[RouteCode] [nvarchar](100)
//             NULL,[RouteName] [nvarchar](150) NULL,[VehCode] [nvarchar](100) NULL,[TruckNo]
//             [nvarchar](100) NULL,[TareWeight] [decimal](10, 2) NULL,[Volume] [decimal](10, 2)
//             NULL,[LoadingCap] [decimal](10, 2) NULL,[DriverName] [nvarchar](150)
//             NULL,[LoadingStatus] [nvarchar](150) NULL,[DocStatus] [nvarchar](50) NULL,[DocEntry]
//             [int] NULL,[DocNum] [nvarchar](100) NULL,[CreatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL,[UpdateDate] [datetime] NULL , [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ApprovedBy]
//             [nvarchar](150) NULL,[ApprovalStatus] [nvarchar](50) NULL,[SalesEmpId] [nvarchar](50)
//             NULL,[SalesEmp] [nvarchar](150) NULL,[Latitude] [nvarchar](100) NULL,
// 	[Longitude] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[ObjectCode] [nvarchar](100) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[TrnsType] [nvarchar](50) NULL,[Error] [nvarchar](50) NULL,[NrcNo] [nvarchar](50) NULL,[DriverMobileNo] [nvarchar](50) NULL,
//             [WhsCode] [nvarchar](50) NULL,[ISPosted] [int]);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ORTT([RateDate] [datetime] ,[Currency] [nvarchar](50) ,[Rate] [numeric](19,
//             6) NULL,[CreatedBy] [nvarchar](50) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [UpdatedBy] [nvarchar](50) NULL,
// 	[ID] [int] ,
// 	[BranchId] [nvarchar](10) NULL,[has_updated]  [int]
//             NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ORTT_Temp([RateDate] [datetime] ,[Currency] [nvarchar](50) ,[Rate] [numeric](19,
//             6) NULL,[CreatedBy] [nvarchar](50) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [UpdatedBy] [nvarchar](50) NULL,
// 	[ID] [int] ,
// 	[BranchId] [nvarchar](10) NULL,[has_updated]  [int]
//             NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE ORTU([ID] [int] ,[CreatedBy] [nvarchar](50) ,[RoleId] [int] ,[RoleShortDesc] [nvarchar](150) ,[Menu_Id] [int]
//             NULL,[MenuPath] [nvarchar](150) NULL,[MenuDesc] [nvarchar](150) NULL,[MenuId] [int]
//             NULL,[Sel] [bit] NULL DEFAULT ('false') ,[UpdateDate] [datetime] NULL,[ReadOnly] [bit]
//             NULL DEFAULT ((0)), [Self]
//             [bit] NULL DEFAULT ((0)), [Active] [bit] NULL,
// 	[CreateAuth] [bit] NULL,
// 	[EditAuth] [bit] NULL,
// 	[DetailsAuth] [bit] NULL,
// 	[FullAuth] [bit] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UserCode] [nvarchar](50) ,
// 	[BranchId] [nvarchar](50) NULL,
// 	[Company] [bit] NULL,[BranchName] [bit] NULL DEFAULT ((0)),[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ORTU_Temp([ID] [int] ,[CreatedBy] [nvarchar](50) ,[RoleId] [int] ,[RoleShortDesc] [nvarchar](150) ,[Menu_Id] [int]
//             NULL,[MenuPath] [nvarchar](150) NULL,[MenuDesc] [nvarchar](150) NULL,[MenuId] [int]
//             NULL,[Sel] [bit] NULL DEFAULT ('false') ,[UpdateDate] [datetime] NULL,[ReadOnly] [bit]
//             NULL DEFAULT ((0)), [Self]
//             [bit] NULL DEFAULT ((0)), [Active] [bit] NULL,
// 	[CreateAuth] [bit] NULL,
// 	[EditAuth] [bit] NULL,
// 	[DetailsAuth] [bit] NULL,
// 	[FullAuth] [bit] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[UserCode] [nvarchar](50) ,
// 	[BranchId] [nvarchar](50) NULL,
// 	[Company] [bit] NULL,[BranchName] [bit] NULL DEFAULT ((0)),[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OTAX([ID] [int] ,[UpdateDate] [datetime] NULL,[TaxCode] [nvarchar](100)
//             ,[Rate] [decimal](10, 2) NULL
//             ,[CreateDate][datetime]
//             NULL, [Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OTAX_Temp([ID] [int] ,[UpdateDate] [datetime] NULL,[TaxCode] [nvarchar](100)
//             ,[Rate] [decimal](10, 2) NULL
//             ,[CreateDate][datetime]
//             NULL, [Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OUDP([ID] [int] ,
// 	[Code] [nchar](20) NULL,
// 	[Name] [nvarchar](150) NULL,
// 	[Remarks] [nvarchar](100) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OUDP_Temp([ID] [int] ,
// 	[Code] [nchar](20) NULL,
// 	[Name] [nvarchar](150) NULL,
// 	[Remarks] [nvarchar](100) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[Active] [bit] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUSR([ID] [int] ,[UserCode] [nvarchar](15),[Name] [nvarchar](150),[EmpId] [int]
//             NULL,[EmpName] [nvarchar](150) NULL,[Email] [nvarchar](50) NULL,[MobileNo] [nvarchar](15)
//             NULL,[BranchId] [int] NULL,[BranchName] [nvarchar](150) NULL,[DeptId] [int]
//             NULL,[DeptCode] [nvarchar](150) NULL,[DeptName] [nvarchar](150) NULL,[Password]
//             [nvarchar](256) NULL,[Active] [bit] NULL,[UpdateDate] [datetime] NULL,[RoleId] [int]
//             NULL,[RoleShortDesc]
//             [nvarchar](150) NULL,[CardCode] [nvarchar](150) NULL,[CardName] [nvarchar](250)
//             NULL,[Type] [nvarchar](50) NULL , [MUser] [bit] NULL,
//             [IsPrice] [bit] NULL,
//             [MAC] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [bit] NULL,[CreatedBy] [nvarchar](150)
//             NULL,[UpdatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OUSR_Temp([ID] [int] ,[UserCode] [nvarchar](15),[Name] [nvarchar](150),[EmpId] [int]
//             NULL,[EmpName] [nvarchar](150) NULL,[Email] [nvarchar](50) NULL,[MobileNo] [nvarchar](15)
//             NULL,[BranchId] [int] NULL,[BranchName] [nvarchar](150) NULL,[DeptId] [int]
//             NULL,[DeptCode] [nvarchar](150) NULL,[DeptName] [nvarchar](150) NULL,[Password]
//             [nvarchar](256) NULL,[Active] [bit] NULL,[UpdateDate] [datetime] NULL,[RoleId] [int]
//             NULL,[RoleShortDesc]
//             [nvarchar](150) NULL,[CardCode] [nvarchar](150) NULL,[CardName] [nvarchar](250)
//             NULL,[Type] [nvarchar](50) NULL , [MUser] [bit] NULL,
//             [IsPrice] [bit] NULL,
//             [MAC] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [bit] NULL,[CreatedBy] [nvarchar](150)
//             NULL,[UpdatedBy] [nvarchar](50) NULL,[CreateDate] [datetime] NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OVCL([ID] [int] ,[Code] [nvarchar](50) ,[TruckNo] [nvarchar](150)
//             ,[TareWeight] [decimal](10, 2) NULL,[GrossWeight] [decimal](10, 2) NULL,[LoadingCap]
//             [decimal](10, 2) NULL,[Volume] [decimal](10, 2) NULL,[UpdateDate] [datetime]
//             NULL,[EngineNo] [nvarchar](150)
//             NULL,[ChasisNo] [nvarchar](150) NULL,[FuelCapacity] [decimal](10, 2) NULL,[Active] [bit]
//             NULL,[Own] [bit] NULL,[EmpId] [nvarchar](50) NULL,[EmpDesc] [nvarchar](250) NULL
//             ,[CreateDate][datetime]
//             NULL, [TransCode] [nvarchar](100) NULL,
// 	[TrnasName] [nvarchar](300) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[TrnsType] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OVCL_Temp([ID] [int] ,[Code] [nvarchar](50) ,[TruckNo] [nvarchar](150)
//             ,[TareWeight] [decimal](10, 2) NULL,[GrossWeight] [decimal](10, 2) NULL,[LoadingCap]
//             [decimal](10, 2) NULL,[Volume] [decimal](10, 2) NULL,[UpdateDate] [datetime]
//             NULL,[EngineNo] [nvarchar](150)
//             NULL,[ChasisNo] [nvarchar](150) NULL,[FuelCapacity] [decimal](10, 2) NULL,[Active] [bit]
//             NULL,[Own] [bit] NULL,[EmpId] [nvarchar](50) NULL,[EmpDesc] [nvarchar](250) NULL
//             ,[CreateDate][datetime]
//             NULL, [TransCode] [nvarchar](100) NULL,
// 	[TrnasName] [nvarchar](300) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[TrnsType] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OVLD([ID] [int] ,[TransId] [nvarchar](50) ,[BaseTransId] [nvarchar](50)
//             ,[RouteCode] [nvarchar](100) NULL,[RouteName] [nvarchar](150) NULL,[VehCode]
//             [nvarchar](100) NULL,[TruckNo] [nvarchar](100) NULL,[TareWeight] [decimal](10, 2)
//             NULL,[Volume] [decimal](10, 2) NULL,[LoadingCap] [decimal](10, 2) NULL,[DriverName]
//             [nvarchar](150) NULL,[LoadingStatus] [nvarchar](150) NULL,[DocStatus] [nvarchar](50)
//             NULL,[LoadDate] [datetime] NULL,[LoadTime] [time](7) NULL ,[UpdateDate] [datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ApprovalStatus] [nvarchar](150)
//             NULL, [DocEntry] [int] NULL, [ApprovedBy] [nvarchar](150) NULL,[CreateDate][datetime]
//             NULL,[DocNum] [nvarchar](100) NULL,
// 	[Error] [nvarchar] NULL,
// 	[IsPosted] [bit] NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[CreatedBy] [nvarchar](150) NULL DEFAULT
//             ('admin'));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OVLD_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[BaseTransId] [nvarchar](50)
//             ,[RouteCode] [nvarchar](100) NULL,[RouteName] [nvarchar](150) NULL,[VehCode]
//             [nvarchar](100) NULL,[TruckNo] [nvarchar](100) NULL,[TareWeight] [decimal](10, 2)
//             NULL,[Volume] [decimal](10, 2) NULL,[LoadingCap] [decimal](10, 2) NULL,[DriverName]
//             [nvarchar](150) NULL,[LoadingStatus] [nvarchar](150) NULL,[DocStatus] [nvarchar](50)
//             NULL,[LoadDate] [datetime] NULL,[LoadTime] [time](7) NULL ,[UpdateDate] [datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[ApprovalStatus] [nvarchar](150)
//             NULL, [DocEntry] [int] NULL, [ApprovedBy] [nvarchar](150) NULL,[CreateDate][datetime]
//             NULL,[DocNum] [nvarchar](100) NULL,
// 	[Error] [nvarchar] NULL,
// 	[IsPosted] [bit] NULL,
// 	[WhsCode] [nvarchar](100) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[BranchId] [nvarchar](10) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[CreatedBy] [nvarchar](150) NULL DEFAULT
//             ('admin'));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OXPM([ID] [int] ,[EmpGroupId] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks]
//             [text] NULL,[Active] [bit] NULL ,  [UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [CreatedBy] [nvarchar](150) NULL,[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[RouteCode] [nvarchar](50) NULL,
// 	[CurrencyCode] [nvarchar](10) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OXPM_Temp([ID] [int] ,[EmpGroupId] [int] ,[ShortDesc] [nvarchar](150) ,[Remarks]
//             [text] NULL,[Active] [bit] NULL , [UpdateDate] [datetime]
//             NULL, [CreatedBy] [nvarchar](150) NULL,
// 	[CreateDate] [datetime] NULL,[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[RouteCode] [nvarchar](50) NULL,
// 	[CurrencyCode] [nvarchar](10) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OXPT([ID] [int] ,
// 	[ShortDesc] [nvarchar](150) NULL,
// 	[Remarks] [text] NULL,
// 	[Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[AdditionalFactor] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OXPT_Temp([ID] [int] ,
// 	[ShortDesc] [nvarchar](150) NULL,
// 	[Remarks] [text] NULL,
// 	[Active] [bit] NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[AdditionalFactor] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE Payment([ID] [int] NULL,
// 	[SOId] [varchar](50) NULL,
// 	[PaymentMethod] [varchar](50) NULL,
// 	[PaymentAmount] [decimal](10, 2) NULL,
// 	[ReceivedDate] [datetime] NULL,
// 	[Remarks] [varchar](500) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Payment_Temp([ID] [int] NULL,
// 	[SOId] [varchar](50) NULL,
// 	[PaymentMethod] [varchar](50) NULL,
// 	[PaymentAmount] [decimal](10, 2) NULL,
// 	[ReceivedDate] [datetime] NULL,
// 	[Remarks] [varchar](500) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE QUT1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[LineStatus] [nvarchar](50) NULL,[OpenQty] [decimal](10, 2)
//             NULL,[MSP] [decimal](10, 2) DEFAULT ((0)) ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0),[BaseObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE QUT1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[LineStatus] [nvarchar](50) NULL,[OpenQty] [decimal](10, 2)
//             NULL,[MSP] [decimal](10, 2) DEFAULT ((0)) ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0),[BaseObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_updated]
//             [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE QUT2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL ,[BaseObjectCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE QUT2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL ,[BaseObjectCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE QUT3([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE QUT3_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE RCT1([ID] [int] ,
// 	[TransId] [nvarchar](50) NULL,
// 	[EmpGroupId] [int] NULL,
// 	[RowId] [int] NULL,
// 	[ExpId] [int] NULL,
// 	[ExpShortDesc] [nvarchar](150) NULL,
// 	[RequestedAmt] decimal(10,2) NULL,
// 	[ApprovedAmt] decimal(10,2) NULL,
// 	[ExpenseCapturedAmt] decimal(10,2) NULL,
// 	[ExpenseApprovedAmt] decimal(10,2) NULL,
// 	[DiffAmount] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RCT1_Temp([ID] [int] ,
// 	[TransId] [nvarchar](50) NULL,
// 	[EmpGroupId] [int] NULL,
// 	[RowId] [int] NULL,
// 	[ExpId] [int] NULL,
// 	[ExpShortDesc] [nvarchar](150) NULL,
// 	[RequestedAmt] decimal(10,2) NULL,
// 	[ApprovedAmt] decimal(10,2) NULL,
// 	[ExpenseCapturedAmt] decimal(10,2) NULL,
// 	[ExpenseApprovedAmt] decimal(10,2) NULL,
// 	[DiffAmount] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RDR1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[BaseTransId] [nvarchar](50) NULL,[BaseRowId] [nvarchar](50)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[LineStatus] [nvarchar](50) NULL,[MSP]
//             [decimal](10, 2) DEFAULT ((0)) ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL, [BaseObjectCode] [nvarchar](100) NULL,
// 	[RoutePlanningQty] [decimal](10, 2) NULL,
// 	[WhsCode] [nvarchar](200) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RDR1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[BaseTransId] [nvarchar](50) NULL,[BaseRowId] [nvarchar](50)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[LineStatus] [nvarchar](50) NULL,[MSP]
//             [decimal](10, 2) DEFAULT ((0)) ,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL,
// 	[RoutePlanningQty] [decimal](10, 2) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RDR2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL ,[BaseObjectCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RDR2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[RouteCode]
//             [nvarchar](50) NULL,[RouteName] [nvarchar](150) NULL ,[BaseObjectCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RDR3([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RDR3_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE Rights([ID] [numeric](6, 0),
// 	[EmployeeId] [int] NULL,
// 	[Controller] [varchar](50) NULL,
// 	[Action] [varchar](50) NULL,
// 	[Allowed] [bit] NULL,
// 	[MenuView] [bit] NULL,
// 	[Text] [varchar](50) NULL,
// 	[Description] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE Rights_Temp([ID] [numeric](6, 0) ,
// 	[EmployeeId] [int] NULL,
// 	[Controller] [varchar](50) NULL,
// 	[Action] [varchar](50) NULL,
// 	[Allowed] [bit] NULL,
// 	[MenuView] [bit] NULL,
// 	[Text] [varchar](50) NULL,
// 	[Description] [varchar](50) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE ROUT([ID] [int] ,[RouteCode] [nvarchar](50) ,[RouteName] [nvarchar](150)
//             ,[StartingLocation] [nvarchar](150) NULL,[EndLocation] [nvarchar](150) NULL,[Active]
//             [bit] NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[Caption]
//             [nvarchar](50) NULL,[TLatitude] [nvarchar](50) NULL,[UpdateDate] [datetime]
//             NULL,[TLongitude] [nvarchar](50)
//             NULL,[TCaption] [nvarchar](50) NULL,[WhsCode] [nvarchar](100)
//             NULL,[Distance] [decimal](10, 2) NULL
//             ,[CreateDate][datetime]
//             NULL, [CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE ROUT_Temp([ID] [int] ,[RouteCode] [nvarchar](50) ,[RouteName]
//             [nvarchar](150)
//             ,[StartingLocation] [nvarchar](150) NULL,[EndLocation] [nvarchar](150) NULL,[Active]
//             [bit] NULL,[Latitude] [nvarchar](50) NULL,[Longitude] [nvarchar](50) NULL,[Caption]
//             [nvarchar](50) NULL,[TLatitude] [nvarchar](50) NULL,[UpdateDate] [datetime]
//             NULL,[TLongitude] [nvarchar](50)
//             NULL,[TCaption] [nvarchar](50) NULL,[WhsCode] [nvarchar](100)
//             NULL,[Distance] [decimal](10, 2) NULL
//             ,[CreateDate][datetime]
//             NULL,[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RTN1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId] [nvarchar](50)
//             NULL,[CRTransId] [nvarchar](50) NULL,[DSRowId] [int] NULL,[UpdateDate] [datetime]
//             NULL,[BaseTransId] [nvarchar](50)
//             NULL,[BaseRowId] [int] NULL,[MSP] [decimal](10, 2) NULL,[OpenQty] [decimal](10, 2) NULL,
// 	[BaseObjectCode] [nvarchar](100) NULL,[BaseType] [nvarchar](50) NULL,[LineStatus] [nvarchar](50)
//             NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RTN1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[UOM] [nvarchar](50) NULL,[Price] [decimal](10, 2) NULL,[TaxCode] [nvarchar](50)
//             NULL,[TaxRate] [decimal](10, 2) NULL,[Discount] [decimal](10, 2) NULL,[LineTotal]
//             [decimal](10, 2) NULL,[RPTransId] [nvarchar](50) NULL,[DSTranId] [nvarchar](50)
//             NULL,[CRTransId] [nvarchar](50) NULL,[DSRowId] [int] NULL,[UpdateDate] [datetime]
//             NULL,[BaseTransId] [nvarchar](50)
//             NULL,[BaseRowId] [int] NULL,[MSP] [decimal](10, 2) NULL,[OpenQty] [decimal](10, 2) NULL,
// 	[BaseObjectCode] [nvarchar](100) NULL,[BaseType] [nvarchar](50) NULL,[LineStatus] [nvarchar](50)
//             NULL ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RTN2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL , [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RTN2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[BaseObjectCode] [nvarchar](100) NULL,[CountryName] [nvarchar](150)
//             NULL , [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RTN3([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL , [BaseObjectCode] [nvarchar](100) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE RTN3_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int] NULL,[AddressCode]
//             [nvarchar](100) NULL,[Address] [nvarchar](150) NULL,[CityCode] [nvarchar](100)
//             NULL,[CityName] [nvarchar](150) NULL,[StateCode] [nvarchar](100) NULL,[StateName]
//             [nvarchar](150) NULL,[CountryCode] [nvarchar](100) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[CountryName] [nvarchar](150)
//             NULL , [BaseObjectCode] [nvarchar](100) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RTP1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[BaseTransId] [nvarchar](100) NULL,[BaseRowId] [int] NULL,[CardCode]
//             [nvarchar](150) NULL,[CardName] [nvarchar](250) NULL,[ItemCode] [nvarchar](100)
//             NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2) NULL,[OpenQty]
//             [decimal](10, 2) NULL,[UOM] [nvarchar](50) NULL,[UpdateDate] [datetime]
//             NULL,[DelDueDate] [datetime] NULL,[ShipToAddress]
//             [nvarchar](250) NULL,[CollectCash] [bit] NULL,[CreateDate][datetime]
//             NULL,[LoadQty] [decimal](10, 2) NULL ,[BaseObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RTP1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[BaseTransId] [nvarchar](100) NULL,[BaseRowId] [int] NULL,[CardCode]
//             [nvarchar](150) NULL,[CardName] [nvarchar](250) NULL,[ItemCode] [nvarchar](100)
//             NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2) NULL,[OpenQty]
//             [decimal](10, 2) NULL,[UOM] [nvarchar](50) NULL,[UpdateDate] [datetime]
//             NULL,[DelDueDate] [datetime] NULL,[ShipToAddress]
//             [nvarchar](250) NULL,[CollectCash] [bit] NULL,[CreateDate][datetime]
//             NULL,[LoadQty] [decimal](10, 2) NULL ,[BaseObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE RTP2([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[UOM] [nvarchar](50) NULL,[DelDueDate]
//             [datetime] NULL,[ShipToAddress] [nvarchar](250) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[CollectCash] [bit] NULL ,[InvoiceQty] [decimal](10, 2) NULL,
// 	[BaseObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE RTP2_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[UOM] [nvarchar](50) NULL,[DelDueDate]
//             [datetime] NULL,[ShipToAddress] [nvarchar](250) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[CollectCash] [bit] NULL ,[InvoiceQty] [decimal](10, 2) NULL,
// 	[BaseObjectCode] [nvarchar](100) NULL,
// 	[WhsCode] [nvarchar](200) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE SO([ID] [varchar](50) NULL,
// 	[SOSerial] [int] NULL,
// 	[BillAmount] [decimal](18, 2) NULL,
// 	[BillPaid] [decimal](18, 2) NULL,
// 	[Discount] [decimal](18, 2) NULL,
// 	[Balance] [decimal](18, 2) NULL,
// 	[PrevBalance] [decimal](18, 2) NULL,
// 	[Date] [datetime] NULL,
// 	[SaleReturn] [bit] NULL,
// 	[CustomerId] [int] NULL,
// 	[SODId] [numeric](18, 0) NULL,
// 	[SaleOrderAmount] [decimal](18, 2) NULL,
// 	[SaleReturnAmount] [decimal](18, 2) NULL,
// 	[SaleOrderQty] [decimal](18, 2) NULL,
// 	[SaleReturnQty] [decimal](18, 2) NULL,
// 	[Profit] [decimal](18, 2) NULL,
// 	[PaymentMethod] [nvarchar](100) NULL,
// 	[PaymentDetail] [nvarchar](500) NULL,
// 	[Remarks] [nvarchar](500) NULL,
// 	[EmployeeId] [int] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE SO_Temp([ID] [varchar](50) NULL,
// 	[SOSerial] [int] NULL,
// 	[BillAmount] [decimal](18, 2) NULL,
// 	[BillPaid] [decimal](18, 2) NULL,
// 	[Discount] [decimal](18, 2) NULL,
// 	[Balance] [decimal](18, 2) NULL,
// 	[PrevBalance] [decimal](18, 2) NULL,
// 	[Date] [datetime] NULL,
// 	[SaleReturn] [bit] NULL,
// 	[CustomerId] [int] NULL,
// 	[SODId] [numeric](18, 0) NULL,
// 	[SaleOrderAmount] [decimal](18, 2) NULL,
// 	[SaleReturnAmount] [decimal](18, 2) NULL,
// 	[SaleOrderQty] [decimal](18, 2) NULL,
// 	[SaleReturnQty] [decimal](18, 2) NULL,
// 	[Profit] [decimal](18, 2) NULL,
// 	[PaymentMethod] [nvarchar](100) NULL,
// 	[PaymentDetail] [nvarchar](500) NULL,
// 	[Remarks] [nvarchar](500) NULL,
// 	[EmployeeId] [int] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE SOD([Auto] [numeric](18, 0) ,
// 	[SOId] [varchar](50) NULL,
// 	[SODId] [int] NULL,
// 	[ProductId] [int] NULL,
// 	[OpeningStock] [decimal](18, 2) NULL,
// 	[Quantity] [int] NULL,
// 	[SalePrice] [numeric](18, 2) NULL,
// 	[PurchasePrice] [decimal](18, 2) NULL,
// 	[PerPack] [decimal](18, 0) NULL,
// 	[IsPack] [bit] NULL,
// 	[SaleType] [bit] NULL,
// 	[Profit] [decimal](18, 2) NULL,
// 	[Remarks] [nvarchar](500) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE SOD_Temp([Auto] [numeric](18, 0) ,
// 	[SOId] [varchar](50) NULL,
// 	[SODId] [int] NULL,
// 	[ProductId] [int] NULL,
// 	[OpeningStock] [decimal](18, 2) NULL,
// 	[Quantity] [int] NULL,
// 	[SalePrice] [numeric](18, 2) NULL,
// 	[PurchasePrice] [decimal](18, 2) NULL,
// 	[PerPack] [decimal](18, 0) NULL,
// 	[IsPack] [bit] NULL,
// 	[SaleType] [bit] NULL,
// 	[Profit] [decimal](18, 2) NULL,
// 	[Remarks] [nvarchar](500) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Supplier([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Address] [varchar](100) NULL,
// 	[Balance] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BizId] [varchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE Supplier_Temp([ID] [int] NULL,
// 	[Name] [varchar](50) NULL,
// 	[Address] [varchar](100) NULL,
// 	[Balance] [decimal](10, 2) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[BizId] [varchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE TEMP_CRD8([CardCode] [nvarchar](300) NULL,
// 	[BPLId] [int] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE TEMP_CRD8_Temp([CardCode] [nvarchar](300) NULL,
// 	[BPLId] [int] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE TEMP_OCRD_S([Code] [nvarchar](300) NULL,
// 	[FirstName] [nvarchar](300) NULL,
// 	[MiddleName] [nvarchar](300) NULL,
// 	[LastName] [nvarchar](300) NULL,
// 	[CardGroup] [nvarchar](300) NULL,
// 	[SubGroup] [nvarchar](300) NULL,
// 	[Currency] [nvarchar](300) NULL,
// 	[Telephone] [nvarchar](300) NULL,
// 	[MobileNo] [nvarchar](300) NULL,
// 	[Address] [nvarchar](300) NULL,
// 	[CityCode] [nvarchar](300) NULL,
// 	[CityName] [nvarchar](300) NULL,
// 	[StateCode] [nvarchar](300) NULL,
// 	[StateName] [nvarchar](300) NULL,
// 	[CountryCode] [nvarchar](300) NULL,
// 	[CountryName] [nvarchar](300) NULL,
// 	[Email] [nvarchar](300) NULL,
// 	[WebSite] [nvarchar](300) NULL,
// 	[SAPCustomer] [bit] NULL,
// 	[PaymentTermCode] [smallint] NULL,
// 	[PaymentTermName] [nvarchar](300) NULL,
// 	[PaymentTermDays] [smallint] NULL,
// 	[CreditLimit] [decimal](18, 6) NULL,
// 	[Active] [bit] NULL,
// 	[Latitude] [nvarchar](300) NULL,
// 	[Longitude] [nvarchar](300) NULL,
// 	[ShopSize] [int] NULL,
// 	[Competitor] [bit] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE TEMP_OCRD_S_Temp([Code] [nvarchar](300) NULL,
// 	[FirstName] [nvarchar](300) NULL,
// 	[MiddleName] [nvarchar](300) NULL,
// 	[LastName] [nvarchar](300) NULL,
// 	[CardGroup] [nvarchar](300) NULL,
// 	[SubGroup] [nvarchar](300) NULL,
// 	[Currency] [nvarchar](300) NULL,
// 	[Telephone] [nvarchar](300) NULL,
// 	[MobileNo] [nvarchar](300) NULL,
// 	[Address] [nvarchar](300) NULL,
// 	[CityCode] [nvarchar](300) NULL,
// 	[CityName] [nvarchar](300) NULL,
// 	[StateCode] [nvarchar](300) NULL,
// 	[StateName] [nvarchar](300) NULL,
// 	[CountryCode] [nvarchar](300) NULL,
// 	[CountryName] [nvarchar](300) NULL,
// 	[Email] [nvarchar](300) NULL,
// 	[WebSite] [nvarchar](300) NULL,
// 	[SAPCustomer] [bit] NULL,
// 	[PaymentTermCode] [smallint] NULL,
// 	[PaymentTermName] [nvarchar](300) NULL,
// 	[PaymentTermDays] [smallint] NULL,
// 	[CreditLimit] [decimal](18, 6) NULL,
// 	[Active] [bit] NULL,
// 	[Latitude] [nvarchar](300) NULL,
// 	[Longitude] [nvarchar](300) NULL,
// 	[ShopSize] [int] NULL,
// 	[Competitor] [bit] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE TEMP_OUDP([Code] [smallint] NULL,
// 	[Name] [nvarchar](300) NULL,
// 	[Remarks] [nvarchar](300) NULL,
// 	[CreatedBy] [smallint] NULL,
// 	[Father] [nvarchar](300) NULL,
// 	[Active] [bit] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE TEMP_OUDP_Temp([Code] [smallint] NULL,
// 	[Name] [nvarchar](300) NULL,
// 	[Remarks] [nvarchar](300) NULL,
// 	[CreatedBy] [smallint] NULL,
// 	[Father] [nvarchar](300) NULL,
// 	[Active] [bit] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE VCL1([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DriverName]
//             [nvarchar](150) NULL,[Own] [bit] NULL,[EmpId] [nvarchar](50) NULL,[EmpName]
//             [nvarchar](50) NULL ,[NrcNo] [nvarchar](300) NULL,
// 	[DriverMobileNo] [nvarchar](15) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE VCL1_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DriverName]
//             [nvarchar](150) NULL,[Own] [bit] NULL,[EmpId] [nvarchar](50) NULL,[EmpName]
//             [nvarchar](50) NULL ,[NrcNo] [nvarchar](300) NULL,
// 	[DriverMobileNo] [nvarchar](15) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE VCL2([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[RouteCode]
//             [nvarchar](100) NULL,[RouteName] [nvarchar](200) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE VCL2_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[RouteCode]
//             [nvarchar](100) NULL,[RouteName] [nvarchar](200) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE VCLD([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[IssueDate] [date] NULL,[ValidDate] [date] NULL,[Attachment]
//             [nvarchar](150) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE VCLD_Temp([ID] [int] ,[Code] [nvarchar](50) ,[RowId] [int] NULL,[DocName]
//             [nvarchar](150) NULL,[IssueDate] [date] NULL,[ValidDate] [date] NULL,[Attachment]
//             [nvarchar](150) NULL ,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT
//             (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE VLD1([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[UOM] [nvarchar](50) NULL , [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE VLD1_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[RowId] [int]
//             NULL,[ItemCode]
//             [nvarchar](100) NULL,[ItemName] [nvarchar](150) NULL,[Quantity] [decimal](10, 2)
//             NULL,[OpenQty] [decimal](10, 2) NULL,[UpdateDate] [datetime]
//             NULL,[CreateDate][datetime]
//             NULL,[UOM] [nvarchar](50) NULL , [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE XPM1([ID] [int] ,[EmpGroupId] [int] ,[RowId] [int] NULL,[ExpId] [int]
//             NULL,[ExpShortDesc] [nvarchar](150) NULL,[Based] [nvarchar](150) NULL,[ValidFrom]
//             [datetime] NULL,[ValidTo] [datetime] NULL,[UpdateDate] [datetime] NULL,[Remarks]
//             [nvarchar](150) NULL,[Mandatory]
//             [bit] NULL ,[CreateDate][datetime]
//             NULL,[Amount] [decimal](10, 2) NULL DEFAULT
//             ((0)), [has_created] [int] NULL DEFAULT (0),[Additional] [decimal](10, 2) NULL, [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE XPM1_Temp([ID] [int] ,[EmpGroupId] [int] ,[RowId] [int] NULL,[ExpId] [int]
//             NULL,[ExpShortDesc] [nvarchar](150) NULL,[Based] [nvarchar](150) NULL,[ValidFrom]
//             [datetime] NULL,[ValidTo] [datetime] NULL,[UpdateDate] [datetime] NULL,[Remarks]
//             [nvarchar](150) NULL,[Mandatory]
//             [bit] NULL ,[CreateDate][datetime]
//             NULL,[Amount] [decimal](10, 2) NULL DEFAULT
//             ((0)), [has_created] [int] NULL DEFAULT (0),[Additional] [decimal](10, 2) NULL, [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE maps([Latitude] [nvarchar](50) NULL,[UpdateDate] [datetime] NULL,[Longitude]
//             [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE maps_Temp([Latitude] [nvarchar](50) NULL,[UpdateDate] [datetime] NULL,[Longitude]
//             [nvarchar](50) NULL
//             ,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE MyBusinessInfo([ID] [decimal](18, 0) NULL,
// 	[BizName] [nvarchar](500) NULL,
// 	[BizAddress] [nvarchar](500) NULL,
// 	[MobileNo] [nvarchar](500) NULL,
// 	[Email] [nvarchar](500) NULL,
// 	[Website] [nvarchar](500) NULL,
// 	[Tagline] [nvarchar](500) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE MyBusinessInfo_Temp([ID] [decimal](18, 0) NULL,
// 	[BizName] [nvarchar](500) NULL,
// 	[BizAddress] [nvarchar](500) NULL,
// 	[MobileNo] [nvarchar](500) NULL,
// 	[Email] [nvarchar](500) NULL,
// 	[Website] [nvarchar](500) NULL,
// 	[Tagline] [nvarchar](500) NULL);
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OEXR([ID] [int] ,[TransId] [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[DocDate][datetime]
//             NULL, [EmpId] [nvarchar](100) NULL,[EmpName][nvarchar](200)
//             NULL,[EmpGroupId][nvarchar](200) NULL,[EmpDesc][nvarchar](200)
//             NULL,[Remarks][nvarchar](200) NULL,[RequestedAmt][decimal](10,2)
//             NULL,[ApprovedAmt][decimal](10,2) NULL,[ApprovedBy][nvarchar](50)
//             NULL,[ApprovedByDesc] [nvarchar](150) NULL,DocStatus nvarchar(50) NULL,[ApprovedDate] [datetime] NULL,[FromDate] [datetime]
//             NULL,[ToDate] [datetime] NULL,[PostingDate] [datetime] NULL,[Factor] [decimal](10, 2) NULL,[AdditionalCash] [decimal](10, 2)
//             NULL,[AdditionalApprovedCash] [decimal](10, 2) NULL,[ReconDate] [datetime] NULL,[ReconAmt]
//             [decimal](10, 2) NULL,[ReconStatus] [nvarchar](50) NULL DEFAULT ('Pending'),[ReconBy]
//             [nvarchar](50) NULL,[ApprovalStatus] [nvarchar](50) NULL
//             DEFAULT ('Pending'), [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[RPTransId]
//             [nvarchar](50) NULL,[CreatedBy] [nvarchar](150) NULL DEFAULT
//             ('admin'),[CreateDate][datetime]
//             NULL,
//             [UpdateDate] [datetime] NULL,
//             [DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[DraftKey] [nvarchar](100) NULL,
// 	[Error] [nvarchar](100) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
//             [Currency] nvarchar(150),
//             [Rate] decimal(10,2));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OEXR_Temp([ID] [int] ,[TransId] [nvarchar](50) NULL,[CRTransId] [nvarchar](50) NULL,[DocDate][datetime]
//             NULL, [EmpId] [nvarchar](100) NULL,[EmpName][nvarchar](200)
//             NULL,[EmpGroupId][nvarchar](200) NULL,[EmpDesc][nvarchar](200)
//             NULL,[Remarks][nvarchar](200) NULL,[RequestedAmt][decimal](10,2)
//             NULL,[ApprovedAmt][decimal](10,2) NULL,DocStatus nvarchar(50) NULL,[ApprovedBy][nvarchar](50)
//             NULL,[ApprovedByDesc] [nvarchar](150) NULL,[ApprovedDate] [datetime] NULL,[FromDate] [datetime]
//             NULL,[ToDate] [datetime] NULL,[Factor] [decimal](10, 2) NULL,[PostingDate] [datetime] NULL,[AdditionalCash] [decimal](10, 2)
//             NULL,[AdditionalApprovedCash] [decimal](10, 2) NULL,[ReconDate] [datetime] NULL,[ReconAmt]
//             [decimal](10, 2) NULL,[ReconStatus] [nvarchar](50) NULL DEFAULT ('Pending'),[ReconBy]
//             [nvarchar](50) NULL,[ApprovalStatus] [nvarchar](50) NULL
//             DEFAULT ('Pending'), [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0),[RPTransId]
//             [nvarchar](50) NULL,[CreatedBy] [nvarchar](150) NULL DEFAULT
//             ('admin'),[CreateDate][datetime]
//             NULL,
//             [UpdateDate] [datetime] NULL,
//             [DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[DraftKey] [nvarchar](100) NULL,
// 	[Error] [nvarchar](100) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
//             [Currency] nvarchar(150),
//             [Rate] decimal(10,2));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE EXR1([ID] [int] ,[TransId] [nvarchar](50) ,[UpdateDate] [datetime]
//             NULL,[EmpGroupId] [int] ,[RowId] [int]
//             NULL,[ExpId] [int] NULL,[ExpShortDesc] [nvarchar](150) NULL,[Based] [nvarchar](150)
//             NULL,[ValidFrom] [datetime] NULL,[ValidTo] [datetime] NULL,[Remarks] [nvarchar](150)
//             NULL,[Mandatory] [bit] NULL,[Amount] [decimal](10, 2) NULL DEFAULT ((0)),[Factor]
//             [decimal](10, 2) NULL,[RAmount] [decimal](10, 2) NULL,[RRemarks] [nvarchar](100)
//             NULL,[AAmount] [decimal](10, 2) NULL,[ARemarks] [nvarchar](100) NULL,[ReconAmt]
//             [decimal](10, 2) NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE EXR1_Temp([ID] [int] ,[TransId] [nvarchar](50) ,[UpdateDate] [datetime]
//             NULL,[EmpGroupId] [int] ,[RowId] [int]
//             NULL,[ExpId] [int] NULL,[ExpShortDesc] [nvarchar](150) NULL,[Based] [nvarchar](150)
//             NULL,[ValidFrom] [datetime] NULL,[ValidTo] [datetime] NULL,[Remarks] [nvarchar](150)
//             NULL,[Mandatory] [bit] NULL,[Amount] [decimal](10, 2) NULL DEFAULT ((0)),[Factor]
//             [decimal](10, 2) NULL,[RAmount] [decimal](10, 2) NULL,[RRemarks] [nvarchar](100)
//             NULL,[AAmount] [decimal](10, 2) NULL,[ARemarks] [nvarchar](100) NULL,[ReconAmt]
//             [decimal](10, 2) NULL,[CreateDate][datetime]
//             NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//
//             CREATE TABLE OCSH([ID] [int] ,
// 	[TransId] [nvarchar](50) NULL,
// 	[PostingDate] [datetime] NULL,
// 	[ApprovalStatus] [nvarchar](50) NULL,
// 	[CRTransId] [nvarchar](50) NULL,
// 	[DocStatus] [nvarchar](50) NULL,
// 	[Amount] [decimal](10, 2) NULL,
// 	[OpenAmt] [decimal](10, 2) NULL,
// 	[Cash] [decimal](10, 2) NULL,
// 	[Remarks] [nvarchar](250) NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OCSH_Temp([ID] [int] ,
// 	[TransId] [nvarchar](50) NULL,
// 	[PostingDate] [datetime] NULL,
// 	[DocStatus] [nvarchar](50) NULL,
// 	[ApprovalStatus] [nvarchar](50) NULL,
// 	[CRTransId] [nvarchar](50) NULL,
// 	[Amount] [decimal](10, 2) NULL,
// 	[OpenAmt] [decimal](10, 2) NULL,
// 	[Cash] [decimal](10, 2) NULL,
// 	[Remarks] [nvarchar](250) NULL,
// 	[CreatedBy] [nvarchar](150) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[LocalDate] [nvarchar](255) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OECP( [ID] [int] ,
// [ReqDate] [datetime] NULL, [PostingDate] [datetime] NULL,
// [CreateDate][datetime] NULL,
// [AprvDate][datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [RouteCode] [nvarchar](100) NULL,
// DocStatus nvarchar(50) NULL,
// [ApprovedBy] [nvarchar](150) NULL, [CreatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [TransId] [nvarchar](50) NULL,
// [OpenAmt] decimal(10,2),
// [LocalDate] nvarchar(255),
// [EmpId] [nvarchar](100) NULL,
// [EmpName] [nvarchar](200) NULL,
// [EmpGroupId] [nvarchar](100) NULL,
// [EmpDesc] [nvarchar](100) NULL,
// [Remarks] [nvarchar](150) NULL,
// [RequestedAmt] [decimal](10, 2) NULL,
// [ApprovedAmt] [decimal](10, 2) NULL,
// [FromDate] [datetime] NULL,
// [ToDate] [datetime] NULL,
// [Factor] [decimal](10, 2) NULL,
// [AdditionalCash] [decimal](10, 2) NULL,
// [AdditionalApprovedCash] [decimal](10, 2) NULL,
// [ApprovalStatus] [nvarchar](50) NULL,
// [RPTransId] [nvarchar](50) NULL,
// [Currency] [nvarchar](150) NULL,
// [Rate] [decimal](10, 2) NULL,
// [DocEntry] [nvarchar](100) NULL,
// [DocNum] [nvarchar](100) NULL,
// [DraftKey] [nvarchar](100) NULL,
// [Error] [nvarchar](100) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OECP_Temp([ID] [int] ,
// [ReqDate] [datetime] NULL, [PostingDate] [datetime] NULL,
// [CreateDate][datetime]
// NULL,[UpdateDate] [datetime] NULL,
// [RouteCode] [nvarchar](100) NULL,
// DocStatus nvarchar(50) NULL,
// [AprvDate][datetime] NULL,
// [ApprovedBy] [nvarchar](150) NULL, [CreatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [TransId] [nvarchar](50) NULL,
// [OpenAmt] decimal(10,2),
// [LocalDate] nvarchar(255),
// [EmpId] [nvarchar](100) NULL,
// [EmpName] [nvarchar](200) NULL,
// [EmpGroupId] [nvarchar](100) NULL,
// [EmpDesc] [nvarchar](100) NULL,
// [Remarks] [nvarchar](150) NULL,
// [RequestedAmt] [decimal](10, 2) NULL,
// [ApprovedAmt] [decimal](10, 2) NULL,
// [FromDate] [datetime] NULL,
// [ToDate] [datetime] NULL,
// [Factor] [decimal](10, 2) NULL,
// [AdditionalCash] [decimal](10, 2) NULL,
// [AdditionalApprovedCash] [decimal](10, 2) NULL,
// [ApprovalStatus] [nvarchar](50) NULL,
// [RPTransId] [nvarchar](50) NULL,
// [Currency] [nvarchar](150) NULL,
// [Rate] [decimal](10, 2) NULL,
// [DocEntry] [nvarchar](100) NULL,
// [DocNum] [nvarchar](100) NULL,
// [DraftKey] [nvarchar](100) NULL,
// [Error] [nvarchar](100) NULL,[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OAPRV([ID] [int] NULL,[DocName] [nvarchar](50) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL,[Active] [bit] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//
//             CREATE TABLE OAPRV_Temp([ID] [int] NULL,[DocName] [nvarchar](50) NULL,[CreatedBy] [nvarchar](50)
//             NULL,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL,[Active] [bit] NULL, [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ODPT( [ID] [int] , [TransId] [nvarchar](50) NULL, [DocDate]
//             [datetime] NULL, [EmpId] [nvarchar](100) NULL, [EmpName] [nvarchar](200) NULL,
//             [EmpGroupId] [nvarchar](100) NULL, [EmpDesc] [nvarchar](100) NULL, [Remarks]
//             [nvarchar](150) NULL, [Amount] [decimal](10, 2) NULL, [CreatedBy] [nvarchar](100) NULL,
//             [AdAmount] [decimal](10, 2) NULL, [DepositType] [nvarchar](50) NULL, [AcctCode]
//             [nvarchar](100) NULL, [BranchName]
//             [nvarchar](50) NULL, [Attachment] [nvarchar](100) NULL,
//             [Currency] nvarchar(20), [CurrRate] decimal(10,2),
//             [RefId] [nvarchar](150) NULL, [DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[Error] [nvarchar] NULL,[LocalDate] [nvarchar](255) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,[UpdateDate] [datetime] NULL,ApprovalStatus nvarchar(50), DocStatus nvarchar(50), PostingDate datetime NULL,[CreateDate][datetime]
//             NULL,RPTransId nvarchar(50), [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE ODPT_Temp(  [ID] [int] , [TransId] [nvarchar](50) NULL, [DocDate]
//             [datetime] NULL, [EmpId] [nvarchar](100) NULL, [EmpName] [nvarchar](200) NULL,
//             [EmpGroupId] [nvarchar](100) NULL, [EmpDesc] [nvarchar](100) NULL, [Remarks]
//             [nvarchar](150) NULL, [Amount] [decimal](10, 2) NULL, [CreatedBy] [nvarchar](100) NULL,
//             [AdAmount] [decimal](10, 2) NULL, [DepositType] [nvarchar](50) NULL, [AcctCode]
//             [nvarchar](100) NULL, [BranchName]
//             [nvarchar](50) NULL, [Attachment] [nvarchar](100) NULL,
//             [Currency] nvarchar(20), [CurrRate] decimal(10,2),
//             [RefId] [nvarchar](150) NULL, [DocEntry] [nvarchar](100) NULL,
// 	[DocNum] [nvarchar](100) NULL,
// 	[Error] [nvarchar] NULL,[LocalDate] [nvarchar](255) NULL,
// 	ApprovalStatus nvarchar(50), DocStatus nvarchar(50), PostingDate datetime NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,[UpdateDate] [datetime] NULL,[CreateDate][datetime]
//             NULL,RPTransId nvarchar(50), [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL
//             DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DPT1(
//             [ID] [int] ,
//             [TransId] [nvarchar](50) NULL,
//             [RowId] [int] NULL,
//             [CRTransId] [nvarchar](50) NULL,
//             [Currency] [nvarchar](50) NULL,
//             [Amount] [decimal](10, 2) NULL,
//             [DAmount] [decimal](10, 2) NULL,
//             [CreateDate][datetime]
//             NULL,
//             [UpdateDate] [datetime] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DPT1_Temp(
//             [ID] [int] ,
//
//
//             [TransId] [nvarchar](50) NULL,
//             [RowId] [int] NULL,
//             [CRTransId] [nvarchar](50) NULL,
//             [Currency] [nvarchar](50) NULL,
//             [Amount] [decimal](10, 2) NULL,
//             [DAmount] [decimal](10, 2) NULL,
//             [CreateDate][datetime]
//             NULL,
//             [UpdateDate] [datetime] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DGLMAPPING(
//             [ID] [int] ,
//             [AcctCode] [nvarchar](100) ,
//             [AcctName] [nvarchar](100) NULL,
//             [U_Branch] [nvarchar](100) NULL,
//             [U_Type] [nvarchar](100) NULL,
//             [U_SalesAppDeposit] [nvarchar](100) NULL,
//             [UpdateDate] [datetime] NULL,
//             [CreateDate][datetime]
//             NULL,
//             [CreatedBy] [nvarchar] NULL,
// [UpdatedBy] [nchar] (50) NULL,
// [BranchId] [nvarchar] (50)NULL,
// [Active] [bit] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE DGLMAPPING_Temp(
//             [ID] [int] ,
//             [AcctCode] [nvarchar](100) ,
//             [AcctName] [nvarchar](100) NULL,
//             [U_Branch] [nvarchar](100) NULL,
//             [U_Type] [nvarchar](100) NULL,
//             [U_SalesAppDeposit] [nvarchar](100) NULL,
//             [UpdateDate] [datetime] NULL,
//             [CreateDate][datetime]
//             NULL,
//             [CreatedBy] [nvarchar] NULL,
// [UpdatedBy] [nchar] (50) NULL,
// [BranchId] [nvarchar] (50)NULL,
// [Active] [bit] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0));
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OECLO(
//             [ID] [int] IDENTITY(1,1) NULL,
//             [UserCode] [nvarchar](50) NULL,
//             [CreateDate] [datetime] NULL,
//             [Time] [datetime](7) NULL,
//             [Latitude] [numeric](18, 10) NULL,
//             [Longitude] [numeric](18, 10) NULL,
//             [UpdateDate] [datetime] NULL,
//             [UpdateTime] [time](7) NULL,
//             [IsSync] [nchar](10) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OECLO_Temp(
//            [ID] [int] IDENTITY(1,1) NULL,
//             [UserCode] [nvarchar](50) NULL,
//             [CreateDate] [datetime] NULL,
//             [Time] [datetime](7) NULL,
//             [Latitude] [numeric](18, 10) NULL,
//             [Longitude] [numeric](18, 10) NULL,
//             [UpdateDate] [datetime] NULL,
//             [UpdateTime] [time](7) NULL,
//             [IsSync] [nchar](10) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OGRP(
//             [ID] [int] NULL,
//             [GrpDesc] [nvarchar](150) NULL,
//             [SubGroup] [nvarchar](150) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OGRP_Temp(
//            [ID] [int] NULL,
//             [GrpDesc] [nvarchar](150) NULL,
//             [SubGroup] [nvarchar](150) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OTRNS(
//             [ID] [int] NULL,
//             [CardCode] [nvarchar](100) NULL,
//             [CardName] [nvarchar](300) NULL,
//             [GroupCode] [nvarchar](100) NULL,
//             [GroupName] [nvarchar](3000) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OTRNS_Temp(
//             [ID] [int] NULL,
//             [CardCode] [nvarchar](100) NULL,
//             [CardName] [nvarchar](300) NULL,
//             [GroupCode] [nvarchar](100) NULL,
//             [GroupName] [nvarchar](3000) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUDA(
//             [ID] [int] ,
// 	[Description] [varchar](100) NULL,
// 	[ControllerName] [varchar](50) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUDA_Temp(
//             [ID] [int] ,
// 	[Description] [varchar](100) NULL,
// 	[ControllerName] [varchar](50) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUDAR(
//             [ID] [int] ,
// 	[RoleId] [int] NULL,
// 	[OudaId] [int] NULL,
// 	[Sel] [bit] NULL,
// 	[Readonly] [bit] NULL,
// 	[BranchName] [nchar](10) NULL,
// 	[Active] [bit] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[Edit] [bit] NULL,
// 	[Created] [bit] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUDAR_Temp(
//             [ID] [int] ,
// 	[RoleId] [int] NULL,
// 	[OudaId] [int] NULL,
// 	[Sel] [bit] NULL,
// 	[Readonly] [bit] NULL,
// 	[BranchName] [nchar](10) NULL,
// 	[Active] [bit] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[CreateDate] [datetime] NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[Edit] [bit] NULL,
// 	[Created] [bit] NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUOM(
//             [UomEntry] [int] NULL,
//             [UomCode] [nvarchar](20) NULL,
//             [UomName] [nvarchar](100) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [Active] [bit] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OUOM_Temp(
//             [UomEntry] [int] NULL,
//             [UomCode] [nvarchar](20) NULL,
//             [UomName] [nvarchar](100) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [Active] [bit] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OVUL(
//             [ID] [int] NULL,
//             [TransId] [nvarchar](50) NULL,
//             [BaseTransId] [nvarchar](50) NULL,
//             [RouteCode] [nvarchar](100) NULL,
//             [RouteName] [nvarchar](150) NULL,
//             [VehCode] [nvarchar](100) NULL,
//             [TruckNo] [nvarchar](100) NULL,
//             [TotalWeight] [decimal](10, 2) NULL,
//             [Volume] [decimal](10, 2) NULL,
//             [LoadingCap] [decimal](10, 2) NULL,
//             [DriverName] [nvarchar](150) NULL,
//             [LoadingStatus] [nvarchar](150) NULL,
//             [DocStatus] [nvarchar](50) NULL,
//             [LoadDate] [datetime] NULL,
//             [LoadTime] [datetime] NULL,
//             [ApprovalStatus] [nvarchar](150) NULL,
//             [ApprovedBy] [nvarchar](150) NULL,
//             [CreatedBy] [nvarchar](100) NULL,
//             [DocEntry] [int] NULL,
//             [DocNum] [nvarchar](100) NULL,
//             [Error] [nvarchar] NULL,
//             [IsPosted] [bit] NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OVUL_Temp(
//             [ID] [int] NULL,
//             [TransId] [nvarchar](50) NULL,
//             [BaseTransId] [nvarchar](50) NULL,
//             [RouteCode] [nvarchar](100) NULL,
//             [RouteName] [nvarchar](150) NULL,
//             [VehCode] [nvarchar](100) NULL,
//             [TruckNo] [nvarchar](100) NULL,
//             [TotalWeight] [decimal](10, 2) NULL,
//             [Volume] [decimal](10, 2) NULL,
//             [LoadingCap] [decimal](10, 2) NULL,
//             [DriverName] [nvarchar](150) NULL,
//             [LoadingStatus] [nvarchar](150) NULL,
//             [DocStatus] [nvarchar](50) NULL,
//             [LoadDate] [datetime] NULL,
//             [LoadTime] [datetime] NULL,
//             [ApprovalStatus] [nvarchar](150) NULL,
//             [ApprovedBy] [nvarchar](150) NULL,
//             [CreatedBy] [nvarchar](100) NULL,
//             [DocEntry] [int] NULL,
//             [DocNum] [nvarchar](100) NULL,
//             [Error] [nvarchar] NULL,
//             [IsPosted] [bit] NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//             [UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[LocalDate] [nvarchar](255) NULL,
// 	[WhsCode] [nvarchar](100) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OWHS(
//             [WhsCode] [nvarchar](100) NULL,
// 	[WhsName] [nvarchar](200) NULL,
// 	[BranchId] [nvarchar](100) NULL,
// 	[CityName] [nvarchar](100) NULL,
// 	[WhsType] [nvarchar](100) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[Active] [bit] NULL,
// 	[ID] [int] ,
// 	[CityCode] [nvarchar](100) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE OWHS_Temp(
//             [WhsCode] [nvarchar](100) NULL,
// 	[WhsName] [nvarchar](200) NULL,
// 	[BranchId] [nvarchar](100) NULL,
// 	[CityName] [nvarchar](100) NULL,
// 	[WhsType] [nvarchar](100) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[Active] [bit] NULL,
// 	[ID] [int] ,
// 	[CityCode] [nvarchar](100) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE VUL1(
//             [ID] [int],
//             [TransId] [nvarchar](50) NULL,
//             [RowId] [int] NULL,
//             [ItemCode] [nvarchar](100) NULL,
//             [ItemName] [nvarchar](150) NULL,
//             [Quantity] [decimal](10, 2) NULL,
//             [OpenQty] [decimal](10, 2) NULL,
//             [UOM] [nvarchar](50) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE VUL1_Temp(
//             [ID] [int],
//             [TransId] [nvarchar](50) NULL,
//             [RowId] [int] NULL,
//             [ItemCode] [nvarchar](100) NULL,
//             [ItemName] [nvarchar](150) NULL,
//             [Quantity] [decimal](10, 2) NULL,
//             [OpenQty] [decimal](10, 2) NULL,
//             [UOM] [nvarchar](50) NULL,
//             [CreateDate] [datetime] NULL,
//             [UpdateDate] [datetime] NULL,
//              [has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
//             );
//         </create_statement>
//     </table>
// <table>
//         <create_statement>
//             CREATE TABLE CVOCVP(
// 	[ID] [int] NULL,
// 	[TransId] [nvarchar](50) NULL,
// 	[RouteCode] [nvarchar](50) NULL,
// 	[EmpCode1] [nvarchar](50) NULL,
// 	[EmpCode2] [nvarchar](50) NULL,
// 	[EmpCode3] [nvarchar](50) NULL,
// 	[StartDate] [datetime] NULL,
// 	[EndDate] [datetime] NULL,
// 	[DocStatus] [nvarchar](100) NULL,
// 	[ApprovalStatus] [nvarchar](150) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CVOCVP_Temp(
// 	[ID] [int] NULL,
// 	[TransId] [nvarchar](50) NULL,
// 	[RouteCode] [nvarchar](50) NULL,
// 	[EmpCode1] [nvarchar](50) NULL,
// 	[EmpCode2] [nvarchar](50) NULL,
// 	[EmpCode3] [nvarchar](50) NULL,
// 	[StartDate] [datetime] NULL,
// 	[EndDate] [datetime] NULL,
// 	[DocStatus] [nvarchar](100) NULL,
// 	[ApprovalStatus] [nvarchar](150) NULL,
// 	[Remarks] [nvarchar](255) NULL,
// 	[CreatedBy] [nvarchar](50) NULL,
// 	[UpdatedBy] [nvarchar](50) NULL,
// 	[BranchId] [nvarchar](50) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CVCVP1(
// 	[ID] [int]  NULL,
//   TransId nvarchar(100),
// [RowId] [int] NULL,
// 	[ATTransId] [nvarchar](150) NULL,
// 	[EmpCode] [nvarchar](50) NULL,
// 	[CardCode] [nvarchar](100) NULL,
// 	[CardName] [nvarchar](150) NULL,
// 	[ContactPersonId] [int] NULL,
// 	[ContactPersonName] [nvarchar](150) NULL,
// 	[MobileNo] [nvarchar](50) NULL,
// 	[Latitude] [nvarchar](100) NULL,
// 	[Longitude] [nvarchar](100) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
// );
//         </create_statement>
//     </table>
//     <table>
//         <create_statement>
//             CREATE TABLE CVCVP1_Temp(
// 	[ID] [int]  NULL,
//   TransId nvarchar(100),
// [RowId] [int] NULL,
// 	[ATTransId] [nvarchar](150) NULL,
// 	[EmpCode] [nvarchar](50) NULL,
// 	[CardCode] [nvarchar](100) NULL,
// 	[CardName] [nvarchar](150) NULL,
// 	[ContactPersonId] [int] NULL,
// 	[ContactPersonName] [nvarchar](150) NULL,
// 	[MobileNo] [nvarchar](50) NULL,
// 	[Latitude] [nvarchar](100) NULL,
// 	[Longitude] [nvarchar](100) NULL,
// 	[CreateDate] [datetime] NULL,
// 	[UpdateDate] [datetime] NULL,
// 	[has_created] [int] NULL DEFAULT (0), [has_updated]  [int] NULL DEFAULT (0)
// );
//         </create_statement>
//     </table>
// <table>
// <create_statement>
// CREATE TABLE OSTK(
// [ID] [int],
// [TransId] [nvarchar](50) NULL,
// [EmpCode1] [nvarchar](50) NULL,
// [EmpCode2] [nvarchar](50) NULL,
// [EmpName1] [nvarchar](150) NULL,
// [EmpName2] [nvarchar](150) NULL,
// [CardCode] [nvarchar](100) NULL,
// [CardName] [nvarchar](150) NULL,
// [ContactPersonId] [int] NULL,
// [ContactPersonName] [nvarchar](150) NULL,
// [MobileNo] [nvarchar](50) NULL,
// [PostingDate] [datetime] NULL,
// [ApprovalStatus] [nvarchar](50) NULL,
// [DocStatus] [nvarchar](50) NULL,
// [Remarks] [nvarchar](255) NULL,
// [LocalDate] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](10) NULL,
// [StockTakeDate] [datetime] NULL,
// [StockTakeTime] [datetime] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0)
// );
// </create_statement>
// </table>
// <table>
// <create_statement>
// CREATE TABLE OSTK_Temp(
// [ID] [int],
// [TransId] [nvarchar](50) NULL,
// [EmpCode1] [nvarchar](50) NULL,
// [EmpCode2] [nvarchar](50) NULL,
// [EmpName1] [nvarchar](150) NULL,
// [EmpName2] [nvarchar](150) NULL,
// [CardCode] [nvarchar](100) NULL,
// [CardName] [nvarchar](150) NULL,
// [ContactPersonId] [int] NULL,
// [ContactPersonName] [nvarchar](150) NULL,
// [MobileNo] [nvarchar](50) NULL,
// [PostingDate] [datetime] NULL,
// [ApprovalStatus] [nvarchar](50) NULL,
// [DocStatus] [nvarchar](50) NULL,
// [Remarks] [nvarchar](255) NULL,
// [LocalDate] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](10) NULL,
// [StockTakeDate] [datetime] NULL,
// [StockTakeTime] [datetime] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0)
// );
// </create_statement>
// </table>
// <table>
//     <create_statement>
// CREATE TABLE STK1(
// [ID] [int],
// [TransId] [nvarchar](50) NULL,
// [RowId] [int]  NULL,
// [ItemCode] [nvarchar](100) NULL,
// [ItemName] [nvarchar](150) NULL,
// [Quantity] [decimal](10, 2) NULL,
// [OpenQty] [decimal](10, 2) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0)
// );
//     </create_statement>
// </table>
// <table>
//     <create_statement>
// CREATE TABLE STK1_Temp(
// [ID] [int],
// [TransId] [nvarchar](50) NULL,
// [RowId] [int]  NULL,
// [ItemCode] [nvarchar](100) NULL,
// [ItemName] [nvarchar](150) NULL,
// [Quantity] [decimal](10, 2) NULL,
// [OpenQty] [decimal](10, 2) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0)
// );
//     </create_statement>
// </table>
//
//
//
//
// <table>
// <create_statement>
// CREATE TABLE SUAOPC(
// [ID] [int]  NULL,
// [Code] [nvarchar](100) NULL,
// [CardCode] [nvarchar](50) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [Active] [bit] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUAOPC_Temp(
// [ID] [int]  NULL,
// [Code] [nvarchar](100) NULL,
// [CardCode] [nvarchar](50) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [Active] [bit] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
//
// <table>
// <create_statement>
// CREATE TABLE SUAPC1(
// [ID] [int] NULL,
// [Code] [nvarchar](100) NULL,
// [ProjectCode] [nvarchar](50) NULL,
// [ModuleName] [nvarchar](150) NULL,
// [Category] [nvarchar](50) NULL,
// [FormName] [nvarchar](150) NULL,
// [ValidFrom] [datetime] NULL,
// [ValidTo] [datetime] NULL,
// [EmpCode] [nvarchar](50) NULL,
// [NumberOfMobileUser] [int] NULL,
// [NumberOfWebUser] [int] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUAPC1_Temp(
// [ID] [int] NULL,
// [Code] [nvarchar](100) NULL,
// [ProjectCode] [nvarchar](50) NULL,
// [ModuleName] [nvarchar](150) NULL,
// [Category] [nvarchar](50) NULL,
// [FormName] [nvarchar](150) NULL,
// [ValidFrom] [datetime] NULL,
// [ValidTo] [datetime] NULL,
// [EmpCode] [nvarchar](50) NULL,
// [NumberOfMobileUser] [int] NULL,
// [NumberOfWebUser] [int] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUISU1(
// [ID] [int]  NULL,
// [BaseMessageId] [int] NULL,
// [TicketCode] [nvarchar](50) NULL,
// [Message] [nvarchar](50) NULL,
// [Attachment] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [IsDeleted] [bit] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUISU1_Temp(
// [ID] [int]  NULL,
// [BaseMessageId] [int] NULL,
// [TicketCode] [nvarchar](50) NULL,
// [Message] [nvarchar](50) NULL,
// [Attachment] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [IsDeleted] [bit] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOATE(
// [ID] [int]  NULL,
// [TicketCode] [nvarchar](50) NULL,
// [EmpCode] [nvarchar](50) NULL,
// [AssignedBy] [nvarchar](50) NULL,
// [RaisedBy] [nvarchar](50) NULL,
// [Status] [varchar](150) NULL,
// [Remarks] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [IsTicketTaken] [bit] NULL,
// [IsDeleted] [bit] NULL,
// [TakenDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOATE_Temp(
// [ID] [int]  NULL,
// [TicketCode] [nvarchar](50) NULL,
// [EmpCode] [nvarchar](50) NULL,
// [AssignedBy] [nvarchar](50) NULL,
// [RaisedBy] [nvarchar](50) NULL,
// [Status] [varchar](150) NULL,
// [Remarks] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [IsTicketTaken] [bit] NULL,
// [IsDeleted] [bit] NULL,
// [TakenDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
//
//
// <table>
// <create_statement>
// CREATE TABLE SUOISU(
// [ID] [int] NULL,
// [TicketCode] [nvarchar](50) NULL,
// [ProductCode] [nvarchar](50) NULL,
// [ProjectName] [nvarchar](150) NULL,
// [CategoryCode] [nvarchar](50) NULL,
// [RaisedBy] [nvarchar](50) NULL,
// [CurrentlyHandledBy] [nvarchar](50) NULL,
// [Status] [varchar](50) NULL,
// [Manager] [varchar](150) NULL,
// [OpenDate] [datetime] NULL,
// [CloseDate] [datetime] NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [Attachment] [nvarchar](255) NULL,
// [CurrentlyHandleBy] [nvarchar](50) NULL,
// [Priority] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOISU_Temp(
// [ID] [int] NULL,
// [TicketCode] [nvarchar](50) NULL,
// [ProductCode] [nvarchar](50) NULL,
// [ProjectName] [nvarchar](150) NULL,
// [CategoryCode] [nvarchar](50) NULL,
// [RaisedBy] [nvarchar](50) NULL,
// [CurrentlyHandledBy] [nvarchar](50) NULL,
// [Status] [varchar](50) NULL,
// [Manager] [varchar](150) NULL,
// [OpenDate] [datetime] NULL,
// [CloseDate] [datetime] NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [Attachment] [nvarchar](255) NULL,
// [CurrentlyHandleBy] [nvarchar](50) NULL,
// [Priority] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOORG(
// [ID] [int] NULL,
// [EmpCode] [nvarchar](100) NULL,
// [ChildOf] [int] NULL,
// [OrgRowOrder] [int] NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [Active] [bit] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOORG_Temp(
// [ID] [int] NULL,
// [EmpCode] [nvarchar](100) NULL,
// [ChildOf] [int] NULL,
// [OrgRowOrder] [int] NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [Active] [bit] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPDT(
// [ID] [int]  NULL,
// [TaskCode] [nvarchar](50) NULL,
// [TaskName] [nvarchar](200) NULL,
// [EmpCode] [nvarchar](50) NULL,
// [StartDate] [datetime] NULL,
// [EndDate] [datetime] NULL,
// [Remarks] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPDT_Temp(
// [ID] [int]  NULL,
// [TaskCode] [nvarchar](50) NULL,
// [TaskName] [nvarchar](200) NULL,
// [EmpCode] [nvarchar](50) NULL,
// [StartDate] [datetime] NULL,
// [EndDate] [datetime] NULL,
// [Remarks] [nvarchar](255) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
//
//
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRC(
// [ID] [int]  NULL,
// [CategoryCode] [nvarchar](150) NULL,
// [CategoryName] [nvarchar](150) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// table>
// <create_statement>
// CREATE TABLE SUOPRC_Temp(
// [ID] [int]  NULL,
// [CategoryCode] [nvarchar](150) NULL,
// [CategoryName] [nvarchar](150) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRM(
// [ID] [int]  NULL,
// [ProjectCode] [nvarchar](150) NULL,
// [ProjectName] [nvarchar](255) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CardCode] [nchar](50) NULL,
// [CardName] [nchar](150) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRM_Temp(
// [ID] [int]  NULL,
// [ProjectCode] [nvarchar](150) NULL,
// [ProjectName] [nvarchar](255) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CardCode] [nchar](50) NULL,
// [CardName] [nchar](150) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRP(
// [ID] [int] NULL,
// [ProjectCode] [nvarchar](150) NULL,
// [Code] [nvarchar](150) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRP_Temp(
// [ID] [int] NULL,
// [ProjectCode] [nvarchar](150) NULL,
// [Code] [nvarchar](150) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRU(
// [ID] [int] NULL,
// [ProjectCode] [nvarchar](150) NOT NULL,
// [Code] [nvarchar](150) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOPRU_Temp(
// [ID] [int] NULL,
// [ProjectCode] [nvarchar](150) NOT NULL,
// [Code] [nvarchar](150) NULL,
// [Active] [bit] NULL,
// [CreatedBy] [nvarchar](150) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOTSKL(
// [ID] [int]  NULL,
// [TicketCode] [nvarchar](100) NULL,
// [Subject] [nvarchar](150) NULL,
// [StartDate] [datetime] NULL,
// [EndDate] [datetime] NULL,
// [StartTime] [datetime] NULL,
// [EndTime] [datetime] NULL,
// [Attachment] [nvarchar](500) NULL,
// [Status] [nvarchar](50) NULL,
// [Details] [nvarchar](50) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUOTSKL_Temp(
// [ID] [int]  NULL,
// [TicketCode] [nvarchar](100) NULL,
// [Subject] [nvarchar](150) NULL,
// [StartDate] [datetime] NULL,
// [EndDate] [datetime] NULL,
// [StartTime] [datetime] NULL,
// [EndTime] [datetime] NULL,
// [Attachment] [nvarchar](500) NULL,
// [Status] [nvarchar](50) NULL,
// [Details] [nvarchar](50) NULL,
// [CreatedBy] [nvarchar](50) NULL,
// [UpdatedBy] [nvarchar](50) NULL,
// [BranchId] [nvarchar](50) NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUPRM1(
// [ID] [int] NULL,
// [ProjectCode] [nvarchar](50) NULL,
// [ModuleName] [varchar](150) NULL,
// [SubModuleName] [nvarchar](150) NULL,
// [FormName] [nvarchar](150) NULL,
// [PlanStartDate] [datetime] NULL,
// [PlanEndDate] [datetime] NULL,
// [EmpCode] [nvarchar](50) NULL,
// [Status] [nvarchar](50) NULL,
// [ActualStartDate] [datetime] NULL,
// [ActualEndDate] [datetime] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUPRM1_Temp(
// [ID] [int] NULL,
// [ProjectCode] [nvarchar](50) NULL,
// [ModuleName] [varchar](150) NULL,
// [SubModuleName] [nvarchar](150) NULL,
// [FormName] [nvarchar](150) NULL,
// [PlanStartDate] [datetime] NULL,
// [PlanEndDate] [datetime] NULL,
// [EmpCode] [nvarchar](50) NULL,
// [Status] [nvarchar](50) NULL,
// [ActualStartDate] [datetime] NULL,
// [ActualEndDate] [datetime] NULL,
// [CreateDate] [datetime] NULL,
// [UpdateDate] [datetime] NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
//
// <table>
// <create_statement>
// CREATE TABLE SUPRP1(
// [ID] [int] NULL,
// [Code] [nvarchar](50) NOT NULL,
// [CategoryCode] [nvarchar](50) NOT NULL,
// [CategoryName] [nvarchar](150) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUPRP1_Temp(
// [ID] [int] NULL,
// [Code] [nvarchar](50) NOT NULL,
// [CategoryCode] [nvarchar](50) NOT NULL,
// [CategoryName] [nvarchar](150) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
//
// <table>
// <create_statement>
// CREATE TABLE SUPRU1(
// [ID] [int] NULL,
// [Code] [nvarchar](50) NOT NULL,
// [UserCode] [nvarchar](50) NOT NULL,
// [UserName] [nvarchar](150) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
//
// <table>
// <create_statement>
// CREATE TABLE SUPRU1_Temp(
// [ID] [int] NULL,
// [Code] [nvarchar](50) NOT NULL,
// [UserCode] [nvarchar](50) NOT NULL,
// [UserName] [nvarchar](150) NULL,
// [has_created] [int] NULL DEFAULT (0),
// [has_updated]  [int] NULL DEFAULT(0));
// </create_statement>
// </table>
// </data>
//   """;

  String xmlString = localStorage?.getString('TableCreationScript') ?? '';
  // Map m = jsonDecode(str ?? '');
  // // print(m);
  // String xmlString = m['TableCreationScript'];
  bool databaseExists =
      await databaseFactory.databaseExists(path + "/LITSale.db");
  if (databaseExists) {
    var d = await openDatabase(path + "/LITSale.db");
    int oldDBVersion = await d.getVersion();
    if (DatabaseHandler.currentDBVersion != oldDBVersion) {
      await databaseFactory.deleteDatabase(path + "/LITSale.db");
    }
  }
  return openDatabase(
    join(path, 'LITSale.db'),
    onCreate: (database, version) async {
      var elements = xml.XmlDocument.parse(xmlString).findAllElements("table");
      elements.map((e) async {
        print(e.findElements("create_statement").first.text);
        try {
          // print(e.findElements("create_statement").first.text);
          // print(e.findElements("create_statement").first.value);
          // print(e.findElements("create_statement").first.innerText);
          await database
              .execute(e.findElements("create_statement").first.innerText);
        } catch (e) {
          writeToLogFile(
              text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
          print(e.toString());
        }
      }).toList();
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) {},
    onDowngrade: (Database db, int oldVersion, int newVersion) {},
    version: DatabaseHandler.currentDBVersion,
  );
}

deleteDatabase() async {
  String path = await getDatabasesPath();
  bool databaseExists =
      await databaseFactory.databaseExists(path + "/LITSale.db");
  if (databaseExists) {
    await databaseFactory.deleteDatabase(path + "/LITSale.db");
  }
}
